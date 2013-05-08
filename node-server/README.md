nodejs-basejump
===============

Simple boilerplate template for starting applications, auto loads all controllers and models into globally accessible structure without clutter using 'earlybird'. Also includes 'chauffeur' to help organise routes.

Set up:
node_modules is in the git ignore list so after pulling a copy you need to run:

npm install -d

Structure:
----------

The core code is in the app directory. Basejump uses my Earlybird module to bootstrap the application and get everything running. Earlybird itself is very basi and doesn't push any design pattern on to the developer, except that the application folder structure is directly mapped to the application object, this means that within our code we can reference our controllers by 'app.controllers.my_controller'. Making a block of code globally accessible is of completely optional and is dependent on if an object is returned by the module.exports method.

Within each directory a developer can add '.earlybird.conf' to control how modules are loaded. Within base-jump a conf file is provided in the root of 'app':

<pre>
{
	"include" : ["preinit", "models", "controllers", "init"]
	,"exclude" : ["ignoredDir"]
}
</pre>

Which causes the modules to be loaded in the following order: 

<pre>
app
	- preinit [1st]
	- models [2nd]
	- controllers [3rd]
	- init [4th]
	- ignoredDir [ignored]
</pre>

The npm package includes express, connect-flash and jade; these are all completely optional however and this should be flexible enough to adapt to any particular style of development.

Response Helpers:
-----------------

Instead of duplicating code to request the same data but in different formats, sendOrRender is used to respond with a data object, which it then uses the 'req.header.accept' to determine how the data should be sent.

Instead of this:
<pre>
	server.get('/home.html', function(req, res){
		loadData(function(err, data){
			res.render("home", {locals:{data: data}});
		});
	});
	
	server.get('/home.json', function(req, res){
		loadData(function(err, data){
			res.send(data);
		});
	});
</pre>

use this:
<pre>
	server.get('/home', function(req, res){
		loadData(function(err, data){
			res.sendOrRender(data, "home");
		});
	});
</pre>


Third Party Libraries:
----------------------

It's become my habit to use Bootstrap, JQuery and Knockout in all my projects. Being as it's a pain to keep downloading and adding these to each project I've included them into my basejump project so it's part of a project from the start.

JQuery: http://jquery.com
KnockoutJs: http://knockoutjs.com
Bootstrap: http://twitter.github.com/bootstrap
