function matchTime() {
    var result = '';
    var timeEl = document.getElementsByClassName('event--timer')[0];
    result = timeEl.innerText;
    
    return result;
}

matchTime();
