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
					var storesArray = [];
					
					for(var i=0;i<nearestSobeysStores.length;i++){
						storesArray.push( nearestSobeysStores.models[i].attributes);
					}
					//console.log(storesArray);

					$.get('../templates/nearestStores.html', function (incomingTemplate){
						var template = Handlebars.compile(incomingTemplate);
						$('#page_container').html(template).trigger('create');
						//google.maps.event.addDomListener(window, 'load', initializeMap(loc.latitude, loc.longitude));
						var incomingStores =
						"<div class='list-group'>"+
						"{{#storesArray}}"+
						"<a href='/#/viewFlyer/{{urlNumber}}' class='list-group-item text-center'>Sobeys - {{storeName}}</a>"+
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
					$('#page_container').html(template({storeInfo:store.attributes})).trigger('create');
				});
				return this;
			}
		});
	}
});

