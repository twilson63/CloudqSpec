request = require 'request'
assert = require 'assert'

url = 'http://localhost:3000'
console.log 'running spec test for cloudq'

counter = 0
end = ->
  counter--
  if counter is 0 then process.exit()

counter++

request.post url + '/foo'
  json: { body: 'foo', expire: '1d'}
  (e, res, body) ->
    throw e if e
    throw new Error('Status Code is not 201') if res.statusCode != 201
    assert.equal(res.headers['content-type'], 'application/json')
    console.log 'POST queue /'
    request.get url, { json: true }, (e, res, queues) ->
      throw e if e
      throw new Error('Status Code is not 200') if res.statusCode != 200
      assert.equal(res.headers['content-type'], 'application/json')
      assert.equal(queues[0].queued , 1)
      console.log 'GET queues /'
      request.get url + '/foo', { json: true }, (e, res, body) ->
        throw e if e
        throw new Error('Status Code is not 200') if res.statusCode != 200
        assert.equal(res.headers['content-type'], 'application/json')
        assert.equal(body.status, 'dequeued')
        id = body._id
        console.log 'GET dequeue /'
        request.put url + '/foo/' + id, { json: true }, (e, res, body) ->
          console.log body
          throw e if e
          throw new Error('Status Code is not 201') if res.statusCode != 201
          assert.equal(res.headers['content-type'], 'application/json')
          console.log body
          # assert.equal(body.body, 'foo')
          # assert.equal(body.expire, '1d')
          # assert.ok(id)    
          console.log 'PUT complete /'
          end()

# counter++
# 
# request.del url + 'foo/' + id
#   json: true
#   (e, res, body) ->
#     throw e if e
#     throw new Error('Status Code is not 201') if res.statusCode != 200
#     assert.equal(res.headers['content-type'], 'application/json')
#     assert.equal(body.success, true)    
#     console.log 'complete /'
#     ee.emit 'end'
# 
# counter++
# 
# request url, { json: true }, (e, res, body) ->
#   throw e if e
#   throw new Error('Status Code is not 200') if res.statusCode != 200
#   assert.equal(res.headers['content-type'], 'application/json')
#   assert.ok(body)    
#   console.log 'list queues /'
#   ee.emit 'end'
# 
