module.exports = function(app){
	//override listen method
	var server = require('http').createServer(app)
	  ,io = require('socket.io').listen(server, {log: false, port: 80, rememberTransport: false, transports:["websocket", "flashsocket", "htmlfile", "xhr-polling", "jsonp-polling"]});

	app.io = io;

	app.io.sockets.on("connection", function(socket){
		console.log("connection");
		socket.emit("msg", {msg:"Connected to DonationsBox Server"});
		socket.on("disconnect", function(){
			console.log("disconnected");
		})
	});

	app.listen = function(port){
		server.listen(port);
	}
}