var IndexView = Backbone.View.extend({
	render: function(){
		var sobeysFlyer = new GetSobeysFlyer();
		sobeysFlyer.fetch({
			success: function(){
				console.log(sobeysFlyer);
				// var sobeysArray= new Array();
				// for(var i= 0; i<sobeysFlyer.attributes.items.length; i++){
				// 	var sobeysObject =({
				// 		"id": sobeysFlyer.attributes.items[i]._id,
				// 		"description" : sobeysFlyer.attributes.items[i].description,
				// 		"name" : sobeysFlyer.attributes.items[i].name,
				// 		"price" : sobeysFlyer.attributes.items[i].price,
				// 		"savings" : sobeysFlyer.attributes.items[i].savings
				// 	})
				// 	sobeysArray.push(sobeysObject);
				// }
				// console.log(sobeysArray);

				// $.get('templates/index.html', function(incomingTemplate){
				// 	var template = Handlebars.compile(incomingTemplate);
				// 	$('#page_container').html(template({sobeysArray:sobeysArray})).trigger('create');

				// });
				// return this;
			},
			error: function(){
				console.log('there was an error');

			}
		})
	}
});

NearestStoresView = Backbone.View.extend({
	render: function(){
		getLocation(function (loc){
			var nearestSobeysStores = new GetNearestSobeys({elat: loc.latitude, elong: loc.longitude});
			nearestSobeysStores.fetch({
				success: function(){
					console.log(nearestSobeysStores);
				// var sobeysArray= new Array();
				// for(var i= 0; i<sobeysFlyer.attributes.items.length; i++){
				// 	var sobeysObject =({
				// 		"id": sobeysFlyer.attributes.items[i]._id,
				// 		"description" : sobeysFlyer.attributes.items[i].description,
				// 		"name" : sobeysFlyer.attributes.items[i].name,
				// 		"price" : sobeysFlyer.attributes.items[i].price,
				// 		"savings" : sobeysFlyer.attributes.items[i].savings
				// 	})
				// 	sobeysArray.push(sobeysObject);
				// }
				// console.log(sobeysArray);

				// $.get('templates/index.html', function(incomingTemplate){
				// 	var template = Handlebars.compile(incomingTemplate);
				// 	$('#page_container').html(template({sobeysArray:sobeysArray})).trigger('create');

				// });
				// return this;
			},
			error: function(){
				console.log('there was an error');

			}
		})
		})
	}
});