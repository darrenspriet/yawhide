App.ApplicationController = Ember.Controller.extend();

App.serverResponse = Ember.ArrayController.createWithMixins({
    content: [],
    addItem: function(item) {
        this.addObject({'title':item});
    }});