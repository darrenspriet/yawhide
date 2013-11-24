App = Ember.Application.createWithMixins({
	ready: function() {
		App.GetDeals();   // this triggers an AJAX call to Clojure REST interface
	}
});


