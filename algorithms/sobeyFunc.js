var veggieFruit = ['apple', 'apricot', 'artichoke', 'asparagus', 'aubergine', 'avocado', 'banana', 'beetroot', 'bean', 'broccoli', 'brussel', 'carrot', 'cherry', 'clementine', 'courgette', 'date', 'elderberry', 'endive', 'fennel', 'fig', 'garlic', 'grape', 'guava', 'kiwi', 'leek', 'lemon', 'lettuce', 'mango', 'melon', 'mushroom', 'nectarine', 'nut', 'olive', 'orange', 'pea', 'peanut', 'pear', 'pepper', 'pineapple', 'plum', 'potato', 'pumpkin', 'quince', 'radish', 'raisin', 'rhubarb', 'satsuma', 'sprout', 'squash', 'strawberry', 'tomato', 'turnip', 'ugli', 'watercress', 'watermelon', 'yam'];


var findBuy1Get1Free = function (arrOfObs, arr, option){
	for (var i = arrOfObs.length - 1; i >= 0; i--) {
		if(arrOfObs[i].price.toLowerCase().indexOf('buy') > -1 && arrOfObs[i].price.toLowerCase().indexOf('get') > -1 && arrOfObs[i].price.toLowerCase().indexOf('free') > -1){
			if(option) arr.push(arrOfObs[i]);
		}
		else if (!option) arr.push(arrOfObs[i]);
	};
	return arr;
}

var filterNoSave = function (arrOfObs, arr){
	for (var i = arrOfObs.length - 1; i >= 0; i--) {
		var ob = {}
		, sav = arrOfObs[i].savings
		, pr = arrOfObs[i].price
		, it = arrOfObs[i].item
		, finalSav = 0
		, finalPercent = 0;

		if(sav.indexOf('%') == -1 && isNaN(sav)){
			var filter = sav.match(/(\d[\d\.]*)/g);

			if (filter === null){
				console.log('no savings');
			}
			else if(filter.length > 1){
				var f = +filter[0]
				, p = +pr
				, fNum = f/100;
				if(f[0] === '0'){
					console.log('less than a dollar');
					f /= 100;
				}

				if(filter[0].indexOf('.') > -1){
					console.log('dot found');
					console.log('f: %s, p: %s, fNum: %s', f, p, fNum);
					finalSav = f;
					finalPercent = (f / (f+p) )*100;
					console.log('best %age is: ' + (f / (f+p) )*100+ '\n');
				}
				else{
					finalSav = f;
					finalPercent = (fNum / (fNum+p) )*100;
					console.log('f: %s, p: %s, fNum: %s', f, p, fNum);
					console.log('best %age is: ' + (fNum / (fNum+p) )*100+ '\n');
				}
			}
			else{
				var f = +filter[0]
				, p = +pr
				, fNum = f/100;
				if(f[0] === '0'){
					console.log('less than a dollar');
					f/= 100;
				}
				if(filter[0].indexOf('.') > -1){
					finalSav = f;
					finalPercent = (f / (f+p) )*100;
					console.log('dot found');
					console.log('f: %s, p: %s, fNum: %s', f, p, fNum);
					console.log('best %age is: ' + (f / (f+p) )*100+ '\n');
				}
				else{
					finalSav = f;
					finalPercent = (fNum / (fNum+p) )*100;
					console.log('f: %s, p: %s, fNum: %s', f, p, fNum);
					console.log('best %age is: ' + (fNum / (fNum + p))*100  + '\n');
				}
			}
		}
	};
}

var getSav = function (option, num){
	var ob = {}
	, sav = num.savings
	, pr = num.price
	, finalSav = 0
	, finalPercent = 0;
	if(isNaN(sav)){
		var filter = sav.match(/(\d[\d\.]*)/g);
		if(sav.indexOf('%') == -1){
			if (filter === null || filter === ''){
				console.log('no savings');
			}
			else if(filter.length > 1){
				var f = +filter[0]
				, p = +pr
				, fNum = f/100;
				if(f[0] === '0'){
					//console.log('less than a dollar');
					f /= 100;
				}

				if(filter[0].indexOf('.') > -1){
					//console.log('dot found');
					//console.log('f: %s, p: %s, fNum: %s', f, p, fNum);
					finalSav = f;
					finalPercent = (f / (f+p) )*100;
					//console.log('best %age is: ' + (f / (f+p) )*100+ '\n');
				}
				else{
					finalSav = fNum;
					finalPercent = (fNum / (fNum+p) )*100;
					//console.log('f: %s, p: %s, fNum: %s', f, p, fNum);
					//console.log('best %age is: ' + (fNum / (fNum+p) )*100+ '\n');
				}
			}
			else{
				var f = +filter[0]
				, p = +pr
				, fNum = f/100;
				if(f[0] === '0'){
					//console.log('less than a dollar');
					f/= 100;
				}
				if(filter[0].indexOf('.') > -1){
					finalSav = f;
					finalPercent = (f / (f+p) )*100;
					//console.log('dot found');
					//console.log('f: %s, p: %s, fNum: %s', f, p, fNum);
					//console.log('best %age is: ' + (f / (f+p) )*100+ '\n');
				}
				else{
					finalSav = fNum;
					finalPercent = (fNum / (fNum+p) )*100;
					//console.log('f: %s, p: %s, fNum: %s', f, p, fNum);
					//console.log('best %age is: ' + (fNum / (fNum + p))*100  + '\n');
				}
				console.log(filter);
				console.log(pr);
				console.log(finalSav + " " + finalPercent);
			}
		}
		else{
			if (filter === null){
				console.log('no savings');
			}
			else{
				/** if sav has a % in it, just get the number, that is the finalPercent
					finalSav is still 0. */
				finalPercent = +filter[0];
			}
		}
		
	}
	//console.log('sav: '+finalSav+', %: ' + finalPercent);
	return option ? finalSav : finalPercent
}


var findBestDollarDeal = function (arrOfObs, arr){
	
	var result = []
	, rest = [];
	//result = findBuy1Get1Free(arrOfObs, result, false);
	for (var i = arrOfObs.length - 1; i >= 0; i--) {
		var sav = arrOfObs[i].savings;

		if(sav !== '' && isNaN(sav)){
			var filter = sav.match(/(\d[\d\.]*)/g);
			if (filter !== null){
				result.push(arrOfObs[i]);
			}
			else{
				rest.push(arrOfObs[i]);
			}
		}
		else{
			rest.push(arrOfObs[i]);
		}
	};
	//console.log(result);

	result.sort(function (a,b){
		//
		//console.log(getSav(true, a) + " " + getSav(true, b));
		return getSav(true, a)-getSav(true, b);
	});
	/*
	for (var i = result.length - 1; i >= 0; i--) {
		console.log(result[i].savings);
	};*/
	



	//filterNoSave(arrOfObs, arr);


	return arr;
}





module.exports.findBuy1Get1Free = findBuy1Get1Free;
module.exports.findBestDollarDeal = findBestDollarDeal;