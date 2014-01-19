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
	el:' #page_container'
	, events: {
		"click #findFlyers": "findFlyersPage"
		, "click #usePostalCode": "findViaPostal"
	}
	, render: function(e){
		$.get('templates/home.html', function (incomingTemplate){
			var template = Handlebars.compile(incomingTemplate);
			$('#page_container').html(template()).trigger('create');
		});
		return this;
	}
	, findFlyersPage: function(){
		app_router.navigate('#/nearestStores', {trigger: true});
	}
	, findViaPostal: function(){
		console.log($("#postal").val())
		app_router.navigate('#/nearestStoresByPostal/'+ $("#postal").val(), {trigger: true});
	}
});

var NearestStoresView = Backbone.View.extend({
	el:' #page_container'
	, events: {
	}
	, render: function(){
		getLocation(function (loc){
			var nearestSobeysStores = new GetNearestSobeys({elat: loc.latitude, elong: loc.longitude, maxD:20});
			//var nearestSobeysStores =  new GetOneSobeyFlyer();
			nearestSobeysStores.fetch({
				success: function(){
					console.log(nearestSobeysStores);
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

var PostalStoresView = Backbone.View.extend({
	el:'#page_container'
	, events:{

	}
	, render: function(postalCode){
		console.log(postalCode);
		$.ajax({
			url: "http://query.yahooapis.com/v1/public/yql?q=select * from geo.places where text='" + postalCode + "'&format=json"
			, type: "GET"
			})
			.done(function (json){
				//console.log(json.query.results.place.centroid);
				var nearestSobeysStores = new GetNearestSobeys({elat: json.query.results.place.centroid.latitude, elong: json.query.results.place.centroid.longitude, maxD:20});
				nearestSobeysStores.fetch({
					success: function(){
						console.log(nearestSobeysStores);
						var storesArray = [];

						for(var i=0;i<nearestSobeysStores.length;i++){
							storesArray.push( nearestSobeysStores.models[i].attributes);
						}
						$.get('../templates/nearestStores.html', function (incomingTemplate){
							var template = Handlebars.compile(incomingTemplate);
							$('#page_container').html(template).trigger('create');
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
	el:' #page_container'
	, events:{
		"click #regFly":"clickRegFlyer"
		, "click #perFly":"clickPerFlyer"
		, "click #savFly":"clickSavFlyer"
		, "click #categ" : "doCateg"
	}
	, render:function(id){

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
	, clickRegFlyer: function(){
		//$('.flyerContainer').empty();
		if($('#savFly').hasClass('active')){
			$('#savFly').removeClass('active');
			$(this).data("toggle", "false");
		}
		if ($('#perFly').hasClass('active')){
			$('#perFly').removeClass('active');
			$(this).data("toggle", "false");
		}
		if($(this).data("toggle") === 'false'){
			$('#regFly').toggleClass('active');
			$(this).data("toggle", "true");
		}
		var sort_by_reg = function(a, b) {
			return $(a).data('reg') - $(b).data('reg');//a.innerHTML.toLowerCase().localeCompare(b.innerHTML.toLowerCase());
		}

		var list = $(".flyerContainer > div").get();
		list.sort(sort_by_reg);
		for (var i = 0; i < list.length; i++) {
			list[i].parentNode.appendChild(list[i]);
		}
		window.scrollTo(0,0);
	}
	, clickPerFlyer: function(){
		//$('.flyerContainer').empty();
		if($('#regFly').hasClass('active')){
			$('#regFly').removeClass('active');
			$(this).data("toggle", "false");
		}
		if($('#savFly').hasClass('active')){
			$('#savFly').removeClass('active');
			$(this).data("toggle", "false");
		}
		if($(this).data("toggle") === 'false'){
			$('#perFly').toggleClass('active');
			$(this).data("toggle", "true");
		}
		var sort_by_per = function(a, b) {
			return $(b).data('per')-$(a).data('per');//a.innerHTML.toLowerCase().localeCompare(b.innerHTML.toLowerCase());
		}

		var list = $(".flyerContainer > div").get();
		list.sort(sort_by_per);
		for (var i = 0; i < list.length; i++) {
			list[i].parentNode.appendChild(list[i]);
		}
		window.scrollTo(0,0);
	}
	, clickSavFlyer: function(){
		//$('.flyerContainer').empty();
		if($('#regFly').hasClass('active')){
			$('#regFly').removeClass('active');
			$(this).data("toggle", "false");
		}
		if($('#perFly').hasClass('active')){
			$('#perFly').removeClass('active');
			$(this).data("toggle", "false");
		}
		if($(this).data("toggle") === 'false'){
			$('#savFly').toggleClass('active');
			$(this).data("toggle", "true");
		}
		var sort_by_sav = function(a, b) {
			return $(b).data('sav')-$(a).data('sav');//a.innerHTML.toLowerCase().localeCompare(b.innerHTML.toLowerCase());
		}

		var list = $(".flyerContainer > div").get();
		list.sort(sort_by_sav);
		for (var i = 0; i < list.length; i++) {
			list[i].parentNode.appendChild(list[i]);
		}
		window.scrollTo(0,0);
	}
	, doCateg: function(event){
		var ii = 0
		, list = $(".flyerContainer > div").get();
		

		for(;ii<list.length; ii++){
			if($(event.target).data('categ') === 'all'){
				$(list[ii]).show();
			}
			else if($(list[ii]).data('categ') === $(event.target).data('categ')){
				$(list[ii]).show();
			}
			else{
				$(list[ii]).hide();
			}
			
		}
		var child = $('.categToggle').children();
		for (var i = child.length - 1; i >= 0; i--) {
			if($(child[i]).text() == $(event.target).text()){
				$(event.target).toggleClass('active');
			}
			else{
				$(child[i]).removeClass('active');
			}
			
		};		
		window.scrollTo(0,0);
	}
});

