request = require 'request'
assert = require 'assert'
EventEmitter = require('events').EventEmitter

url = 'http://localhost:3000'
console.log 'running spec test for cloudq'

counter = 0
ee = new EventEmitter()
# 
ee.on 'end', ->
  counter--
  if counter is 0 then process.exit()

counter++

request.post url + '/foo'
  json: { body: 'foo', expire: '1d'}
  (e, res, body) ->
    throw e if e
    throw new Error('Status Code is not 201') if res.statusCode != 201
    assert.equal(res.headers['content-type'], 'application/json')
    console.log 'enqueue /'
    ee.emit 'end'

counter++

id = null

request.get url + '/foo'
  json: true
  (e, res, body) ->
    throw e if e
    throw new Error('Status Code is not 201') if res.statusCode != 200
    assert.equal(res.headers['content-type'], 'application/json')
    assert.equal(body.body, 'foo')
    assert.equal(body.expire, '1d')
    id = body._id
    assert.ok(id)    
    console.log 'dequeued /'
    ee.emit 'end'

counter++

request.del url + 'foo/' + id
  json: true
  (e, res, body) ->
    throw e if e
    throw new Error('Status Code is not 201') if res.statusCode != 200
    assert.equal(res.headers['content-type'], 'application/json')
    assert.equal(body.success, true)    
    console.log 'complete /'
    ee.emit 'end'

counter++

request url, { json: true }, (e, res, body) ->
  throw e if e
  throw new Error('Status Code is not 200') if res.statusCode != 200
  assert.equal(res.headers['content-type'], 'application/json')
  assert.ok(body)    
  console.log 'list queues /'
  ee.emit 'end'

