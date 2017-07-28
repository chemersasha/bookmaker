function totals() {
    var result = '';

    var totalsBlockHeader = $(".markets--head").contents().filter(function() {
		return ((this.nodeType == Node.TEXT_NODE) && (this.nodeValue === "Тотал"));
    });
    result = totalsBlockHeader[0].parentNode.parentNode.getElementsByClassName('result--types--list');
	result = result[0].getElementsByClassName('outcome--list')[0].innerText.replaceAll(')\n',')&');
    //remove '\n' character
    result = result.substring(0, result.length - 1);

	return result;
}

totals();
