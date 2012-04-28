var assert, counter, end, request, url;

request = require('request');

assert = require('assert');

url = 'http://localhost:3000';

console.log('running spec test for cloudq');

counter = 0;

end = function() {
  counter--;
  if (counter === 0) return process.exit();
};

counter++;

request.post(url + '/foo', {
  json: {
    body: 'foo',
    expire: '1d'
  }
}, function(e, res, body) {
  console.log('foo');
  if (e) throw e;
  if (res.statusCode !== 201) throw new Error('Status Code is not 201');
  assert.equal(res.headers['content-type'], 'application/json');
  console.log('enqueue /');
  return end();
});

counter++;

request.get(url, {
  json: true
}, function(e, res, body) {
  console.log(res);
  if (e) throw e;
  if (res.statusCode !== 200) throw new Error('Status Code is not 200');
  assert.equal(res.headers['content-type'], 'application/json');
  assert.equal(body.length > 0, true);
  console.log('queues /');
  return end();
});
