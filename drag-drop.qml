import QtQuick 2.0
import QtQuick.Window 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.13
import QtQuick.Shapes 1.11

ApplicationWindow {
    id: root
    visible: true
    objectName: "applicationWindow"
    width: 1020
    height: 640
    title: qsTr("pybpod-design-gui")
    property var statesDict: ({})
    property var selectedID: -1
    property var selectedOutNode

    function stateCreated(name, timer, id) {
        root.statesDict[id] = Qt.createComponent("CustomDragBox.qml").createObject(designPanel)
        root.statesDict[id].stateNameText = name
        root.statesDict[id].timerText = timer
        root.statesDict[id].stateID = id

        // Function hooks
        root.statesDict[id].selectRequest.connect(stateSelected)
        root.statesDict[id].dataChanged.connect(stateUpdated)

        root.statesDict[id].drawingCanvas = drawingCanvas
    }

    function deselectAll() {
        for (var state in root.statesDict) {
            root.statesDict[state].deselect()
        }
    }

    function stateSelected(ID) {
        deselectAll()
        root.statesDict[ID].select()
        selectedID = ID

        iface.state_selected(ID)
    }

    function stateUpdated(id, name, timer) {
        iface.update_state(id, name, timer)
    }

    function clearTransitions() {
        for (var i = gridLayout1.children.length; i > 0; i--) {
            iface.printer(i)
            gridLayout1.children[i-1].destroy()
        }
    }

    function addTransition(condition, state) {
        var transitionEntry = Qt.createComponent("TransitionEntry.qml").createObject(gridLayout1)
        transitionEntry.conditionText = condition
        transitionEntry.stateText = state

        transitionEntry.textChanged.connect(root.testFun)
    }

    function testFun() {
        iface.printer("testFun")
    }

    GridLayout {
        id: mainGridLayout
        anchors.fill: parent
        rows: 1
        columns: 5

        Rectangle {
            id: controlPanel
            width: 150
            height: 640
            color: "#ffffff"
            border.width: 3
            Layout.fillHeight: true
            Layout.fillWidth: true

            GridLayout {
                id: controlPanelGridLayout
                anchors.fill: parent
                anchors.rightMargin: 10
                anchors.leftMargin: 10
                anchors.bottomMargin: 480
                anchors.topMargin: 30
                rows: 5
                columns: 1

                Button {
                    id: addNewStateButton
                    objectName: "button"
                    text: qsTr("New State")
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    checked: false
                    font.family: "Courier"
                    onClicked: {
                        iface.create_new_state()
                    }
                }

                Button {
                    id: resetButton
                    text: qsTr("Reset")
                    checked: false
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    objectName: "button"
                    font.family: "Courier"
                    onClicked: {
                        for (var state in root.statesDict) {
                            root.statesDict[state].deselect()
                            selectedID = -1
                            root.clearTransitions()
                        }
                    }
                }
            }

        }

        Rectangle {
            id: designPanel
            width: 708
            height: 640
            color: "#ffffff"
            border.width: 3
            Layout.columnSpan: 3
            Layout.fillHeight: true
            Layout.fillWidth: true

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
        }

        Rectangle {
            id: infoPanel
            width: 150
            height: 640
            color: "#ffffff"
            radius: 0
            border.width: 3
            Layout.preferredWidth: 250
            Layout.columnSpan: 1
            Layout.fillHeight: true
            Layout.fillWidth: true

            GridLayout {
                id: gridLayout1
                anchors.fill: parent
                flow: GridLayout.TopToBottom
                rows: 20
                columns: 1
                columnSpacing: 1
                rowSpacing: 1
                anchors.rightMargin: 20
                anchors.leftMargin: 20
                anchors.bottomMargin: 160
                anchors.topMargin: 30
            }

            GridLayout {
                id: gridLayout
                anchors.fill: parent
                anchors.rightMargin: 20
                anchors.leftMargin: 20
                anchors.bottomMargin: 20
                anchors.topMargin: 497

                Button {
                    id: addTransitionButton
                    text: qsTr("+")
                    font.family: "Courier"
                    Layout.preferredHeight: 20
                    Layout.preferredWidth: 10
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.fillHeight: false
                    Layout.fillWidth: true

                    onClicked: {
                        if (root.selectedID >= 0) {
                            iface.add_transition(root.selectedID)
                        }
                    }
                }

                Button {
                    id: removeTransitionButton
                    text: qsTr("-")
                    font.family: "Courier"
                    Layout.preferredHeight: 20
                    Layout.preferredWidth: 10
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.fillHeight: false
                    Layout.fillWidth: true

                    onClicked: {
                        gridLayout1.children[gridLayout1.children.length-1].destroy()
                    }
                }
            }
        }

    }



}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}D{i:3}D{i:2}D{i:10}D{i:11}D{i:1}
}
##^##*/
