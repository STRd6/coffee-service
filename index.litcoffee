A CoffeeScript compiler as a service.

    CoffeeScript = require('coffee-script')

    http = require('request')
    express = require("express")
    app = express()
    app.use express.logger()

    compile = (streamOrData, out) ->
      finish = ->
        try
          body = CoffeeScript.compile(data)
          console.log body
          out.setHeader('Content-Type', 'text/javascript')
          out.setHeader('Content-Length', body.length)
          out.end(body)
        catch err
          console.log err
          out.status(400)

      if typeof streamOrData is "string"
        data = streamOrData
        finish()
      else
        stream = streamOrData
        stream.setEncoding('utf8')
        stream.on 'data', (chunk) ->
          data += chunk
        stream.on 'end', finish

Get from a url or tell people how to use.

    app.get '/', (request, response) ->
      if url = request.query.url
        console.log "URL: #{url}"
        http.get url, (error, resp, body) ->
          compile(body, response)
      else
        message """
          GET /?url=some.coffeesource/yolo
          POST CoffeeScript source to /
        """

        response.send(message)

Compile from a url on the web.

Compile the coffee script body of requests and return the compiled JS.

    app.post '/', (req, res) ->
      compile req, res

Listen up server!

    port = process.env.PORT or 5000
    app.listen port, ->
      console.log("Listening on " + port)
