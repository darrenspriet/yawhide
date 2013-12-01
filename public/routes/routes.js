/*Instantiate */
var Router = Backbone.Router.extend({
    routes:{
        "index":"index",
        
    }
});

/* START ROUTER */
var app_router = new Router();


/* Actions */
app_router.on('route:index', function(){
    console.log("Router is taking you to index page");
    index.render();
});