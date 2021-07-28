import QtQuick 2.0
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.extras 2.0 as PlasmaExtras

Item {
    // Always display the compact view.
    // Never show the full popup view even if there is space for it.
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation

    Plasmoid.fullRepresentation: Item {
        Layout.minimumWidth: 300
        Layout.minimumHeight: 480
        Layout.preferredWidth: 300 * PlasmaCore.Units.devicePixelRatio
        Layout.preferredHeight: 400 * PlasmaCore.Units.devicePixelRatio

        function parseInput() {
            const artistAndSong = input.text.split("-");

            if(artistAndSong.length != 2 || artistAndSong[0].trim().length == 0 || artistAndSong[1].trim().length == 0){
                return { error: "Invalid input. Please insert on the 'artist - song' format." }
            } else {
                const artist = artistAndSong[0].trim();
                const song = artistAndSong[1].trim();

                return { artist, song };
            }
        }

        function handleSearch() {
            textArea.remove(0, textArea.length);

            const input = parseInput();

            if(input.error){
                textArea.insert(0, input.error);
            } else {
                textArea.insert(0, "Searching lyrics...");

                apiWorker.sendMessage({ 'artist': input.artist, 'song': input.song, 'api_key': plasmoid.configuration.apiKey });
            }
        }

        function handleSource() {
            const lyricsProvider = plasmoid.configuration.lyricsProvider;

            if(lyricsProvider === undefined || lyricsProvider === 0) {
                return "../modules/lyricsovh.mjs";
            } else {
                return "../modules/musixmatch.mjs";
            }
        }

        WorkerScript {
            id: apiWorker
            source: handleSource()
            onMessage: {
                textArea.remove(0, textArea.length);
                textArea.insert(0, messageObject.message);
                textArea.select(0, 1);
                textArea.deselect();
            }
        }

        ColumnLayout {
            anchors.fill: parent

            RowLayout {
                Layout.preferredWidth: 300

                PlasmaComponents.TextField {
                    id: input
                    Layout.fillWidth: true
                    placeholderText: "Search Lyrics..."
                    onAccepted: handleSearch()
                }

                PlasmaComponents.Button {
                    Layout.fillWidth: true
                    text: "Search"
                    onClicked: handleSearch()
                }

                PlasmaComponents.Button {
                    function copyToClipboard() {
                        textArea.selectAll()
                        textArea.copy()
                        textArea.deselect()
                    }

                    id: copyButton
                    Layout.fillWidth: true
                    iconSource: "edit-copy"
                    onClicked: copyToClipboard()
                }
            }

            PlasmaComponents.TextArea {
                id: textArea
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: ""
            }
        }
    }
}
