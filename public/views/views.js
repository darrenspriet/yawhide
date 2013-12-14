$.fn.serializeObject = function() {
	var o = {};
	var a = this.serializeArray();
	$.each(a, function() {
		if (o[this.name] !== undefined) {
			if (!o[this.name].push) {
				o[this.name] = [o[this.name]];
			}
			o[this.name].push(this.value || '');
		} else {
			o[this.name] = this.value || '';
		}
	});
	return o;
};


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
							"storeName" : nearestSobeysStores.models[i].attributes.flyer.storeName,
							"urlNumber" : nearestSobeysStores.models[i].attributes.flyer.urlNumber
						});
						storesArray.push(storeObj);
						var data = JSON.stringify( nearestSobeysStores.models[i].attributes.sortSavings)
						, data2 = JSON.stringify( nearestSobeysStores.models[i].attributes.sortPercent)
						, data3 = JSON.stringify( nearestSobeysStores.models[i].attributes.flyer.currFlyer)
						, store = nearestSobeysStores.models[i].attributes.flyer.storeName;
						localStorage.setItem('savings'+store, data);
						localStorage.setItem('percent'+store, data2);
						localStorage.setItem('flyer'+store, data3);
					}
					//console.log(storesArray);

					$.get('templates/nearestStores.html', function (incomingTemplate){
						var template = Handlebars.compile(incomingTemplate);
						$('#page_container').html(template).trigger('create');
						//google.maps.event.addDomListener(window, 'load', initializeMap(loc.latitude, loc.longitude));
						var incomingStores =
						"<div class='list-group'>"+
						"{{#storesArray}}"+
						"<a href='#/viewFlyer/{{urlNumber}}' class='list-group-item text-center'>Sobeys - {{storeName}}</a>"+
						"{{/storesArray}}"+
						"</div>";
						
						var html = Mustache.to_html(incomingStores,{storesArray:storesArray} );
						$('.tablesForStore').html(html).trigger('create');
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
				var template =
				"<table class='table table-striped centered'>"+
				"<tr ><td>{{storeName}}</td></tr>"+
				"<tr ><td>{{storeNumber}}</td></tr>"+
				"<tr><td>{{city}}</td></tr>"+
				"<tr><td>Store Hours - {{storeHours.open}}</td></tr>"+
				"</table>";
				
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
				console.log(store.attributes);
				$.get('templates/flyer.html', function(incomingTemplate){
					var template = Handlebars.compile(incomingTemplate);
					$('#page_container').html(template({flyer:store.attributes.currFlyer})).trigger('create');
				}); 
				
				return this;
			}
		});
	}

});

