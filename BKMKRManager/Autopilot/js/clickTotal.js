function clickTotal() {
    var totalsBlockHeader = $(".markets--head").contents().filter(function() {
		return ((this.nodeType == Node.TEXT_NODE) && (this.nodeValue === "Тотал"));
    });
    var resultTypesList = totalsBlockHeader[0].parentNode.parentNode.getElementsByClassName('result--types--list');
    var outcomeList = resultTypesList[0].getElementsByClassName('outcome--list')[0];
    outcomeList.querySelector("[title='Больше (<<<>>>)']").click();
}

clickTotal();
