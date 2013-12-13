/**
* Sets the global URL - helpful if the app needs to point to a specific server
* @param {string} - current IP/Server
* @return {string} - formatted URL with current IP/Server
*
*/
var getURL = function(op){
    //DEPLOYING ON LOCAL MACHINE
    // return "http://192.168.11.54:3000"+op;

    //local
    return ""+op;
}

/**
* Gets the current location (lat and long coords). Set the global variable vars.location with the coords found
* @param {function} - success
* @param {function} - error
*
*/
var getLocation = function(success, err){
	try{
		console.log('Getting location...');
		navigator.geolocation.getCurrentPosition(function(position){
			loc = {
				latitude:position.coords.latitude,
				longitude:position.coords.longitude
			};
			success(loc);
		// vars.location=loc;
		// console.log(loc);

			}, function(e){
				err(e);
			},
			{
				timeout:30000,
				maximumAge:600000
			});
				}catch(e){

			// On fail, use communitech coordinates
			alert(e);
			//success(moveCoords(debug.location));
		}
}

/**
* Initializes the google map
* @param {number} - Lat coord
* @param {number} - Long coord
*/
var initializeMap = function(L1, L2)
{
	var mapProp = {
		center:new google.maps.LatLng(L1,L2),
		zoom:14,
		mapTypeId:google.maps.MapTypeId.ROADMAP,
		disableDefaultUI: true
	};
	var map=new google.maps.Map(document.getElementById("findASobeys"),mapProp);
}

