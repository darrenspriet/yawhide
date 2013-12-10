var veggieFruit = ['apple', 'apricot', 'artichoke', 'asparagus', 'aubergine', 'avocado', 'banana', 'beetroot', 'bean', 'broccoli', 'brussel', 'carrot', 'cherry', 'clementine', 'courgette', 'date', 'elderberry', 'endive', 'fennel', 'fig', 'garlic', 'grape', 'guava', 'kiwi', 'leek', 'lemon', 'lettuce', 'mango', 'melon', 'mushroom', 'nectarine', 'nut', 'olive', 'orange', 'pea', 'peanut', 'pear', 'pepper', 'pineapple', 'plum', 'potato', 'pumpkin', 'quince', 'radish', 'raisin', 'rhubarb', 'satsuma', 'sprout', 'squash', 'strawberry', 'tomato', 'turnip', 'ugli', 'watercress', 'watermelon', 'yam'];


var findBuy1Get1Free = function (arrOfObs, arr){
	for (var i = arrOfObs.length - 1; i >= 0; i--) {
		if(arrOfObs[i].price.toLowerCase().indexOf('buy') > -1 && arrOfObs[i].price.toLowerCase().indexOf('get') > -1 && arrOfObs[i].price.toLowerCase().indexOf('free') > -1){
			arr.push(arrOfObs[i]);
		}
	};
	return arr;
}

var findBestDollarDeal = function (arrOfObs, arr){
	for (var i = arrOfObs.length - 1; i >= 0; i--) {
		var ob = {}
		, sav = arrOfObs[i].savings
		, pr = arrOfObs[i].price
		, it = arrOfObs[i].item;

		if(sav.indexOf('%') == -1 && isNaN(sav)){
			//var tst = /^$$/;
			//console.log(tst.test(filter));
			var cent = 155;
			//console.log(sav[sav.length-1] + " " + sav.charCodeAt(sav.length-1));


			var filter = sav.match(/(\d[\d\.]*)/g);
			console.log(filter);
			if (filter === null){
				console.log('no savings ' + pr + '\n');
			}
			else if(filter.length > 1){
				var f = +filter[0]
				, p = +pr
				, fNum = f/100;
				if(filter[0].indexOf('.') > -1){
					console.log('dot found');
					console.log('f: %s, p: %s, fNum: %s', f, p, fNum);
					console.log('best %age is: ' + (f / (f+p) )*100+ '\n');
				}
				else{
					console.log('f: %s, p: %s, fNum: %s', f, p, fNum);
					console.log('best %age is: ' + (fNum / (fNum+p) )*100+ '\n');
				}
			}
			else{
				var f = +filter[0]
				, p = +pr
				, fNum = f/100;
				if(filter[0].indexOf('.') > -1){
					console.log('dot found');
					console.log('f: %s, p: %s, fNum: %s', f, p, fNum);
					console.log('best %age is: ' + (f / (f+p) )*100+ '\n');
				}
				else{
					console.log('f: %s, p: %s, fNum: %s', f, p, fNum);
					console.log('best %age is: ' + (fNum / (fNum + p))*100  + '\n');
				}
			}
			
		}
	};
	return arr;
}

module.exports.findBuy1Get1Free = findBuy1Get1Free;
module.exports.findBestDollarDeal = findBestDollarDeal;