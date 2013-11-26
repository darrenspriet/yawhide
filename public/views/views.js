var IndexView = Backbone.View.extend({
	render: function(){
		var sobeysFlyer = new GetSobeysFlyer();

		sobeysFlyer.fetch({
			success: function(){
				console.log(sobeysFlyer);

				$.get('templates/index.html', function(incomingTemplate){
					var template = Handlebars.compile(incomingTemplate);
					$('#page_container').html(template).trigger('create');

				});
				return this;

			},
			error: function(){
				console.log('there was an error');

			}
		})

		
	}
});