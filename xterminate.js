var EventEmitter, assert, counter, ee, id, request, url;

request = require('request');

assert = require('assert');

EventEmitter = require('events').EventEmitter;

url = 'http://localhost:3000';

console.log('running spec test for xterminate');

counter = 0;

ee = new EventEmitter();

ee.on('end', function() {
  counter--;
  if (counter === 0) return process.exit();
});

counter++;

id = null;

request.post(url + '/xterms', {
  json: {
    resource: 'Widget',
    source: 'couch',
    target: 'http://localhost:5984/db'
  }
}, function(e, res, body) {
  if (e) throw e;
  if (res.statusCode !== 201) throw new Error('Status Code is not 201');
  assert.equal(res.headers['content-type'], 'application/json');
  id = b._id;
  console.log('add term /');
  return ee.emit('end');
});

counter++;

request.get(url + '/xterms', {
  json: true
}, function(e, res, body) {
  if (e) throw e;
  if (res.statusCode !== 200) throw new Error('Status Code is not 200');
  assert.equal(res.headers['content-type'], 'application/json');
  console.log('get all xterms /');
  return ee.emit('end');
});

request.get(url + '/xterms/' + id({
  json: true
}, function(e, res, body) {
  if (e) throw e;
  if (res.statusCode !== 200) throw new Error('Status Code is not 200');
  assert.equal(res.headers['content-type'], 'application/json');
  id = b._id;
  console.log('get xterm /');
  return ee.emit('end');
}));

counter++;

request.put(url + '/xterms/' + id({
  json: {
    resource: 'Widget',
    source: 'couch',
    target: 'http://localhost:5984/db2'
  }
}, function(e, res, body) {
  if (e) throw e;
  if (res.statusCode !== 200) throw new Error('Status Code is not 200');
  assert.equal(res.headers['content-type'], 'application/json');
  console.log('update xterm /');
  return ee.emit('end');
}));

counter++;

request.del(url + '/xterms/' + id({
  json: true
}, function(e, res, body) {
  if (e) throw e;
  if (res.statusCode !== 200) throw new Error('Status Code is not 200');
  assert.equal(res.headers['content-type'], 'application/json');
  console.log('delete xterm /');
  return ee.emit('end');
}));
