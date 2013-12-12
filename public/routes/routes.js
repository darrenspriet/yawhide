/*Instantiate */
var Router = Backbone.Router.extend({
	routes:{
		"":"index"
		, "nearestStores":"nearestStores"
		, "storeInfo/:id": "storeInfo"
		, "viewFlyer/:id": "viewFlyer"
	}
});

/* START ROUTER */
var app_router = new Router();


/* Actions */
app_router.on('route:index', function (){
	console.log("Router is taking you to index page");
	index.render();
});

app_router.on('route:nearestStores', function (){
	console.log("Router is taking you to nearestStores page");
	nearestStores.render();
});

app_router.on('route:storeInfo', function (id){
	console.log("Router is taking you to storeInfo page with id: "+id);
	storeInfo.render(id);
});

app_router.on('route:viewFlyer', function (id){
	console.log("Router is taking you to viewFlyer page with id: "+id);
	viewFlyer.render(id);
});