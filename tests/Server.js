// A local server to use with the unit tests.
var fs = require('fs'),
	child_process = require('child_process'),
	http = require('http'),
	util = require('util');

console.log('Creating Server');

http.createServer(function (req, res) {
	res.writeHead(200, {'Content-Type': 'text/plain'});
	switch(req.url){
		case '/post':
			// Act like an echo command
			req.on('data', function(chunk) {
				res.write(chunk);
			});

			req.on('end', function() {
				res.end();
			});
			break;
		case '/head':
			// Check that the incoming request states that its payload is
			// text/xml encoded with UTF-8 encoding
			if (req.headers['content-type'] == 'text/xml;charset="utf-8"')
				res.end('ok');
			else
				res.end('fail');
			break;
		default:
			res.write('Hello World\n');
			res.end();
	}
}).listen(1337, "127.0.0.1");
console.log('Server running at http://127.0.0.1:1337/');

console.log('Spawning Testrunner');
	var test_runner = child_process.spawn('neko', ['run_tests.n'], {
	cwd: process.cwd()
});

// util.pump() might seem more natural, but it closes stdout of process on end
test_runner.stdout.setEncoding('utf8');
	test_runner.stdout.on('data', function (data) {
	process.stdout.write(data);
});

test_runner.on('exit', function (code) {
	console.log('Testrunner exited with code ' + code);
	console.log('Shutting down Server...');
	process.exit();
});

