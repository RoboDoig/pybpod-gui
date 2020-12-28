import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.13
import QtQuick.Shapes 1.14

Rectangle {
    id: rectangle
    objectName: "dragBox"
    width: 100
    height: 100
    color: "#fdfdfd"
    radius: 0
    border.color: "#000000"
    border.width: 4
    property var stateID
    property var drawingCanvas
    property alias stateNameText: stateNameTextInput.text
    property alias timerText: timerTextInput.text
    property real inNodeX: inNode.x
    property real inNodeY: inNode.y
    property real outNodeX: outNode.x
    property real outNodeY: outNode.y

    signal selectRequest(var ID)

    signal dataChanged(var ID, var name, var timer)

    function select() {
        rectangle.border.color = "#979797"
        outNode.color = "#979797"
        inNode.color = "#979797"
    }

    function deselect() {
        rectangle.border.color = "#000000"
        outNode.color = "#000000"
        inNode.color = "#000000"
    }

    MouseArea {
        id: controlMouseArea
        anchors.fill: parent
        drag.target: rectangle
        onReleased: iface.on_released(parent)
        propagateComposedEvents: true
        onClicked: {
            rectangle.selectRequest(rectangle.stateID)
            drawingCanvas.requestPaint()
        }
        onPositionChanged: {
            drawingCanvas.requestPaint()
        }
    }

    ProgressBar {
        id: progressBar
        x: 8
        y: 76
        width: 84
        height: 24
        value: 0.05
    }

    TextInput {
        id: stateNameTextInput
        x: 10
        y: 8
        width: 80
        height: 20
        text: qsTr("State Name")
        font.pixelSize: 12
        horizontalAlignment: Text.AlignHCenter
        font.family: "Courier"

        onAccepted: {
            rectangle.dataChanged(rectangle.stateID, stateNameTextInput.text, timerTextInput.text)
        }
    }

    Rectangle {
        id: outNode
        x: 96
        y: 46
        width: 9
        height: 9
        color: "#000000"
        property var selected: false
        MouseArea {
            id: outNodeMouseArea
            anchors.fill: parent
            hoverEnabled: true
        }
    }

    Rectangle {
        id: inNode
        width: 9
        height: 9
        color: "#000000"
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.verticalCenterOffset: 1
        anchors.leftMargin: -5
    }

    TextInput {
        id: timerTextInput
        x: 10
        y: 34
        width: 80
        height: 20
        text: qsTr("0")
        font.pixelSize: 12
        horizontalAlignment: Text.AlignHCenter
        font.family: "Courier"

        onAccepted: {
            rectangle.dataChanged(rectangle.stateID, stateNameTextInput.text, timerTextInput.text)
        }
    }
}
/*##^##
Designer {
    D{i:0;formeditorZoom:3}D{i:6}
}
##^##*/
