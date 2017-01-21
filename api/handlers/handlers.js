const Boom = require('boom')
const cache = require('memory-cache')
const MagentoAPI = require('magento-xmlrpc')
const helpers = require('../services/magento.js').magento
const magento = new MagentoAPI({
  host: 'www-test.unumotors.com',
  port: 443,
  path: '/en/api/xmlrpc/',
  login: 'unu-challenge',
  pass: 'unu-challenge'
})

magento.login((err) => {
  if (err) {
    console.log(err)
  }
})

/**
 * Returns array contents delimited by page and requested limit.
 * @param arr Array
 * @param page Page number
 * @param limit Number of results
 * @returns {ArrayBuffer|Blob|Array.<T>|string}
 */
const page = (arr, page, limit) => {
  const start = page > 1 ? ((page - 1) * limit) : 0
  const end = (page * limit)
  return arr.slice(start, end)
}

/**
 * /api/orders endpoint handler
 * @type {{handler: exports.orders.handler}}
 */
module.exports.orders = {
  handler: function ({query}, reply) {
    helpers.fetchOrders(magento, cache)
        .then((data) => reply.paginate(page(data, query.page, query.limit)),
            (err) => Boom.wrap(err, 500))
  }
}

/**
 * Handler for restricted endpoints.
 * @type {{auth: string, handler: exports.restricted.handler}}
 */
module.exports.restricted = {
  auth: 'jwt',
  handler: function (request, reply) {
    return reply({result: 'Restricted!'})
  }
}

/**
 * Handler for unknown routes.
 * @type {{handler: exports.notFound.handler}}
 */
module.exports.notFound = {
  handler: function (request, reply) {
    return reply({result: 'Oops, 404 Page!'}).code(404)
  }
}