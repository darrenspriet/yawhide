
var GetSobeysFlyer = Backbone.Model.extend({
	    url:  getURL('/getAllStores') 
});


/**
* Gets the Nearest Sobeys collection
* @param {options} - latitude, and longitude
* @return {collection} - Nearest Collection
*/
var GetNearestSobeys = Backbone.Collection.extend({
    initialize: function(options){
        this.elat = options.elat;
        this.elong = options.elong;
    },
    url: function(){
        return getURL('/getNearestStores/') +this.elat+'/'+this.elong;
    }
}); 


var GetOneSobeyFlyer = Backbone.Collection.extend({
    initialize: function(options){
        this.id = options.id;
    },
    url: function(){
        return getURL('/getSobeyFlyer/') +this.id;
    }
}); 

