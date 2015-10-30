import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Extras 1.4
//import QtQuick.Enterprise.Controls 1.3

import "UIElements"
//TODO: Button ColorAnimation
//TODO: Adatok megjelenítése
//TODO: Diagram, mit? választható?


ApplicationWindow {
    title: qsTr("RobonAUT Diagnosztika")
    visible: true
    height: 720
    width: 1280
    property real velo_scale: 1



    //C++ oldali kommunikáció

    function log(Message) {
        eventLogModel.append(Message);
        //eventLogger.to  Go aljára
    }





    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("Connect...")
                onTriggered: {
                    //Do something
                    log({ message: "Csatlakozás...", colorCode: "red" });
                }
                enabled: true
            }
            MenuItem {
                text: qsTr("Disconnect")
                onTriggered: {
                    //Do something
                    //log("SzétCsatlakozás...Csatlakozás....Csatlakozás...........");
                }
                enabled: false
            }
            MenuItem {
                text: qsTr("Exit")
                onTriggered: {
                    Qt.quit();
                }
                enabled: true
            }
        }
        Menu {
            title: qsTr("Settings")
            MenuItem {
                text: qsTr("Options one")
                enabled: false
            }
        }

    }

Item {
    anchors.fill: parent
    RowLayout {
        ColumnLayout {
            RowLayout {
                //ControlPanel

                //AdatPanel
            }
            //logger
        }
        ColumnLayout {
            //LineSensor

            //Sebbesség

            //Üres terület
        }
    }
}


    //ControlPanel
    GroupBox {
        x: 50
        y: 50
        width: 175
        height: 240
        ColumnLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 5
            Button {
                id: button1
                Layout.fillWidth: true
                text: qsTr("Start")
                ColorAnimation {
                    from: "grey"
                    to: "green"
                    duration: 200
                }
            }
            Button {
                id: button2
                Layout.fillWidth: true
                text: qsTr("Stop")
            }
            ComboBox {
                Layout.fillWidth: true
                model: ListModel {
                    id: cbItems2
                    ListElement { text: "Esetleg ha"; color: "Green" }
                    ListElement { text: "kellene üzemmódokat"; color: "Green" }
                    ListElement { text: "kiválasztani"; color: "Green" }
                }
            }
            Button {
                id: button3
                Layout.fillWidth: true
                text: qsTr("Beállít")
            }
            DelayButton {
                id: button4
                Layout.fillWidth: true
                //anchors.verticalCenter: parent.verticalCenter

                text: qsTr("Start")
            }
        }
    }
    //LogPanel
    Rectangle {
        x: 50
        y: 300
        width: 200
        height: 300
        radius: 10
        color: "lightsteelblue"

    ListView {
        id: eventLogger
        anchors.fill: parent
        //highlight: Rectangle { color: "blue"; radius: 5 }
        delegate: GroupBox {
            anchors.left: parent.left
            anchors.right: parent.right
            Row {
                id: row2
                Rectangle {
                    width: 40
                    height: 20
                    color: colorCode
                }
                Text {
                    text: message
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                }
                spacing: 10
            }
        }
        model: ListModel {
            id: eventLogModel
            ListElement {
                message: "Program indítás..."
                colorCode: "green"
            }
        }
    }
    }

    //Adatok
    GroupBox {
        x: 225
        y: 50
        width: 200
        height: 300
        //Ötletek:
        // rowLayout-al 2 oszlop
        // ListView
        // ???
    }

    RowLayout {
        id: gaugebox
        x: 455
        y: 69
        GroupBox {
            Layout.fillHeight: true
            ColumnLayout {
                Text {
                    text: qsTr("Sebesség")
                    font.pixelSize: 12
                    Layout.fillWidth: true
                }
                CircularGauge {
                   id: speedgauge
                   scale: 0.9
                   value: 24 * velo_scale
               }
                ComboBox {
                 //currentIndex: 3
                 Layout.fillWidth: true
                 model: ListModel {
                     id: cbItems
                     ListElement { text: "Sebesség     [Km/h]"; color: "Green" }
                     ListElement { text: "Sebesség     [m/s]"; color: "Green" }
                     ListElement { text: "Szögsebesség [deg/s]"; color: "Green" }
                   }
                    onCurrentIndexChanged: {
                        //console.debug(cbItems.get(currentIndex).text + ", " + cbItems.get(currentIndex).color)
                        switch(currentIndex){
                        case 0:
                            velo_scale = 1;
                            speedgauge.maximumValue = 100;
                            break;
                        case 1:
                            velo_scale = 0.5;
                            speedgauge.maximumValue = 60;
                            break;
                        case 2:
                            velo_scale = 1.5;
                            speedgauge.maximumValue = 90;
                            break;
                        }

                    }
                 }
            }
        }
        GroupBox{
            Layout.fillHeight: true
            ColumnLayout {
                Text {
                    text: qsTr("Irány")
                    font.pixelSize: 12
                    Layout.fillWidth: true
                }
                CircularGauge {
                    minimumValue: -30
                    maximumValue: 30
                    value: 0
                    scale: 0.9
                }
            }
        }
    }
    GroupBox {
        anchors.top: gaugebox.bottom
        anchors.left: gaugebox.left
        LineSensor {
            anchors.fill: parent
        }
    }




    /*LineSensor {
        anchors.top: parent.top
        anchors.right: parent.right

        //anchors.margins: 20
    }*/




    /*MainForm {
        anchors.bottom: parent
        mouseArea.onClicked: {
            Qt.quit();
        }
    }*/

}

