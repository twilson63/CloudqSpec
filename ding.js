var EventEmitter, assert, counter, ee, id, request, url;

request = require('request');

assert = require('assert');

EventEmitter = require('events').EventEmitter;

url = 'http://localhost:3000';

console.log('running spec test for ding');

counter = 0;

ee = new EventEmitter();

ee.on('end', function() {
  counter--;
  if (counter === 0) return process.exit();
});

counter++;

id = null;

request.post(url + '/dings', {
  json: {
    event: 'foo-bar',
    actions: [
      {
        type: 'email',
        meta: {
          to: 'foo@bar.com'
        }
      }
    ]
  }
}, function(e, res, body) {
  if (e) throw e;
  if (res.statusCode !== 201) throw new Error('Status Code is not 201');
  assert.equal(res.headers['content-type'], 'application/json');
  id = b._id;
  console.log('add ding /');
  return ee.emit('end');
});

counter++;

request.get(url + '/dings/' + id, {
  json: true
}, function(e, res, body) {
  if (e) throw e;
  if (res.statusCode !== 200) throw new Error('Status Code is not 200');
  assert.equal(res.headers['content-type'], 'application/json');
  console.log('get ding by id /');
  return ee.emit('end');
});

counter++;

request.get(url + '/dings', {
  json: true
}, function(e, res, body) {
  if (e) throw e;
  if (res.statusCode !== 200) throw new Error('Status Code is not 200');
  assert.equal(res.headers['content-type'], 'application/json');
  console.log('get dings /');
  return ee.emit('end');
});

counter++;

request.put(url + '/dings/' + id, {
  json: {
    event: 'foo-bar'
  }
}, function(e, res, body) {
  if (e) throw e;
  if (res.statusCode !== 200) throw new Error('Status Code is not 200');
  assert.equal(res.headers['content-type'], 'application/json');
  console.log('update ding /');
  return ee.emit('end');
});

counter++;

request.del(url + '/dings/' + id, {
  json: true
}, function(e, res, body) {
  if (e) throw e;
  if (res.statusCode !== 200) throw new Error('Status Code is not 200');
  assert.equal(res.headers['content-type'], 'application/json');
  console.log('remove ding /');
  return ee.emit('end');
});

request.post(url + '/events', {
  json: true
}, function(e, res, body) {
  if (e) throw e;
  if (res.statusCode !== 201) throw new Error('Status Code is not 201');
  assert.equal(res.headers['content-type'], 'application/json');
  console.log('trigger event /');
  return ee.emit('end');
});
