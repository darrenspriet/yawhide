var express = require('express')
, http = require('http')
, path = require('path')
, fs = require('graceful-fs')
, Backbone = require('backbone')
, request = require('request')
, exphbs = require('express3-handlebars')
//, $ = require('jquery')
, cheerio = require('cheerio')
, Sobeys = require('./models/sobeys.js')
, Geocoder = require('node-geocoder-ca').Geocoder
, geocoder = new Geocoder()
, s = require('./algorithms/sobeyFunc')
, async = require('async')
, ce = require('cloneextend');

app = express();

app.configure(function () {
	app.set('port', process.env.PORT || 3000);
	// app.set('views', __dirname + '/jadeViews');
    //app.engine('handlebars', exphbs({defaultLayout : 'main'}));
    // app.set('view engine', 'handlebars');
    app.set('view engine', 'jade');
    app.use(express.favicon());
    app.use(express.logger('dev'));
    app.use(express.json());
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(app.router);
    app.use(express.static(path.join(__dirname, 'public')));
	app.use("/public", express.static(__dirname + '/public'));
});

app.configure('development', function () {
	app.use(express.errorHandler());
});



// var isCallerMobile = function (req) {
// 	var ua = req.headers['user-agent'].toLowerCase(),
// 	isMobile = /(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(ua) || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(ua.substr(0, 4));

// 	return !!isMobile;
// }

// var checkForMobile = function (req, res, next) {
// 	var isMobile = isCallerMobile(req);

// 	if (isMobile) {
// 		console.log("Going mobile");
// 		res.redirect('/mobile');
// 	} else {
// 		return next();
// 	}
// }

var isEmptyObject = function (obj) {
    var name;
    for (name in obj) {
        return false;
    }
    return true;
}

//when the root route is called, do our mobile check
app.get('/index', function (req, res){
  // var htmlString = $("div.card-inset").html();
  // console.log(JSON.stringify(htmlString));
  res.end('this worked');
});

app.get('/mobile', function (req, res){
});

var date;
var data = {}
, div = 'div.card > div.card-plain > div.card-inset > table > ';

var getBest = function (ob, cb){
	var bestPercent = 0
	,  bestSav = 0
	, extra = ''
	, test1 = /[0-9]\/\$/g /** ex 3/$ */
	, test2 = /\s[0-9]/g  /** ex _5 */
	, test3 = /[0-9]+%/g
	, number = /\d\d/
	, getNumber = /[0-9][\.,][0-9][0-9]/ /** $3.99*/
	, getNumber2 = /[0-9][\.,][0-9][0-9]/
	, num = 1;
	/** tests 3 for 5 dollars */
	if(test1.test(ob.price)){
		/** tests if sav doesn't have on 3 */
		if(!test2.test(ob.sav)){
			if(ob.sav === '' || !number.test(ob.sav)){
				//console.log('sav is: ' + ob.sav + 'hahaha');
				bestSav = 0;
				bestPercent = 0;
				extra = 'has 2/$5 but no savings'
			}
			else{
				var tmp = getNumber2.exec(ob.sav)[0];
				//tmp = tmp.replace('$', '');
				//console.log(ob.price + " " + tmp);

				var splitted = ob.price.split('/$');
				
				tmp = tmp / splitted[0];
				bestSav = Math.round(tmp*100)/100;
				//console.log(tmp);
				bestPercent = Math.round(tmp / (tmp + (splitted[1] / splitted[0]))*100)/100;
				extra = 'price has n for some price deal'
			}
			
		}
		/** tests if sav does have a 3*/
		else{
			var tmp = getNumber.exec(ob.sav)[0]
			, splitted = ob.price.split('/$');
			tmp = tmp.replace('$', '');
			tmp /= splitted[0];
			bestSav = Math.round(tmp*100)/100;
			bestPercent = Math.round(tmp / (tmp + (splitted[1]/splitted[0]))*100)/100;
			extra = 'price has n for some price, sav only has the savings, no number'
		}
	}
	/** is price has a percent in it */
	else if (ob.price.indexOf('%') > -1){
		bestSav = getNumber.exec(ob.sav) !== null ? getNumber.exec(ob.sav)[0] : 0;
		bestPercent = test3.exec(ob.price)[0].replace('%', '');
		bestPercent /= 100;
		extra = 'price has percent'
	}
	/** doesn't have a price in sav */
	else if (getNumber.exec(ob.sav) === null){
		var savLower = ob.sav.toLowerCase();
		/** buy 1 get one free deal */
		if(savLower.indexOf('buy') > -1 && savLower.indexOf('get') > -1 && savLower.indexOf('free') > -1){
			bestSav = 'Buy 1 Get 1 Free';
			bestPercent = 0.5;
			extra = 'buy1get1free';
		}
		/** no savings so we dont know %tage */
		else{
			bestSav = 0;
			bestPercent = 0;
			extra = 'no savings';
		}
	}
	/** has a price and savings */
	else{
		if(ob.price === ''){
			var tmp = parseFloat(getNumber2.exec(ob.sav)[0])
			bestSav = tmp;
			bestPrice = 0;
			extra = 'has reg savings but no price';
		}
		else{
			//console.log(ob.price + ", " + ob.sav);
			var tmp = parseFloat(getNumber2.exec(ob.sav)[0])
			, tmp2 = parseFloat(getNumber2.exec(ob.price)[0]);
			bestSav = tmp;
			bestPercent = Math.round(tmp / (tmp2 + tmp)*100)/100;
			extra = 'has simple price and simple savings';
		}		
	}
	cb(bestPercent, bestSav, extra);
}
app.get('/readLocalFlyers', function (req, res){
	var latestFolder;
	fs.readdir('./sobeys/', function (err, folders){
		if (err) throw err;
		/** always gets the last folder in ./sobeys/
			because it sorts it by created date (or last mod prob)
			*/
		latestFolder = folders[folders.length -1];
		fs.readdir('./sobeys/' + latestFolder + '/', function (err2, folders2){
			if (err2) throw err2;
			console.log(latestFolder);
			/** this is each store's flyer */
			folders2.forEach(function (h){
				fs.readdir('./sobeys/'+latestFolder + '/' + h + '/', function (err3, folders3){
					if(err3)throw err3;
					/** this is each flyer part */
					var info = []
					, flyerDate = '';
					
					//async.forEach(folders3, function (flyerPart, callback){ 
//folders3.forEach(function (flyerPart){
     				async.map(folders3
     					, function (flyerPart, complete) {

     					fs.readFile('./sobeys/'+latestFolder + '/' + h + '/' + flyerPart, 'utf8', function (err4, data){

							/** this is each 1 of 20 parts of a flyer */
							if (err4) throw err4;
							var $ = cheerio.load(data);

							//var info = [];

							if($('.card .card-plain .card-inset p').text().indexOf('No flyer information at this time') > -1 || !$('div').hasClass('toggle-last')) {
								console.log('no flyer at file: ' + flyerPart);
							}
							else {
								//console.log(flyerPart);
								$('.container .toggle-last .one-third .flyer-card .card-top').each(function (a, html){
									var url = ''
									, price = ''
									, sav = ''
									, desc = ''
									, item = ''
									, bestSav = ''
									, bestPercent = ''
									, savings = ''
									, savings1 = ''
									, savings2 = '';
									for (var i = html.children.length - 1; i >= 0; i--) {

										if(html.children[i].type === 'tag') {
											var class1 = html.children[i];											
											/** this finds url specifically from selecting a chain of classes */
											if(class1.attribs.class === 'card-image'){
												url = class1.attribs.style.split(' ')[1].substr(5);
												url = url.substr(0, url.length -3);
											}
											else if (class1.attribs.class==='card-inset'){
												for (var j = class1.children.length - 1; j >= 0; j--) {
													var class2 = class1.children[j];
													if(class2.type === 'tag'){
														/** finds the desc */
														if (class2.name === 'p'){
															desc = class2.children[0].data;
															desc = desc.replace(/&amp;/g, '&');
															desc = desc.replace(/[^a-zA-Z 0-9+;():,.-\s*!%&\r\n\/]+/g,"'");
														}
														/** finds the item name */
														else if(class2.attribs.class.indexOf('h6') > -1){
															item = class2.children[0].data;
															item = item.replace(/&amp;/g, '&');
															item = item.replace(/[^a-zA-Z 0-9+;():,.-\s*!%&\r\n\/]+/g,"'");
														}
														/** finds the price and savings */
														else if (class2.attribs.class.indexOf('price')>-1){
															for (var k = class2.children.length - 1; k >= 0; k--) {
																var class3 = class2.children[k];
																if(class3.type === 'tag'){
																	if(class3.attribs.class.indexOf('price-amount')){
																		if(class3.children.length > 1 && class3.children[1].children.length > 0){
																			sav = class3.children[1].children[0].data;
																			sav = sav.replace(/&amp;/g, '&');
																			sav = sav.replace(/[^a-zA-Z0-9+;():,\.$-\s*!%&\r\n\/]+/g,"|");
																			var savSplit = sav.split(' ')
																			, tmp = ''
																			, count = 0;
																			for (var l = 0; l < savSplit.length; l++) {
																				if(savSplit[l].indexOf('|') > -1){
																					//console.log(savSplit[l]);
																					tmp += '$0.' + savSplit[l].replace('|', '') + ' ';
																					count++;
																					//console.log(tmp2);
																				}
																				else if (!isNaN(savSplit[l]) && savSplit[l].indexOf('$') === -1 && count === 0){
																					tmp += '$'+savSplit[l] + ' ';
																					count++;
																				}
																				else if (savSplit[l].indexOf('/') > -1){
																					//console.log(savSplit[l]);
																					tmp += '$'+savSplit[l] + ' ';
																				}
																				else{
																					tmp += savSplit[l] + ' ';
																				}
																			};
																			sav = tmp
																			sav = sav.replace('100 g', '100g');
																			sav = sav.replace(' /100g', '/100g');
																			sav = sav.replace('lb ,ea', 'lb,ea');
																			sav = sav.replace('lb, ea', 'lb,ea');
																			sav = sav.replace('$$', '$');
																			//sav = sav.replace('|', '$');
																			//console.log('sav: ' + sav);
																		}
																	}
																	else if (class3.attribs.class.indexOf('price-promos')) {
																		
																		if(class3.children.length > 1){

																			if(class3.children[1].children.length > 1){
																				savings = '$' + class3.children[0].data+'.';
																				savings1 = class3.children[1].children[0].data;
																				savings2 = class3.children[1].children[1].children[0].data;
																			}
																			else if (class3.children[0].data.indexOf('%') > -1){
																				savings = 'noPrice';
																				savings1 = class3.children[0].data;
																				savings2 = class3.children[1].children[0].data;
																			}
																			else if (class3.children[0].data.indexOf('/') === -1){
																				savings = '$0' + class3.children[0].data;
																				savings1 = class3.children[1].children[0].data;
																			}
																			else{
																				savings = class3.children[0].data + '.';
																				savings = savings.replace('/', '/$');
																				savings1 = class3.children[1].children[0].data;
																			}
																			var price = savings + savings1 + savings2;
																			//console.log('price: ' + price);
																		}
																	}
																}
															};
														}
													}
												};
											}
											if(flyerDate === ''){
												flyerDate = $('.container .site-section .site-section-content .fancy-heading .h3-editorial').text();
											}
											//
											
											/** gets the best savings from the price */
											//console.log('\n' + sav + " " + price);
											if(url !== '' && item !== ''){
												var priceSav = {};
												priceSav.price = price;
												priceSav.sav = sav;
												//console.log(h);
												var listOfFrenchStores = ['34'];
												if(listOfFrenchStores.indexOf(h) === -1){
													getBest(priceSav, function (percent, sav2, extra){
														var ob = {};
														ob.item = item;
														ob.price = price;
														ob.savings = sav;
														ob.url = url;
														ob.description = desc;
														ob.bestPercent = percent;
														ob.bestSav = sav2;
														ob.extra = extra;
														info.push(ob);
													});
												}
											}
										}

									};
								});
							}
							complete(err4, data);
						})
						}
						, function (err, results){

						console.log('iterating done');
						var urlNum = h.split('.')[0];
						Sobeys.getStoreByUrlNum(urlNum, function (err7, store){
							if (err7) throw err7;
							if(!err7 && store !== null){
								Sobeys.makeFlyer(store, info, function (err8){
									if (err8) throw err8;
									Sobeys.updateFlyerDateAndInterval(flyerDate, new Date().getTime(), urlNum, function (err9){
										if(err9) throw err;
										if(h > 288)
											console.log('done');
									});
								});
							}
							else{
								console.log('no store under that url number: '+urlNum);
							}
						});
						
					});
				});
			});
		});
	});
});

app.get('/makeStore', function (req, res){
	var url = 'https://www.sobeys.com/en/stores/'

	var z = 1;
	(function loop(){
		if(z < 296){
			var storename = ''
			, storeloc = ''
			, storenum = 0
			, urlnum = z
			, city = ''
			, postal = ''
			, hours = {}
			, interval = '';
			request(url+z, function (r, s, b){
				var $ = cheerio.load(b);
				var info = [];
				if(	$('body').find('.block').length == 0){
					$('.container .site-section .site-section-content .card .card-plain .card-inset').each(function (z, html){
						var count = 0;
						html.children.forEach(function (i){
							if(i.data !== '\n' && count > 1){
								var count3 = 0;
								i.children.forEach(function (j){
									if(j.data !== '\n'){
										if(j.attribs['class'].indexOf('grid__item') > -1){
											
											j.children.forEach(function (k){
												if(k.data !== '\n'){
													if(k.attribs['class'] === 'palm--hide'){
														var str = '';
														var count2 = 0;
														k.children.forEach(function (l){
															if(l.type !== 'tag'){
																var tmp = l.data.split('\n');
																tmp.forEach(function (m){
																	if(m !== ''){
																		str += m + ' ';
																		switch(count2){
																			case 0:
																				storeloc = m;
																				count2++;
																				break;
																			case 1:
																				city = m;
																				count2++;
																				break;
																			case 2:
																				postal = m;
																				count2++;
																				break;
																		}
																	}
																});
															}
														});
														count2 = 0;
													}
													if(count3 == 6){
														storenum = 	k.children[0].data.split('\n')[1];					
													}
													count3++;
												}
											});
										}										
									}
								});
								count3 = 0;
							}
							count++;
						});
					});
					$('.my-store-title div div h3').each(function (i, html){
						var tmp = html.children[0].data.split(' ');
						var tmp2 = '';
						for(var y = 0; y < tmp.length; y++){
							if(y > 1){
								tmp2 += tmp[y];
								if(y+1 < tmp.length)
									tmp2+=' ';
							}
						}
						tmp2 = tmp2.replace('&amp;', '&');
						storename = tmp2;
					});
					$('.push--desk--one-half table tbody tr').each(function (i, html){
						var prevDay = '';
						html.children.forEach(function (i){
							if(typeof(i.data.children) !== 'undefined' && i.data !== '\n' && i.data !== ''){
									
								var whole = i.children[0].data.split(' ');
								if(whole.length == 5){
									hours[prevDay] = i.children[0].data;
								}
								else if (whole.length == 1){
									prevDay = whole[0];
								}
								else if (whole.length > 1 && whole.length < 5){
									hours[prevDay] = i.children[0].data;
								}
							}
						});
					});
					var latLng = $('#map_location').text().split(', ');
					//console.log('latLng is: ' + latLng);
					var lng = latLng[0].substr(1);
					var lat = latLng[1].substr(0,latLng[1].length -1);
					//console.log(latLngOb);
					/*
					var address = 'sobeys ' + storeloc + ', ' + city + ', ' + postal;
				    var sensor = false;
				    var geoOb = {};
				    //address = '525 Market St, Philadelphia, PA 19106';
				    
					geocoder.geocode(address, function(err, coords) {
					    if (err) throw err;
					    console.log("%s geocoded to [%d, %d]", address, coords.lat, coords.lon);
					    console.log(coords);
					});
				    console.log('geoOb');
				    console.log(geoOb);*/
					//console.log('storename: ' + storename);
					//console.log('storenum: ' + storenum);
					//console.log('storeloc: ' + storeloc);
					//console.log('urlnum: ' + urlnum);
					//console.log('city: ' + city);
					//console.log('postal: ' + postal);
					//console.log('hours: ');
					if(isEmptyObject(hours))
						hours.open = '24 hours';
					//console.log(hours);
					Sobeys.makeStore(storename, storeloc, storenum, urlnum, city, postal, hours, lat ,lng, function (err){
						if(err) throw err;
						console.log(z);
						z++;
						loop();
					});
				}
				else{
					z++;
					loop();
				}
			});
		}
	}());
});

// app.post('/makeStore', function (req, res){

// });

var sortBestPercent = function (ob, cb){
	ob.sort(function (a,b){
		return b.bestPercent-a.bestPercent;
	});
	cb(ob);
}

var sortBestSav = function (ob, cb){
	ob.sort(function (a,b){
		return b.bestSav-a.bestSav;
	});
	cb(ob);
}

app.get('/getNearestStores/:elat/:elong/:maxD', function (req, res){
    var elat = req.params.elat;
    var elong = req.params.elong;
    

    var maxD = req.params.maxD/111;
    console.log(elong+ " " + elat + " " + maxD);
	Sobeys.getNearestStores( elong ,elat,maxD,function (err, flyer){
		if(err){
			console.log("there was an error");
		}
		else{
			var arr = [];
			for (var i = 0; i < flyer.length; i++) {
				var ob = {};
				ob.storeName = flyer[i].storeName;
				ob.storeLocation = flyer[i].storeLocation;
				ob.urlNumber = flyer[i].urlNumber;
				ob.city = flyer[i].city;
				ob.postalCode = flyer[i].postalCode;
				ob.storeHours = flyer[i].storeHours;
				ob.location = flyer[i].location;
				ob.currentInterval = flyer[i].currentInterval;
				ob.currFlyerDate = flyer[i].currFlyerDate;
				ob.regularFlyer = flyer[i].currFlyer;
				/** here i have to give sortBestPercent a clone of the currFlyer or else
						sort will just mutate the original flyer which isn't good */
				sortBestPercent(ce.clone(flyer[i].currFlyer), function (cb){
					ob.bestPercentFlyer = cb;
					sortBestSav(ce.clone(flyer[i].currFlyer), function (cb2){
						ob.bestSavFlyer = cb2;
						arr.push(ob);

						//console.log(ob + i + '\n');
					});
					//console.log(cb);
					
				});

			};
			console.log('the flyers');
			res.send(arr);
		}
	});
});

app.get('/getAllStores', function (req, res){

	Sobeys.getAllStores(function (err, flyer){
		if(err){
			console.log("there was an error");
		}
		else{
			console.log('this is the flyer');
			//console.log(flyer)
			res.send(flyer);
		}
	});
});

app.get('/getBestDeals/:id', function (req, res){
	Sobeys.getStoreByUrlNum(req.params.id, function (err, flyer){
		if (err) res.send(500, 'could not get latest flyer by id');
		var fly = flyer.currFlyer;
		console.log(flyer);
		var highestSaving = []
		, bestDeals = []
		, bestPercent = []
		, arr1=[]
		, arr2=[]
		, arr3=[]
		, arr4=[]
		, arr5=[]
		, arr6=[];
		s.categories(fly, arr1, arr2, arr3, arr4, arr5, arr6);
		//console.log(arr6);
	});
});

app.get('/getSobeyFlyer/:id', function (req, res){
	Sobeys.getStoreByUrlNum(req.params.id, function (err, store){
	
		if (err) res.send(500, 'could not get store by number')
		else{
			res.send(store);
		}
	})
});

var test = [
	{'sav': 'save up to $3.97', 'price': '3/$20.00'}
	, {'sav': 'save up to $2.50/lb', 'price': '$8.99/lb'}
	, {'sav': 'save up to $0.9/lb', 'price': '$5.49/lb'}
	, {'sav': 'save up to $0.79', 'price': '2/$4.00'}
	, {'sav': 'save up to $0.97 on 3', 'price': '3/$5.00'}
	, {'sav': 'this week', 'price': '$9.99/ea.'}
	, {'sav': 'save up to $0.70/lb,ea', 'price': '$1.79/lb'}
	, {'sav': 'save $0.30', 'price': '$0.99/ea'}
	, {'sav': 'save up to $9.77 on 3', 'price': '3/$9.99'}
	, {'sav': 'save up to $3.00', 'price': '$12.99/ea'}
	, {'sav': 'save $0.20/100g', 'price': '$1.79/100g'}
	, {'sav': '', 'price': '$3.35/100g'}
	, {'sav': 'save up to $0.30', 'price': '$0.69/ea'}
	, {'sav': 'save this week', 'price': 'noPrice15%off'}
	]

app.get('/deal', function (req, res){
	var info = [];
	for (var y = test.length - 1; y>= 0; y--) {
		getBest(test[y], function (percent, sav, extra){
			var ob = {};
			ob.bestPercent = percent;
			ob.bestSav = sav;
			ob.extra = extra;
			info.push(ob);
		});
	};
	console.log('info is: ');
	console.log(info);
	res.end();
});

http.createServer(app).listen(3000, '192.168.1.103', function () {
	console.log("Express server listening on port " + app.get('port'));
});

