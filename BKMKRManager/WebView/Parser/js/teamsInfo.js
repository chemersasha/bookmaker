function teamsInfo() {
    var result = '<[Team1Name]>&&<[Team2Name]>';

    var head = document.getElementsByClassName('mrk-head');
    var item = head[0].getElementsByClassName('mrk-itm');
    var m1 = item[0].getElementsByClassName('m_1');
    if(m1.length > 0) {
        var m3 = item[0].getElementsByClassName('m_3');
        
        result = result.replace('<[Team1Name]>', m1[0].innerText.split("\n")[0]);
        result = result.replace('<[Team2Name]>', m3[0].innerText.split("\n")[0]);
    } else {
        var ttt = item[0].getElementsByClassName('ttt');

        result = result.replace('<[Team1Name]>', ttt[0].innerText.split(" - ")[0]);
        result = result.replace('<[Team2Name]>', ttt[0].innerText.split(" - ")[1]);
    }
    
    return result;
}

teamsInfo();
