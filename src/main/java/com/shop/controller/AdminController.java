package com.shop.controller;

import com.shop.entity.BrowseLog;
import com.shop.entity.Order;
import com.shop.entity.Product;
import com.shop.entity.PurchaseLog;
import com.shop.entity.User;
import com.shop.service.BrowseLogService;
import com.shop.service.OrderService;
import com.shop.service.ProductService;
import com.shop.service.PurchaseLogService;
import com.shop.service.UserService;
import com.shop.util.EmailUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Controller
@RequestMapping("/admin")
public class AdminController {
    
    @Autowired
    private ProductService productService;
    
    @Autowired
    private OrderService orderService;
    
    @Autowired
    private EmailUtil emailUtil;
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private BrowseLogService browseLogService;
    
    @Autowired
    private PurchaseLogService purchaseLogService;

    // 检查管理员权限
    private boolean checkAdmin(HttpSession session) {
        User user = (User) session.getAttribute("user");
        return user != null && "admin".equals(user.getRole());
    }

    @RequestMapping("/product/list")
    public String productList(HttpSession session, Model model) {
        if (!checkAdmin(session)) {
            return "redirect:/index.jsp";
        }
        List<Product> products = productService.getAllProducts();
        model.addAttribute("products", products);
        return "admin/product/list";
    }

    @RequestMapping("/product/add")
    public String productAddPage() {
        return "admin/product/add";
    }

    @RequestMapping(value = "/product/add", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> productAdd(
            @RequestParam("name") String name,
            @RequestParam(value = "description", required = false) String description,
            @RequestParam("price") String priceStr,
            @RequestParam("stock") String stockStr,
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
            @RequestParam(value = "status", defaultValue = "1") String statusStr,
            HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        if (!checkAdmin(session)) {
            result.put("success", false);
            result.put("message", "无权限");
            return result;
        }
        
        // 验证必填字段
        if (name == null || name.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "商品名称不能为空");
            return result;
        }
        
        try {
            Product product = new Product();
            product.setName(name.trim());
            product.setDescription(description);
            product.setPrice(new BigDecimal(priceStr));
            product.setStock(Integer.parseInt(stockStr));
            product.setCategory(category);
            product.setStatus(Integer.parseInt(statusStr));
            
            // 处理图片上传
            if (imageFile != null && !imageFile.isEmpty()) {
                String uploadPath = session.getServletContext().getRealPath("/images");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                
                String originalFilename = imageFile.getOriginalFilename();
                String extension = "";
                if (originalFilename != null && originalFilename.contains(".")) {
                    extension = originalFilename.substring(originalFilename.lastIndexOf("."));
                }
                String filename = UUID.randomUUID().toString() + extension;
                File file = new File(uploadDir, filename);
                imageFile.transferTo(file);
                product.setImage("/images/" + filename);
            } else {
                product.setImage("/images/default.jpg");
            }
            
            if (productService.addProduct(product)) {
                result.put("success", true);
                result.put("message", "添加成功");
            } else {
                result.put("success", false);
                result.put("message", "添加失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "添加失败：" + e.getMessage());
        }
        return result;
    }

    @RequestMapping("/product/edit")
    public String productEditPage(Integer id, HttpSession session, Model model) {
        if (!checkAdmin(session)) {
            return "redirect:/index.jsp";
        }
        Product product = productService.getProductById(id);
        model.addAttribute("product", product);
        return "admin/product/edit";
    }

    @RequestMapping(value = "/product/update", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> productUpdate(
            @RequestParam("id") String idStr,
            @RequestParam("name") String name,
            @RequestParam(value = "description", required = false) String description,
            @RequestParam("price") String priceStr,
            @RequestParam("stock") String stockStr,
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
            @RequestParam(value = "status", defaultValue = "1") String statusStr,
            HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        if (!checkAdmin(session)) {
            result.put("success", false);
            result.put("message", "无权限");
            return result;
        }
        
        try {
            Integer id = Integer.parseInt(idStr);
            Product existingProduct = productService.getProductById(id);
            if (existingProduct == null) {
                result.put("success", false);
                result.put("message", "商品不存在");
                return result;
            }
            
            Product product = new Product();
            product.setId(id);
            product.setName(name.trim());
            product.setDescription(description);
            product.setPrice(new BigDecimal(priceStr));
            product.setStock(Integer.parseInt(stockStr));
            product.setCategory(category);
            product.setStatus(Integer.parseInt(statusStr));
            
            // 处理图片上传
            if (imageFile != null && !imageFile.isEmpty()) {
                String uploadPath = session.getServletContext().getRealPath("/images");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                
                String originalFilename = imageFile.getOriginalFilename();
                String extension = "";
                if (originalFilename != null && originalFilename.contains(".")) {
                    extension = originalFilename.substring(originalFilename.lastIndexOf("."));
                }
                String filename = UUID.randomUUID().toString() + extension;
                File file = new File(uploadDir, filename);
                imageFile.transferTo(file);
                product.setImage("/images/" + filename);
            } else {
                // 如果没有上传新图片，保持原有图片路径
                product.setImage(existingProduct.getImage());
            }
            
            if (productService.updateProduct(product)) {
                result.put("success", true);
                result.put("message", "更新成功");
            } else {
                result.put("success", false);
                result.put("message", "更新失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "更新失败：" + e.getMessage());
        }
        return result;
    }

    @RequestMapping(value = "/product/delete", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> productDelete(Integer id, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        if (!checkAdmin(session)) {
            result.put("success", false);
            result.put("message", "无权限");
            return result;
        }
        if (productService.deleteProduct(id)) {
            result.put("success", true);
            result.put("message", "删除成功");
        } else {
            result.put("success", false);
            result.put("message", "删除失败");
        }
        return result;
    }

    @RequestMapping("/order/list")
    public String orderList(HttpSession session, Model model) {
        if (!checkAdmin(session)) {
            return "redirect:/index.jsp";
        }
        List<Order> orders = orderService.getAllOrders();
        model.addAttribute("orders", orders);
        return "admin/order/list";
    }

    @RequestMapping("/order/detail")
    public String orderDetail(Integer id, HttpSession session, Model model) {
        if (!checkAdmin(session)) {
            return "redirect:/index.jsp";
        }
        Order order = orderService.getOrderById(id);
        model.addAttribute("order", order);
        return "admin/order/detail";
    }

    @RequestMapping(value = "/order/ship", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> shipOrder(Integer orderId, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        if (!checkAdmin(session)) {
            result.put("success", false);
            result.put("message", "无权限");
            return result;
        }
        Order order = orderService.getOrderById(orderId);
        if (order == null) {
            result.put("success", false);
            result.put("message", "订单不存在");
            return result;
        }
        if (orderService.shipOrder(orderId)) {
            // 发送邮件通知
            User user = order.getUser();
            if (user != null && user.getEmail() != null) {
                String subject = "订单发货通知";
                String content = "您的订单 " + order.getOrderNo() + " 已发货，请注意查收！";
                emailUtil.sendEmail(user.getEmail(), subject, content);
            }
            result.put("success", true);
            result.put("message", "发货成功，已发送邮件通知");
        } else {
            result.put("success", false);
            result.put("message", "发货失败");
        }
        return result;
    }

    @RequestMapping("/statistics")
    public String statistics(HttpSession session, Model model) {
        if (!checkAdmin(session)) {
            return "redirect:/index.jsp";
        }
        List<Order> allOrders = orderService.getAllOrders();
        
        // 统计信息
        int totalOrders = allOrders.size();
        BigDecimal totalRevenue = BigDecimal.ZERO;
        int pendingOrders = 0;
        int paidOrders = 0;
        int shippedOrders = 0;
        int completedOrders = 0;
        
        for (Order order : allOrders) {
            if ("completed".equals(order.getStatus()) || "shipped".equals(order.getStatus()) || "paid".equals(order.getStatus())) {
                totalRevenue = totalRevenue.add(order.getTotalAmount());
            }
            switch (order.getStatus()) {
                case "pending":
                    pendingOrders++;
                    break;
                case "paid":
                    paidOrders++;
                    break;
                case "shipped":
                    shippedOrders++;
                    break;
                case "completed":
                    completedOrders++;
                    break;
            }
        }
        
        model.addAttribute("totalOrders", totalOrders);
        model.addAttribute("totalRevenue", totalRevenue);
        model.addAttribute("pendingOrders", pendingOrders);
        model.addAttribute("paidOrders", paidOrders);
        model.addAttribute("shippedOrders", shippedOrders);
        model.addAttribute("completedOrders", completedOrders);
        
        return "admin/statistics";
    }

    @RequestMapping("/customer/list")
    public String customerList(HttpSession session, Model model) {
        if (!checkAdmin(session)) {
            return "redirect:/index.jsp";
        }
        List<User> customers = userService.getAllCustomers();
        model.addAttribute("customers", customers);
        return "admin/customer/list";
    }

    @RequestMapping("/customer/detail")
    public String customerDetail(Integer id, HttpSession session, Model model) {
        if (!checkAdmin(session)) {
            return "redirect:/index.jsp";
        }
        User customer = userService.findById(id);
        if (customer == null || !"customer".equals(customer.getRole())) {
            return "redirect:/admin/customer/list";
        }
        model.addAttribute("customer", customer);
        return "admin/customer/detail";
    }

    @RequestMapping("/customer/browseLogs")
    public String customerBrowseLogs(Integer userId, HttpSession session, Model model) {
        if (!checkAdmin(session)) {
            return "redirect:/index.jsp";
        }
        User customer = userService.findById(userId);
        if (customer == null || !"customer".equals(customer.getRole())) {
            return "redirect:/admin/customer/list";
        }
        List<BrowseLog> browseLogs = browseLogService.getBrowseLogsByUserIdWithProduct(userId);
        model.addAttribute("customer", customer);
        model.addAttribute("browseLogs", browseLogs);
        return "admin/customer/browseLogs";
    }

    @RequestMapping("/customer/purchaseLogs")
    public String customerPurchaseLogs(Integer userId, HttpSession session, Model model) {
        if (!checkAdmin(session)) {
            return "redirect:/index.jsp";
        }
        User customer = userService.findById(userId);
        if (customer == null || !"customer".equals(customer.getRole())) {
            return "redirect:/admin/customer/list";
        }
        List<PurchaseLog> purchaseLogs = purchaseLogService.getPurchaseLogsByUserIdWithProduct(userId);
        model.addAttribute("customer", customer);
        model.addAttribute("purchaseLogs", purchaseLogs);
        return "admin/customer/purchaseLogs";
    }
}


