var IndexView = Backbone.View.extend({
	el:' #page_container',
		events: {
		"click #findFlyers": "findFlyersPage"
	},
	render: function(){
				$.get('templates/home.html', function(incomingTemplate){
					var template = Handlebars.compile(incomingTemplate);
					$('#page_container').html(template()).trigger('create');
				});
				return this;
	}, 
	findFlyersPage: function(){
		                	app_router.navigate('#/nearestStores', {trigger: true});

	}
});

NearestStoresView = Backbone.View.extend({
	el:' #page_container',

	render: function(){
		getLocation(function (loc){
			var nearestSobeysStores = new GetNearestSobeys({elat: loc.latitude, elong: loc.longitude, maxD:50});
			//var nearestSobeysStores =  new GetOneSobeyFlyer();
			nearestSobeysStores.fetch({
				success: function(){
					 console.log(nearestSobeysStores);
					 var storesArray = new Array();
					 for(var i=0;i<nearestSobeysStores.length;i++){
					 		var storeObj = new Object({
					 			"storeName" : nearestSobeysStores.models[i].attributes.storeName,
					 			"storeNumber" : nearestSobeysStores.models[i].attributes.storeNumber
					 		});
					 		storesArray.push(storeObj);
					 }
					 console.log(storesArray);

					$.get('../templates/nearestStores.html', function(incomingTemplate){
						var template = Handlebars.compile(incomingTemplate);
						$('#page_container').html(template).trigger('create');
						google.maps.event.addDomListener(window, 'load', initializeMap(loc.latitude, loc.longitude));
						var incomingStores =
						    			"<table>"+
    									"{{#storesArray}}"+
    									"<tr><td>{{storeName}}</td><td>{{storeNumber}}</td></tr>"+
    									"{{/storesArray}}"+
    									"</table>";

						var html = Mustache.to_html(incomingStores,{storesArray:storesArray} );
						$('#stores').html(html).trigger('create');
					})	

					
					return this;
			},
			error: function(){
				console.log('there was an error');

			}
		})
})
}
});