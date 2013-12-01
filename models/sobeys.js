var db = require('../lib/db');

var SobeySchema = new db.Schema({
	date: {type: Date, default: Date.now}
	, storeName: String
	, storeLocation: String
	, storeNumber: Number
	, city: String
	, postalCode: String
	, items: [{
		name: String
		, price: String
		, savings: String
		, description: String
	}]
});

var Sobey = db.mongoose.model('sobeys', SobeySchema);

var makeFlyer = function (store, storeLoc, storeNum, city, postalCode, arr, cb){
	var ins = new Sobey();
	ins.storeName = store;
	ins.storeLocation = storeLoc;
	ins.storeNumber = storeNum;
	ins.city = city;
	ins.postalCode = ins.postalCode;
	ins.items = arr;
	ins.save(cb);
}

var getFlyerById = function (id, cb){
	Sobey.findById(
		id
		, null
		, cb)
}

module.exports.makeFlyer = makeFlyer;
module.exports.getFlyerById = getFlyerById;