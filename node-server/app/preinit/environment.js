var flash = require("connect-flash");
var express = require("express");

module.exports = function(app){
	app.configure(function(){
		//enable our view engine
		app.set('views', __dirname + '/../../views');
		app.set('view engine', 'jade');
		
		app.use(express.bodyParser());
		app.use(express.cookieParser('keyboard cat'));
		app.use(express.session({ cookie: { maxAge: 60000 }}));
		app.use(flash());
		
		//add a new method to res 'sendOrRender'
		app.use(function(req, res, next){
			//Add a new method to res
			res.sendOrRender = function(data, view){
				if(view && requestAcceptsHtml()){
					//send the data as html
					res.locals = res.locals || {};
					Object.merge(res.locals, data);
					res.render(view);
				}else{
					//send the data as json
					res.send(data);
				}
			}
			
			//add a helper method
			function requestAcceptsHtml(){
				try{
					var accepts = req.headers.accept.split(",");
					if(accepts && 
						((accepts.indexOf("text/html") > -1) || (accepts.indexOf("application/xhtml+xml") > -1))){
						return true;	
					}
				}catch(err){
					console.log("Error testing 'requestAcceptsHtml'", err);
				}
				return false;
			}
			
			//finished
			next();
		});
		
		
		app.use(function(req, res, next) {
			//create a set of exposed methods for the view to access certain data - won't be triggered/used until the view is rendered
	    	res.locals.flash = function() { return req.flash() };
			//now these methods have been bound - on to the next
			next();
		});
		
		app.use(app.router);
		app.use(express.static(__dirname + '/../../public'));
		app.use(express.errorHandler());
	});
	
}