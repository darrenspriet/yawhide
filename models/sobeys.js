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
	, location: {lng: Number, lat: Number}
	, currentInterval: String
	, flyers: [{
		date: Date
		, flyer: [{
			item: String
			, price: String
			, savings: String
			, description: String
		}]
	}]
});

var Sobey = db.mongoose.model('sobeys', SobeySchema);

var makeStore = function (store, storeLoc, storeNum, num, city, postalCode, hours, cb){
	var ins = new Sobey();
	ins.storeName = store;
	ins.storeLocation = storeLoc;
	ins.storeNumber = storeNum;
	ins.urlNumber = num;
	ins.city = city;
	ins.postalCode = postalCode;
	ins.storeHours = hours;
	ins.save(cb);
}

var updateCurrentIntervalById = function (id, interval, cb){
	Sobey.findByIdAndUpdate(
		id
		, {currentInterval : interval}
		, cb);
}

var getStoreById = function(id, cb){
	Sobey.findById(
		id
		, null
		, cb);
}

var makeFlyer = function(id, arr, cb){
	var ob = {};
	ob.flyer = arr;
	ob.date = new Date().toISOString();
	Sobey.findByIdAndUpdate(
		id
		, { $push: {flyers:ob}}
		, cb);

}

var getStoreByStoreName = function(name, cb){
	Sobey.findOne(
		{storeName:name}
		, null
		, cb);
}

var getStoreByUrlNum = function(num, cb){
	Sobey.findOne(
		{urlNumber:num}
		, null
		, cb);
}

/**
* finds the nearest sobeys based on lat and long
* @param {String} -elat, elong
* @return {collection} - callback
*/
var getNearestStores = function(elong,elat, callback){
	Sobey.find({"location":
		{$near: [elong, elat]
			,$maxDistance : 5000} }
			, function(err, collection){
				callback(null, collection);
			});
    //One way, from cmd line: db.sobeys.ensureIndex({location: "2d"})
}

var getAllStores = function(cb){
    Sobey.find(
        {},
        function(err, coll){
            cb(err, coll);
        }
    );
}

module.exports.makeStore = makeStore;
module.exports.updateCurrentIntervalById = updateCurrentIntervalById;
module.exports.getStoreById = getStoreById;
module.exports.makeFlyer = makeFlyer;
module.exports.getStoreByStoreName = getStoreByStoreName;
module.exports.getStoreByUrlNum = getStoreByUrlNum;
module.exports.getNearestStores = getNearestStores;
module.exports.getAllStores = getAllStores;