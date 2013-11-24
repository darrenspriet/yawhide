App.GetDeals = function() {
    $.ajax({
        url: '/index/',
        // dataType: 'json',
        success: function( resp ) {
            console.log( resp );
            App.serverResponse.addItem(resp);
            console.log(App.serverResponse);
        },
        error: function( req, status, err ) {
            console.log( 'something went wrong', status, err );
        }
    });
};
