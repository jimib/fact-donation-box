var chauffeur = require("chauffeur");
var util = require("util");

module.exports = function(app){
	//configure out routes
	app.locals = app.locals || {};
	app.locals.routes = app.routes = chauffeur(app, function(map){
		map.get("/", app.controllers.home.index, "home");
		map.get("/play", app.controllers.home.play, "play")
	});
}