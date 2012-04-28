request = require 'request'
assert = require 'assert'
EventEmitter = require('events').EventEmitter

url = 'http://localhost:3000'
console.log 'running spec test for xterminate'

counter = 0
ee = new EventEmitter()
# 
ee.on 'end', ->
  counter--
  if counter is 0 then process.exit()

counter++

id = null

# create xterm to expire widgets
request.post url + '/xterms'
  json: { resource: 'Widget', source: 'couch', target: 'http://localhost:5984/db'}  
  (e, res, body) ->
    throw e if e
    throw new Error('Status Code is not 201') if res.statusCode != 201
    assert.equal(res.headers['content-type'], 'application/json')
    id = b._id
    console.log 'add term /'
    ee.emit 'end'

counter++

# get all xterms 
request.get url + '/xterms'
  json: true  
  (e, res, body) ->
    throw e if e
    throw new Error('Status Code is not 200') if res.statusCode != 200
    assert.equal(res.headers['content-type'], 'application/json')
    console.log 'get all xterms /'
    ee.emit 'end'

# get xterm 
request.get url + '/xterms/' + id
  json: true  
  (e, res, body) ->
    throw e if e
    throw new Error('Status Code is not 200') if res.statusCode != 200
    assert.equal(res.headers['content-type'], 'application/json')
    id = b._id
    console.log 'get xterm /'
    ee.emit 'end'

counter++

# update xterm 
request.put url + '/xterms/' + id
  json: { resource: 'Widget', source: 'couch', target: 'http://localhost:5984/db2'}  
  (e, res, body) ->
    throw e if e
    throw new Error('Status Code is not 200') if res.statusCode != 200
    assert.equal(res.headers['content-type'], 'application/json')
    console.log 'update xterm /'
    ee.emit 'end'

counter++

# delete xterm 
request.del url + '/xterms/' + id
  json: true  
  (e, res, body) ->
    throw e if e
    throw new Error('Status Code is not 200') if res.statusCode != 200
    assert.equal(res.headers['content-type'], 'application/json')
    console.log 'delete xterm /'
    ee.emit 'end'

