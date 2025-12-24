package com.shop.controller;

import com.shop.entity.BrowseLog;
import com.shop.entity.Product;
import com.shop.entity.User;
import com.shop.service.BrowseLogService;
import com.shop.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/product")
public class ProductController {
    
    @Autowired
    private ProductService productService;
    
    @Autowired
    private BrowseLogService browseLogService;

    @RequestMapping("/list")
    public String list(Model model) {
        List<Product> products = productService.getAllProducts();
        model.addAttribute("products", products);
        return "product/list";
    }

    @RequestMapping("/search")
    public String search(String keyword, Model model) {
        List<Product> products;
        if (keyword != null && !keyword.trim().isEmpty()) {
            // 有搜索关键词时，执行搜索
            products = productService.searchProducts(keyword.trim());
            model.addAttribute("keyword", keyword.trim());
        } else {
            // 没有搜索关键词时，显示所有商品
            products = productService.getAllProducts();
        }
        model.addAttribute("products", products);
        return "product/list";
    }

    @RequestMapping("/category")
    public String category(String category, Model model) {
        List<Product> products = productService.getProductsByCategory(category);
        model.addAttribute("products", products);
        model.addAttribute("category", category);
        return "product/list";
    }

    @RequestMapping("/detail")
    public String detail(Integer id, Model model, HttpSession session, HttpServletRequest request) {
        Product product = productService.getProductById(id);
        model.addAttribute("product", product);
        
        // 记录浏览日志
        if (product != null) {
            BrowseLog browseLog = new BrowseLog();
            User user = (User) session.getAttribute("user");
            if (user != null) {
                browseLog.setUserId(user.getId());
            }
            browseLog.setProductId(product.getId());
            // 获取客户端IP地址
            String ipAddress = getClientIpAddress(request);
            browseLog.setIpAddress(ipAddress);
            browseLogService.addBrowseLog(browseLog);
        }
        
        return "product/detail";
    }
    
    /**
     * 获取客户端IP地址
     */
    private String getClientIpAddress(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }

    @RequestMapping(value = "/api/list", method = RequestMethod.GET)
    @ResponseBody
    public Map<String, Object> apiList() {
        Map<String, Object> result = new HashMap<>();
        List<Product> products = productService.getAllProducts();
        result.put("success", true);
        result.put("data", products);
        return result;
    }

    @RequestMapping(value = "/api/search", method = RequestMethod.GET)
    @ResponseBody
    public Map<String, Object> apiSearch(String keyword) {
        Map<String, Object> result = new HashMap<>();
        List<Product> products = productService.searchProducts(keyword);
        result.put("success", true);
        result.put("data", products);
        return result;
    }
}


