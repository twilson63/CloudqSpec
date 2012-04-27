request = require 'request'
assert = require 'assert'
EventEmitter = require('events').EventEmitter

url = 'http://localhost:3000'
console.log 'running spec test for ding'

counter = 0
ee = new EventEmitter()
# 
ee.on 'end', ->
  counter--
  if counter is 0 then process.exit()

counter++

id = null

# create ding for an e-mail
request.post url + '/dings'
  json: { event: 'foo-bar', actions: [{type: 'email', meta: {to:'foo@bar.com'}}]}  
  (e, res, body) ->
    throw e if e
    throw new Error('Status Code is not 201') if res.statusCode != 201
    assert.equal(res.headers['content-type'], 'application/json')
    id = b._id
    console.log 'add ding /'
    ee.emit 'end'

# get ding 
counter++

request.get url + '/dings/' + id, json: true, (e, res, body) ->
  throw e if e
  throw new Error('Status Code is not 200') if res.statusCode != 200
  assert.equal(res.headers['content-type'], 'application/json')
  console.log 'get ding by id /'
  ee.emit 'end'

# get all dings
counter++

request.get url + '/dings', json: true, (e, res, body) ->
  throw e if e
  throw new Error('Status Code is not 200') if res.statusCode != 200
  assert.equal(res.headers['content-type'], 'application/json')
  console.log 'get dings /'
  ee.emit 'end'

#update ding
counter++

request.put url + '/dings/' + id, json: {event: 'foo-bar'}, (e, res, body) ->
  throw e if e
  throw new Error('Status Code is not 200') if res.statusCode != 200
  assert.equal(res.headers['content-type'], 'application/json')
  console.log 'update ding /'
  ee.emit 'end'

# delete ding
counter++

request.del url + '/dings/' + id, json: true, (e, res, body) ->
  throw e if e
  throw new Error('Status Code is not 200') if res.statusCode != 200
  assert.equal(res.headers['content-type'], 'application/json')
  console.log 'remove ding /'
  ee.emit 'end'

# generate event

request.post url + '/events', json: true, (e, res, body) ->
  throw e if e
  throw new Error('Status Code is not 201') if res.statusCode != 201
  assert.equal(res.headers['content-type'], 'application/json')
  console.log 'trigger event /'
  ee.emit 'end'
