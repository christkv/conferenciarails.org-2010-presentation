require.paths.unshift('/usr/local/lib/node');
require.paths.unshift('/Users/christian.kvalheim/coding/checkouts/node-mysql-libmysqlclient');

var Connect = require('connect'),
  sys = require('sys'),
  fugue = require('fugue'),
  http =   require('http');

var
  mysql = require('mysql-libmysqlclient'),
  conn,
  result,
  row,
  rows;

var Client = require('mysql').Client;

var connections = [];
var index = 0;
var number_of_connections = 30;

// create 100 mysql connections to round robin over
for(var i = 0; i < number_of_connections; i++) {
  connections[i] = new Client();
  connections[i].user = 'root'
  connections[i].password = ''
  connections[i].connect(function(err, r) {
    sys.puts("==== connected " + err)
  });
}

// Create a node js server
var server = http.createServer(function(request, response) {
  var client = connections[index];
  index = (index + 1) % number_of_connections;

  client.query("select sleep(0.2)", function(err, r) {
    response.writeHead(200, {'Content-Type': 'text/plain'});
    response.end('Hello World\n');
  });  
});

fugue.start(server, 3000, null, 2, {verbose : false});
// server.listen(3000)