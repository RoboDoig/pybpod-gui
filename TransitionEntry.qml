import QtQuick 2.0
import QtQuick.Window 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.13
import QtQuick.Shapes 1.11

Rectangle {
    id: transitionDefinition
    width: 200
    height: 200
    color: "#e1e1e1"
    border.width: 0
    Layout.fillHeight: false
    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
    Layout.preferredHeight: 40
    Layout.fillWidth: true

    property alias conditionText: textInput.text
    property alias stateText: textInput1.text

    signal textChanged()

    GridLayout {
        id: gridLayout2
        anchors.fill: parent
        columnSpacing: 2
        rowSpacing: 1

        TextInput {
            id: textInput
            width: 80
            height: 20
            text: qsTr("Condition")
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: "Courier"
            Layout.preferredWidth: 60
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            onAccepted: {
                transitionDefinition.textChanged()
            }
        }

        TextInput {
            id: textInput1
            width: 80
            height: 20
            text: qsTr("State")
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: "Courier"
            Layout.preferredWidth: 60
            Layout.fillHeight: false
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            onAccepted: {
                transitionDefinition.textChanged()
            }
        }
    }
}
