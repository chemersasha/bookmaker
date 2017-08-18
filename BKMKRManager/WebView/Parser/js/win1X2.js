function win1X2() {
    var result = '';
    
    var winBlockHeader = $(".markets--head").contents().filter(function() {
		return ((this.nodeType == Node.TEXT_NODE) && (this.nodeValue === "Победа"));
    });
    if (winBlockHeader[0] !== 'undefined') {
        var winsList = winBlockHeader[0].parentNode.parentNode.getElementsByClassName('result--types--list');
        var outcomes = winsList[0].getElementsByClassName('outcome--list');
        var outcomes = outcomes[0].getElementsByClassName('outcome');
        
        if(outcomes.length == 3) {
            // receive first teame win coef
            var outcome0 = outcomes[0].innerText;
            outcome0 = outcome0.split("\n");
            result = outcome0[1];
             
            // draw coef
            var outcome1 = outcomes[1].innerText;
            outcome1 = outcome1.split("\n");
            result = result + '&&' + outcome1[1];
            
            // receive second teame win coef
            var outcome2 = outcomes[2].innerText;
            outcome2 = outcome2.split("\n");
            result = result + '&&' + outcome2[1];
        }
    }
    
    return result;
}

win1X2();
