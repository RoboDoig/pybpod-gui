import QtQuick 2.0
import QtQuick.Window 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.13
import QtQuick.Shapes 1.11

ApplicationWindow {
    id: root
    visible: true
    objectName: "applicationWindow"
    width: 640
    height: 480
    title: qsTr("drag-drop")
    property var statesDict: ({})
    property var stateID: 0
    property var selectedOutNode

    MouseArea {
        id: mainMouseArea
        anchors.fill: parent
        onClicked: {
            //drawingCanvas.requestPaint()
        }

        hoverEnabled: true
    }

    Canvas {
        id: drawingCanvas
        anchors.fill: parent
        onPaint:
        {
//            var ctx = drawingCanvas.getContext('2d')
//            ctx.lineWidth = 2
//            ctx.beginPath()
//            ctx.moveTo(drawingCanvas.width/2, drawingCanvas.height/2)
//            ctx.lineTo(mainMouseArea.mouseX, mainMouseArea.mouseY)
//            //ctx.closePath()
//            ctx.stroke()
        }
    }

    Button {
        id: button
        objectName: "button"
        text: qsTr("Create New")
        property var tempState
        x: 0
        y: 0
        onClicked: {
            root.statesDict[root.stateID] = Qt.createComponent("CustomDragBox.qml").createObject(root)
            iface.create_new(root.statesDict)

            root.statesDict[root.stateID].drawingCanvas = drawingCanvas
            root.statesDict[root.stateID].stateID = root.stateID
            root.statesDict[root.stateID].stateNameText = "state" + root.stateID
            root.stateID += 1
        }
    }
}
