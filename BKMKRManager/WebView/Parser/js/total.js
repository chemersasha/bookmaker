function totals() {
    var result = '';
    var totalSection = document.querySelectorAll('[data-clue=Тотал]')[0];
    var totals = totalSection.getElementsByClassName('bets_fullmark_body');
    
    for (var i=0; i<totals.length; i++) {
        result = result + totals[i].innerText.replace('\n','&');
    }
    //remove '\n' character
    result = result.substring(0, result.length - 1);
    
    return result;
}

totals();
