const Home = require('./handlers/handlers')

exports.register = (plugin, options, next) => {

  plugin.route([
    { method: 'GET', path: '/orders', config: Home.orders },
    { method: 'GET', path: '/restricted', config: Home.restricted },
    { method: 'GET', path: '/{path*}', config: Home.notFound }
  ])

  next()
}

exports.register.attributes = {
  name: 'api'
}