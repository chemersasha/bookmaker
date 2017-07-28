function teamsInfo() {
    var result = '<[Team1Name]>&&<[Team2Name]>';

    var teamsInfo = $('.event--name--info')[0].innerText.split("\n");
    result = result.replace('<[Team1Name]>', teamsInfo[0]);
    result = result.replace('<[Team2Name]>', teamsInfo[1]);
    
    return result;
}

teamsInfo();
