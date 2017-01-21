const Handlers = require('./handlers/handlers')

exports.register = (plugin, options, next) => {

  plugin.route([
    { method: 'GET',  path: '/orders',     config: Handlers.orders },
    { method: 'POST', path: '/addresses',  config: Handlers.addresses},
    { method: 'GET',  path: '/restricted', config: Handlers.restricted },
    { method: 'GET',  path: '/{path*}',    config: Handlers.notFound }
  ])

  next()
}

exports.register.attributes = {
  name: 'api'
}