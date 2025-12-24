// 添加到购物车
function addToCart(productId) {
    addToCartWithQuantity(productId, 1);
}

// 添加到购物车（带数量）
function addToCartWithQuantity(productId, quantity) {
    fetch('/cart/add', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'productId=' + productId + '&quantity=' + quantity
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            alert('添加成功！');
        } else {
            alert(data.message);
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('操作失败，请先登录');
    });
}





