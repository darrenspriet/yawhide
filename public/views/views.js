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

var NearestStoresView = Backbone.View.extend({
	el:' #page_container'
	, events: {
	}
	, render: function(){
		getLocation(function (loc){
			var nearestSobeysStores = new GetNearestSobeys({elat: loc.latitude, elong: loc.longitude, maxD:10});
			//var nearestSobeysStores =  new GetOneSobeyFlyer();
			nearestSobeysStores.fetch({
				success: function(){
					//console.log(nearestSobeysStores);
					var storesArray = new Array();
					for(var i=0;i<nearestSobeysStores.length;i++){
						var storeObj = new Object({
							"storeName" : nearestSobeysStores.models[i].attributes.storeName,
							"urlNumber" : nearestSobeysStores.models[i].attributes.urlNumber
						});
						storesArray.push(storeObj);
					}
					//console.log(storesArray);

					$.get('../templates/nearestStores.html', function (incomingTemplate){
						var template = Handlebars.compile(incomingTemplate);
						$('#page_container').html(template).trigger('create');
						google.maps.event.addDomListener(window, 'load', initializeMap(loc.latitude, loc.longitude));
						var incomingStores =
						"<table>"+
						"{{#storesArray}}"+
						"<tr><td>Sobeys - {{storeName}}</td><td>{{urlNumber}}</td>"+
						"<td><a class='viewStoreInfo btn' href='/#/storeInfo/{{urlNumber}}'>Store Info</a></td>"+
						"<td><a class='getDeals btn btn-primary' href='/#/viewFlyer/{{urlNumber}}'>View Deals</a></td></tr>"+
						"{{/storesArray}}"+
						"</table>";

						var html = Mustache.to_html(incomingStores,{storesArray:storesArray} );
						$('#stores').html(html).trigger('create');
					});					
					return this;
				},
				error: function(){
					console.log('there was an error');
				}
			});
		});
	}
});

var StoreInfoView = Backbone.View.extend({

		render:function(id){

		var store = new GetOneSobeyStore({id: id});
		store.fetch({
			success: function(){
				console.log(store.attributes);
				var template = "<div class='row'>"+
					"<div class='col-xs-12'>"+
						"<h5>Sobeys - {{storeName}}</h5>"+
					"</div>"+
				"</div>"+
				"<div class='row'>"+
					"<div class='col-xs-6'>"+
						"<h5>{{storeNumber}}</h5>"+
					"</div>"+
					"<div class='col-xs-6'>"+
						"<h5>{{city}}</h5>"+
					"</div>"+
				"</div>"+
				"<div class='row'>"+
					"<div class='col-xs-12'>"+
						"<h5>Store Hours - {{storeHours.open}}</h5>"+
					"</div>"+
				"</div>"+
				"</div>";
				$('#page_container').html(Mustache.to_html(template, store.attributes)).trigger('create');
				
				return this;
			}
		});
	}
	
});

var ViewFlyerView = Backbone.View.extend({

	render:function(id){

		var store = new GetOneSobeyStore({id: id});
		store.fetch({
			success: function(){
				// console.log(store.attributes);
				// var template = "<table>"+
				// "<tr><th>Name</th><th>Description</th><th>Price</th><th>Savings</th></tr>"+
				// "{{#store.attributes}}"+
				// "<tr>"+
				// "<td>{{name}}</td><td>{{description}}</td><td>{{price}}</td><td>{{savings}}</td>"+
				// "</tr>"+
				// "{{/store.attributes}}";


				var template ="<div class='row'>"+
					"<div class='col-xs-12'>"+
						"<h5>Sobeys - {{storeName}}</h5>"+
					"</div>"+
				"</div>"+
				"<div class='row'>"+
					"<div class='col-xs-6'>"+
						"<h5>{{storeNumber}}</h5>"+
					"</div>"+
					"<div class='col-xs-6'>"+
						"<h5>{{city}}</h5>"+
					"</div>"+
				"</div>"+
				"<div class='row'>"+
					"<div class='col-xs-12'>"+
						"<h5>Store Hours - {{storeHours.open}}</h5>"+
					"</div>"+
				"</div>"+
				"</div>";
				 $('#page_container').html(Mustache.to_html(template, store.attributes)).trigger('create');
				
				 return this;
			}
		});
	}

});
/*
, gotoStore: function(e){
		var store = new GetOneSobeyStore({id: $(e.currentTarget).attr('value')});
		store.fetch({
			success: function(){
				console.log(store.attributes);
				var template = "<div class='row'>"+
					"<div class='col-xs-12'>"+
						"<h5>Sobeys - {{storeName}}</h5>"+
					"</div>"+
				"</div>"+
				"<div class='row'>"+
					"<div class='col-xs-6'>"+
						"<h5>{{storeNumber}}</h5>"+
					"</div>"+
					"<div class='col-xs-6'>"+
						"<h5>{{city}}</h5>"+
					"</div>"+
				"</div>"+
				"<div class='row'>"+
					"<div class='col-xs-12'>"+
						"<h5>Store Hours - {{storeHours}}</h5>"+
					"</div>"+
				"</div>"+
				"</div>";
				$('#page_container').html(Mustache.to_html(template, store.attributes)).trigger('create');
				
				return this;
			}
		});
	}
	, gotoDeals: function(e){
		var store = new GetOneSobeyStore({id: $(e.currentTarget).attr('value')});
		store.fetch({
			success: function(){
				console.log(store.attributes);


				e.preventDefault();
			}
		});
	}*/