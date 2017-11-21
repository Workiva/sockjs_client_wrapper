var http = require('http');
var sockjs = require('sockjs');

var options = {
    heartbeat_delay: 5000,
    sockjs_url: 'https://cdn.jsdelivr.net/sockjs/1.1.4/sockjs.min.js',
};
var echo = sockjs.createServer(options);
echo.on('connection', function(conn) {
    conn.on('data', function(message) {
        conn.write(message);
    });
    conn.on('close', function() {});
});

var server = http.createServer();
echo.installHandlers(server, {prefix:'/echo'});
server.listen(9999, '0.0.0.0');
