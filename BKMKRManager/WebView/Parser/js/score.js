function score() {
    var result = '';
    var scoreEl = document.getElementsByClassName('score')[0];
    result = scoreEl.getElementsByClassName('ev-result')[0].innerText;
    result = result.split(" ")[0];
    
    return result;
}

score();
