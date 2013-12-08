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
			
				var filter = sav.match(/(\d[\d\.]*)/g);
				if (filter === null){
					console.log('no savings ' + pr);
				}
				else if(filter.length > 1){

					console.log('well ' + filter[0]);
				}
				else{
					
					console.log("best savings: " + filter);
				}
			
		}
	};
	return arr;
}

module.exports.findBuy1Get1Free = findBuy1Get1Free;
module.exports.findBestDollarDeal = findBestDollarDeal;