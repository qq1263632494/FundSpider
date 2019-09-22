redis = require 'redis'
client = redis.createClient '6379', '127.0.0.1'

client.on 'error', (err)->
    console.log err

client.get '001237', (err, data)->
    console.log data
    client.quit()

client.get '000001', (err, data)->
    console.log data
    client.quit()