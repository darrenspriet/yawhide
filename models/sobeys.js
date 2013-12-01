var db = require('../lib/db');

var SobeySchema = new db.Schema({
	storeName: {type: String, unique: true}
	, storeLocation: String
	, storeNumber: Number
	, city: String
	, postalCode: String
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

var makeStore = function (store, storeLoc, storeNum, city, postalCode, cb){
	var ins = new Sobey();
	ins.storeName = store;
	ins.storeLocation = storeLoc;
	ins.storeNumber = storeNum;
	ins.city = city;
	ins.postalCode = ins.postalCode;
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

module.exports.makeStore = makeStore;
module.exports.updateCurrentIntervalById = updateCurrentIntervalById;
module.exports.getStoreById = getStoreById;
module.exports.makeFlyer = makeFlyer;
module.exports.getStoreByStoreName = getStoreByStoreName;
