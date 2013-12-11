var express = require('express')
, http = require('http')
, path = require('path')
, fs = require('fs')
, Backbone = require('backbone')
, request = require('request')
, exphbs = require('express3-handlebars')
//, $ = require('jquery')
, cheerio = require('cheerio')
, Sobeys = require('./models/sobeys.js')
, Geocoder = require('node-geocoder-ca').Geocoder
, geocoder = new Geocoder()
, s = require('./algorithms/sobeyFunc');

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


app.get('/readLocalFlyers', function (req, res){
	var latestFolder;
	fs.readdir('./sobeys/', function (err, folders){
		if (err) throw err;
		/** always gets the last folder in ./sobeys/
			because it sorts it by created date (or last mod prob)
			*/
		latestFolder = folders[folders.length -1];
		fs.readdir('./sobeys/' + latestFolder + '/', function (err2, html){
			if (err2) throw err2;
			console.log(latestFolder);
			html.forEach(function (h){
				fs.readFile('./sobeys/' + latestFolder + '/'+h, function (err3, data) {
					if (err3) throw err;

					var $ = cheerio.load(data);

					var info = [];

					if($('.card .card-plain .card-inset p').text().indexOf('No flyer information at this time') > -1){
						console.log('no flyer at file: ' + h);
						
					}
					else{
					
						/** this finds the tbody section in the table.
						 *	 it will hopefully parse through and get four pieces of info:
						 *	 item, price, savings and description */
						$('.card .card-plain .card-inset table tbody').each(function (i, html){
							for(var i = 0; i < html.children.length; i++){
								if(typeof (html.children[i]) !== 'undefined' && html.children[i].type === 'tag'){
									var ob = {};
									for(var j = 0; j < html.children[i].children.length; j++){
										if(typeof (html.children[i].children[j]) !== 'undefined' && html.children[i].children[j].type === 'tag'){
											delete html.children[i].children[j].prev;
											delete html.children[i].children[j].next;
											delete html.children[i].children[j].parent;
											delete html.children[i].children[j].attribs;
											delete html.children[i].children[j].data;
											//console.log('\n' + j);
											//console.log(html.children[i].children[j]);
											if (html.children[i].children[j].children.length == 0){
												html.children[i].children[j].children.push({
													data: ''
												});
											}
											switch(j){
												case 1:
													ob.item = html.children[i].children[j].children[0].data;
													break;
												case 3:
													ob.price = html.children[i].children[j].children[0].data;
													break;
												case 5:
													ob.savings = html.children[i].children[j].children[0].data;
													break;
												case 7:
													ob.description = html.children[i].children[j].children[0].data;
													break;
												/*default:
													ob.description = html.children[i].children[j].children[0].data;
													break;*/
											}
										}
									}
									info.push(ob);
									//console.log('\n');
									//console.log(ob);
								}
							}
							var urlNum = h.split('.')[0];
							Sobeys.getStoreByUrlNum(urlNum, function (err, store){
								if (err) throw err;
								if(!err && store !== null){

									Sobeys.makeFlyer(store, info, function (err2){
										if (err2) throw err;
										//console.log('success: '+urlNum);
										
										
									});
								}
								else{
									console.log('no store under that url number: '+urlNum);
									
								}
							});
						});
					}
				});
			});
		});
	});
});

app.get('/makeStore', function (req, res){
	var url = 'https://www.sobeys.com/en/stores/'

	var z = 1;
	(function loop(){
		if(z < 290){
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


app.get('/getNearestStores/:elat/:elong/:maxD', function (req, res){
    var elat = req.params.elat;
    var elong = req.params.elong;
    

    var maxD = req.params.maxD/111;

	Sobeys.getNearestStores( elong ,elat,maxD,function (err, flyer){
		if(err){
			console.log("there was an error");
		}
		else{
			console.log('the flyers');
			console.log(flyer);
			res.send(flyer);
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
			console.log(flyer)
			res.send(flyer);
		}
	});
});

app.get('/getBestDeals/:id', function (req, res){
	Sobeys.getStoreByUrlNum(req.params.id, function (err, flyer){
		if (err) res.send(500, 'could not get latest flyer by id');
		var fly = flyer.currFlyer;
		var highestSaving = []
		, bestDeals = []
		, buyOneGetOneFree = [];
		
		//buyOneGetOneFree = s.findBuy1Get1Free(fly, buyOneGetOneFree);
		bestDeals = s.findBestDollarDeal(fly);
		//console.log('highestSaving: ');
		//console.log(highestSaving);
		console.log('\nbestDeals: ');
		console.log(bestDeals);
		//console.log('\nbuyOneGetOneFree: ');
		//console.log(buyOneGetOneFree);
		
		//console.log(flyer.storeName);
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

http.createServer(app).listen(app.get('port'), function () {
	console.log("Express server listening on port " + app.get('port'));
});

