var findBuy1Get1Free = function (arrOfObs){
	var resultsArr = [];
	for (var i = arrOfObs.length - 1; i >= 0; i--) {
		if(arrOfObs[i].price.toLowerCase().indexOf('buy') > -1 && arrOfObs[i].price.toLowerCase().indexOf('get') > -1 && arrOfObs[i].price.toLowerCase().indexOf('free') > -1){
			buyOneGetOneFree.push(fly[i]);
		}
	};
	return resultsArr;
}
