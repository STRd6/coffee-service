A CoffeeScript compiler as a service.

    CoffeeScript = require('coffee-script')

    express = require("express")
    app = express()
    app.use express.logger()

Tell people how to use.

    app.get '/', (request, response) ->
      response.send("POST CoffeeScript source to /")

Compile the coffee script body of requests and return the compiled JS.

    app.post '/', (req, res) ->
      data = ''
      req.setEncoding('utf8')
      req.on 'data', (chunk) ->
        data += chunk

      req.on 'end', ->
        body = CoffeeScript.compile(data)

        res.setHeader('Content-Type', 'text/javascript')
        res.setHeader('Content-Length', body.length)
        res.end(body)

Listen up server!

    port = process.env.PORT or 5000
    app.listen port, ->
      console.log("Listening on " + port)
