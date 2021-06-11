WorkerScript.onMessage = function(message) {
    var req = new XMLHttpRequest;

    req.open("GET", "https://api.lyrics.ovh/v1/" + message.artist + "/" + message.song);
    req.onload = function() {
        try {
            var objectArray = JSON.parse(req.responseText);

            if (objectArray.error !== undefined) {
                WorkerScript.sendMessage({ 'lyrics': objectArray.error })
            } else {
                WorkerScript.sendMessage({ 'lyrics': objectArray.lyrics })
            }
        } catch (e) {
            WorkerScript.sendMessage({ 'lyrics': "Error: Lyrics not found." })
        }
    }
    req.send();
}
