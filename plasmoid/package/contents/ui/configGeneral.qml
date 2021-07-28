import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.4 as Kirigami

Item {
    id: page

    property string cfg_apiKey: plasmoid.configuration.apiKey
    property int cfg_lyricsProvider: plasmoid.configuration.lyricsProvider

    Kirigami.FormLayout {
        anchors.left: parent.left
        anchors.right: parent.right

        ComboBox {
            Kirigami.FormData.label: "Lyrics provider:"
            textRole: "text"
            valueRole: "value"
            onActivated: cfg_lyricsProvider = currentValue
            Component.onCompleted: currentIndex = indexOfValue(cfg_lyricsProvider)
            model: [
                { value: Qt.NoModifier, text: qsTr("Lyrics.ovh") },
                { value: Qt.ShiftModifier, text: qsTr("Musixmatch") },
            ]
        }

        TextField {
            id: apiKey
            Kirigami.FormData.label: "API key:"
            text: cfg_apiKey
            onTextChanged: cfg_apiKey = text
            readOnly: cfg_lyricsProvider === 0 ? true : false
        }

    }
}
