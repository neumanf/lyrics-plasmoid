WorkerScript.onMessage = function (message) {
    const req = new XMLHttpRequest();

    req.open(
        "GET",
        `https://api.lyrics.ovh/v1/${message.artist}/${message.song}`
    );

    req.onload = function () {
        try {
            const json = JSON.parse(req.responseText);

            if (json.error !== undefined) {
                WorkerScript.sendMessage({ message: json.error });
            } else {
                WorkerScript.sendMessage({ message: json.lyrics });
            }
        } catch (e) {
            WorkerScript.sendMessage({ message: "Error: Lyrics not found." });
        }
    };

    req.send();
};
