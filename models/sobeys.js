var db = require('../lib/db');

var SobeySchema = new db.Schema({
	storeName: String
	, storeLocation: String
	, storeNumber: Number
	, urlNumber: {type:Number, unique:true}
	, city: String
	, postalCode: String
	, storeHours: {
		/*Sunday: String
		, Monday: String
		, Tuesday: String
		, Wednesday: String
		, Thursday: String
		, Friday: String
		, Saturday: String*/
	}
	, location: {lat: Number, long: Number}
	, currentInterval: String
	, currFlyerDate: Date
	, categories: {
		bakery: []
		, beverages: []
		, boxedMeats: []
		, candy: []
		, dairy: []
		, deli: []
		, floral: []
		, grocery: []
		, household: []
		, meat: []
		, pet: []
		, produce: []
		, seafood: []
		, spread: []
	}
	, currFlyer: [/*{
		item: String
		, price: String
		, savings: String
		, description: String
	}*/]
	, oldFlyers: [{
		date: Date
		, actualFlyer: [/*{
			item: String
			, price: String
			, savings: String
			, description: String
		}*/]
	}]
});

console.log('db ensureIndex');
SobeySchema.index({location: "2d"});

var Sobey = db.mongoose.model('sobeys', SobeySchema);

/**
* makes a Sobey Object
* @param {String} -store, storeLoc, city, postalCode
* @param {Number} -storeNum, num
* @param {Object} - hours, latLng
* @return {cb} - callback
*/
var makeStore = function (store, storeLoc, storeNum, num, city, postalCode, hours, lat,lng, cb){
	var ins = new Sobey();
	ins.storeName = store;
	ins.storeLocation = storeLoc;
	ins.storeNumber = storeNum;
	ins.urlNumber = num;
	ins.city = city;
	ins.postalCode = postalCode;
	ins.storeHours = hours;
	ins.location.lat = lat;
	ins.location.long = lng;
	ins.save(cb);
}

/**
* updates the current Inverval
* @param {String} -id, interval
* @return {cb} - callback
*/
var updateCurrentIntervalById = function (id, interval, cb){
	Sobey.findByIdAndUpdate(
		id
		, {currentInterval : interval}
		, cb);
}

/**
* gets a sobey object by id
* @param {String} -id
* @return {cb} - callback
*/
var getStoreById = function(id, cb){
	Sobey.findById(
		id
		, null
		, cb);
}

/**
* finds a sobey object by id and pushes a flyer object
	into its flyer array
* @param {String} -id
* @param {Array} - arr
* @return {cb} - callback
*/
var makeFlyer = function(store, arr, cb){
	/** make backup of old flyer */
	var ob = {};
	if(store.currFlyerDate == '')
		ob.date = new Date().toISOString();
	else
		ob.date = store.currFlyerDate;
	ob.actualFlyer = store.currFlyer;

	store.currFlyerDate = new Date().toISOString();
	store.currFlyer = arr;
	store.oldFlyers.push(ob);
	store.save(cb);
}

/**
* gets a sobey object by its store name
* @param {String} -name
* @return {cb} - callback
*/
var getStoreByStoreName = function(name, cb){
	Sobey.findOne(
		{storeName:name}
		, null
		, cb);
}

/**
* gets a sobey object by its url number
* @param {Number} -num
* @return {cb} - callback
*/
var getStoreByUrlNum = function(num, cb){
	Sobey.findOne(
		{urlNumber:num}
		, null
		, cb);
}

/**
* finds the nearest sobeys based on lat and long
* @param {String} -elat, elong
* @param {Number} -maxD
* @return {collection} - callback
*/
var getNearestStores = function(elong,elat, maxD, callback){
	Sobey.find({"location":
		{$near: [elat,elong]
			,$maxDistance:maxD}}
			,{}
			,{limit:5}
			, function(err, collection){ 
				callback(null, collection);
			});
    //One way, from cmd line: db.sobeys.ensureIndex({location: "2d"})
}

/**
* gets all the sobey objects
* @return {cb} - callback
*/
var getAllStores = function(cb){
    Sobey.find(
        null
        , null
        , cb );
}

var updateFlyerDateAndInterval = function (flyerdate, time, url, cb){
	Sobey.findOneAndUpdate(
		{urlNumber:url}
		, {
			currentInterval : flyerdate
			, currFlyerDate : time
		}
		, cb);
}/*
bakery = 49
beverage = 56
boxedMeats = 65
candy = 62
dairy = 61
deli = 48
floral = 54
grocery = 51
household = 58
meat = 43
pet = 59
produce = 45
seafood = 44
spread = 57
*/
var addCategoryParts = function (urlnum, infoObject, cb){
	//console.log('\n\n\n\n');
	//console.log('infoObject is: ');
	//console.log(infoObject);
	
	Sobey.findOneAndUpdate(
		{urlNumber : urlnum}
		, {
			categories : infoObject
		}
		, cb);
}

module.exports.makeStore = makeStore;
module.exports.updateCurrentIntervalById = updateCurrentIntervalById;
module.exports.getStoreById = getStoreById;
module.exports.makeFlyer = makeFlyer;
module.exports.getStoreByStoreName = getStoreByStoreName;
module.exports.getStoreByUrlNum = getStoreByUrlNum;
module.exports.getNearestStores = getNearestStores;
module.exports.getAllStores = getAllStores;
module.exports.updateFlyerDateAndInterval = updateFlyerDateAndInterval;
module.exports.addCategoryParts = addCategoryParts;