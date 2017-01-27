const cache = require('memory-cache')
const MagentoAPI = require('magento-xmlrpc')
const magento = new MagentoAPI({
  host: 'www-test.unumotors.com',
  port: 443,
  path: '/en/api/xmlrpc/',
  login: '',
  pass: ''
})

/**
 * Retrieves customer orders from magento.
 * Accepts parameters in a curried manner.
 * @param magento Configured MagentoAPI object
 * @param cache Memory cache
 */
const fetchOrders = magento => cache => () => {
  return new Promise((fulfill, reject) => {
    const cachedOrders = cache.get('orders')
    if (cachedOrders) {
      fulfill(cachedOrders)
    }

    magento.login((err) => {
      if (err) {
        console.error(err)
        reject(err)
      } else {
        magento.salesOrder.list((err, orders) => {
          if (err) {
            console.error(err)
            reject(err)
          } else {
            // Cache orders for 5 minutes
            cache.put('orders', orders, 300000)
            fulfill(orders)
          }
        })
      }
    })

  })
}

/**
 * Fetch a single address from Magento.
 * @param magento Configured MagentoAPI object
 * @param addrId String
 * @returns {Promise}
 */
const fetchAddress = (magento, addrId) => {
  return new Promise((fulfill, reject) => {
    magento.customerAddress.info({addressId: addrId}, (err, addr) => {
      console.log(addrId)
      if (err) {
        console.error(err)
        reject(err)
      } else {
        fulfill(addr)
      }
    })
  })
}

/**
 * Fetch a bunch of addresses from Magento.
 * @param magento Configured MagentoAPI object
 * @param addressIds Array of IDs
 */
const fetchAddresses = magento => (addressIds) => {
  return new Promise((fulfill, reject) => {
    magento.login((err) => {
      if (err) {
        console.error(err)
        reject(err)
      } else {
        const addresses = addressIds.map((i) => fetchAddress(magento, i))
        Promise.all(addresses).then(values => {
          fulfill(values)
        }).catch((err) => reject(err))
      }
    })
  })
}

module.exports.magento = {
  fetchOrders: fetchOrders(magento)(cache),
  fetchAddresses: fetchAddresses(magento)
}
