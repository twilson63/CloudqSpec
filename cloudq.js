var EventEmitter, assert, counter, ee, id, request, url;

request = require('request');

assert = require('assert');

EventEmitter = require('events').EventEmitter;

url = 'http://localhost:3000';

console.log('running spec test for cloudq');

counter = 0;

ee = new EventEmitter();

ee.on('end', function() {
  console.log('end called');
  counter--;
  if (counter === 0) return process.exit();
});

counter++;

request.post(url + '/foo', {
  json: {
    body: 'foo',
    expire: '1d'
  }
}, function(e, res, body) {
  if (e) throw e;
  if (res.statusCode !== 201) throw new Error('Status Code is not 201');
  assert.equal(res.headers['content-type'], 'application/json');
  console.log('enqueue /');
  return ee.emit('end');
});

counter++;

id = null;

request.get(url + '/foo', {
  json: true
}, function(e, res, body) {
  if (e) throw e;
  if (res.statusCode !== 200) throw new Error('Status Code is not 201');
  assert.equal(res.headers['content-type'], 'application/json');
  assert.equal(body.body, 'foo');
  assert.equal(body.expire, '1d');
  id = body._id;
  assert.ok(id);
  console.log('dequeued /');
  return ee.emit('end');
});

counter++;

request.del(url + 'foo/' + id({
  json: true
}, function(e, res, body) {
  if (e) throw e;
  if (res.statusCode !== 200) throw new Error('Status Code is not 201');
  assert.equal(res.headers['content-type'], 'application/json');
  assert.equal(body.success, true);
  console.log('complete /');
  return ee.emit('end');
}));

counter++;

request(url, {
  json: true
}, function(e, res, body) {
  if (e) throw e;
  if (res.statusCode !== 200) throw new Error('Status Code is not 200');
  assert.equal(res.headers['content-type'], 'application/json');
  assert.ok(body);
  console.log('list queues /');
  return ee.emit('end');
});
