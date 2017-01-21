const Joi = require('joi')

const envKey = key => {
  const env = process.env.NODE_ENV || 'development'

  const configuration = {
    development: {
      host: 'localhost',
      port: 8000
    },
    uat: {
      host: 'localhost',
      port: 8010
    },
    // These should match environment variables on hosted server
    production: {
      host: process.env.HOST,
      port: process.env.PORT
    }
  }

  return configuration[env][key]
}

const manifest = {
  connections: [
    {
      host: envKey('host'),
      port: envKey('port'),
      routes: {
        cors: true
      },
      router: {
        stripTrailingSlash: true
      }
    }
  ],
  registrations: [
    {
      plugin: 'hapi-auth-jwt2'
    },
    {
      plugin: './auth'
    },
    {
      plugin: './api',
      options: {routes: {prefix: '/api'}}
    },
    {
      plugin: {
        register: 'hapi-pagination',
        options: {
          routes: { include: ['/api/orders']}
        },
        validate: {
          query: {
            limit: Joi.number().integer(),
            page: Joi.number().integer(),
            pagination: Joi.boolean()
          }
        }
      }
    },
    {
      plugin: {
        register: 'good',
        options: {
          ops: {interval: 60000},
          reporters: {
            console: [
              {module: 'good-squeeze', name: 'Squeeze', args: [{error: '*'}]}, {module: 'good-console'}, 'stdout'
            ]
          }
        }
      }
    }
  ]
}

module.exports = manifest