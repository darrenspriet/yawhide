var IndexView = Backbone.View.extend({
	render: function(){
		var sobeysFlyer = new GetSobeysFlyer();

		sobeysFlyer.fetch({
			success: function(){
				var sobeysArray= new Array();
				for(var i= 0; i<sobeysFlyer.attributes.items.length; i++){
					var sobeysObject =({
						"id": sobeysFlyer.attributes.items[i]._id,
						"description" : sobeysFlyer.attributes.items[i].description,
						"name" : sobeysFlyer.attributes.items[i].name,
						"price" : sobeysFlyer.attributes.items[i].price,
						"savings" : sobeysFlyer.attributes.items[i].savings
					})
					sobeysArray.push(sobeysObject);

				}
				console.log(sobeysArray);

				$.get('templates/index.html', function(incomingTemplate){
					var template = Handlebars.compile(incomingTemplate);
					$('#page_container').html(template({sobeysArray:sobeysArray})).trigger('create');

				});
				return this;

			},
			error: function(){
				console.log('there was an error');

			}
		})

		
	}
});