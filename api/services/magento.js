const fetchOrders = (magento, cache) => {
  return new Promise((fulfill, reject) => {
    const cachedOrders = cache.get('orders')
    if (cachedOrders) {
      fulfill(cachedOrders)
    }

    magento.salesOrder.list((err, orders) => {
      if (err) {
        console.log(err)
        reject(err)
      } else {
        cache.put('orders', orders, 300000)
        fulfill(orders)
      }
    })
  })
}

module.exports.magento = {
  fetchOrders: fetchOrders
}