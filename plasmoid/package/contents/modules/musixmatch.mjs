WorkerScript.onMessage = function (message) {
    if(message.api_key === undefined || message.api_key.length === 0) {
        return WorkerScript.sendMessage({ message: "Error: No API key found, set it in settings." });
    }

    const req = new XMLHttpRequest();

    req.open(
        "GET",
        `http://api.musixmatch.com/ws/1.1/matcher.lyrics.get?apikey=${message.api_key}&q_artist=${message.artist}&q_track=${message.song}`
    );

    req.onload = function () {
        try {
            const json = JSON.parse(req.responseText);
            const statusCode = json.message.header.status_code;
            const lyrics = json.message.body.lyrics;

            if(statusCode === 401) {
                WorkerScript.sendMessage({ message: "Error: Invalid API key." });
            } else if(statusCode === 200) {
                if(lyrics) {
                    WorkerScript.sendMessage({ message: lyrics.lyrics_body });
                } else {
                    WorkerScript.sendMessage({ message: "Error: Lyrics not found." });
                }
            }
        } catch (e) {
            WorkerScript.sendMessage({ message: "Error: An unexpected error occurred." });
        }
    };

    req.send();
};
