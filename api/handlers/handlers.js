const Joi = require('joi')
const Boom = require('boom')
const magento = require('../services/magento.js').magento

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
    magento.fetchOrders()
        .then((data) => reply({
          results: (page(data, query.page, query.limit)),
          totalCount: data.length
        }))
        .catch(() => reply(Boom.serverUnavailable('Currently unable to fetch orders :(')))
  }
}

/**
 * TODO:
 *  Find out why addresses returned from orders keep returning:
     `{ [Magento Error: Address not exists.]
      code: 102,
      faultCode: 102,
      faultString: 'Address not exists.',
      original: { message: 'XML-RPC fault: Address not exists.', name: 'Error' },
      name: 'Magento Error',
      message: 'Address not exists.' }
     `
 * /api/addresses endpoint handler
 * @type {{handler: exports.addresses.handler}}
 */
module.exports.addresses = {
  validate: {
    payload: {
      addressIds: Joi.array().items(Joi.string())
    }
  },

  handler: function ({payload}, reply) {
    magento.fetchAddresses(payload['addressIds'])
        .then((data) => reply(data))
        .catch(() => reply(Boom.serverUnavailable('Currently unable to fetch addresses :(')))
  }
}

/**
 * /api/orders endpoint handler
 * @type {{handler: exports.orders.handler}}
 */
module.exports.orders = {
  handler: function ({query}, reply) {
    magento.fetchOrders()
        .then((data) => reply({
          results: (page(data, query.page, query.limit)),
          totalCount: data.length
        }))
        .catch(() => reply(Boom.serverUnavailable('Currently unable to fetch orders :(')))
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