module.exports = function(app){
	var viewsDir = "home/";
	
	return{
		index : function(req, res, next){
			res.render(viewsDir + "index");
		},
		play : function(req, res, next){
			//we will be told which screen we want to target and the video we want to play
			var idScreen = req.query.idScreen;
			var srcVideo = req.query.srcVideo;
			//now emit this request out to the connected screens
			console.log(idScreen, srcVideo);
			app.io.sockets.emit("play", {idScreen:idScreen, srcVideo:srcVideo});
			res.send({status:"ok"});
		}
	}
}