import QtQuick 2.5
import QtQuick.Layouts 1.1
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import com.RobotState 1.0
import com.RobotProxy 1.0

import "UIElements"

Item {
    anchors.fill: parent

    property alias eventLogModel: eventLogModel
    property alias onlineadatok: onLineAdatok


    RowLayout {
        anchors.fill: parent
        ColumnLayout {
            anchors.top: parent.top
            anchors.left: parent.left
            RowLayout {
                anchors.fill: parent
                //ControlPanel
                GroupBox {
                    id: controlpanel
                    width: 175
                    height: 240
                    anchors.top: parent.top
                    anchors.left: parent.left
                    ColumnLayout {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        spacing: 5
                        Text {
                            Layout.fillWidth: true
                            text: qsTr("Frissítési sebesség: ")
                        }
                        ComboBox {
                            Layout.fillWidth: true
                            model: ListModel {
                                id: cbItems2
                                ListElement { text: "100 ms"; }
                                ListElement { text: "250 ms"; }
                                ListElement { text: "500 ms"; }
                                ListElement { text: "1000 ms"; }
                                ListElement { text: "2000 ms"; }
                            }
                            onCurrentIndexChanged: {
                                switch(currentIndex) {
                                case 0:
                                       timer.interval = 100;
                                       break;
                                case 1:
                                       timer.interval = 250;
                                       break;
                                case 2:
                                       timer.interval = 500;
                                       break;
                                case 3:
                                       timer.interval = 1000;
                                       break;
                                case 4:
                                       timer.interval = 2000;
                                       break;
                                }
                            }
                        }
                        DelayButton {
                            id: button4
                            Layout.fillWidth: true

                            text: qsTr("Adatok frissítése")
                            onActivated: {
                                log({ message: "Automatikus frissítés...", colorCode: "red",logIndex: -1 });
                                timer.start();
                            }
                            onPressedChanged: {
                                if (pressed) {
                                    log({ message: "Automatikus frissítés leállítva...", colorCode: "blue", logIndex: -1 });
                                    timer.stop();
                                }
                            }
                            onEnabledChanged: {
                                if (!enabled) {
                                    timer.stop();
                                }
                            }
                            enabled: rp.isOnline;
                        }
                        Timer {
                            id: timer
                            repeat: true
                            onTriggered: {
                                if (rp.isOnline) rp.refreshState();
                            }
                        }
                        CheckBox {
                            id: onLineAdatok
                            Layout.fillWidth: true
                            text: qsTr("Online adatok")
                            checked: true
                            onCheckedChanged: {
                                if (checked) {
                                    lastindex = h.historyList.length - 1
                                }
                            }
                        }
                    }
                }

                //Adatok
                GroupBox {
                    id: controlgroupbox
                    Layout.minimumWidth: 150
                    Layout.maximumWidth: 150
                    anchors.top: controlpanel.top
                    anchors.bottom: controlpanel.bottom
                    ColumnLayout {
                        spacing: 5
                        anchors.left: parent.left
                        anchors.right: parent.right
                        Text{
                            text: qsTr("Irányítás:")
                        }
                        CheckBox {
                            id: automanualcheckbox
                            Layout.fillWidth: true
                            text: qsTr("Automata bekapcsolva")
                            checked: haveData ? !(h.historyList[lastindex].status == RobotState.Manual) : false
                            onCheckedChanged: {
                                if (checked) {
                                    automanualcheckbox.text = "Automata bekapcsolva!";
                                    log({ message: "Automata mód bekapcsolva!", colorCode: "red", logIndex: -1 });
                                    rp.setMode(RobotProxy.Auto);
                                }
                                else {
                                    automanualcheckbox.text = "Manual bekapcsolva!";
                                    log({ message: "Manuál mód bekapcsolva!", colorCode: "red", logIndex: -1 });
                                    rp.setMode(RobotProxy.Manual);
                                }
                            }
                            enabled: rp.isOnline
                        }
                        Button {
                            id: button1
                            anchors.left: parent.left
                            anchors.right: parent.right
                            text: qsTr("Gyorsít!")
                            onClicked: {
                                log({ message: "Gyorsítás parancs elküldve!", colorCode: "white", logIndex: -1 });
                                rp.sendCommand(RobotProxy.Accelerate)
                            }
                            enabled: rp.isOnline && (h.historyList[lastindex].status == RobotState.Manual)

                        }
                        Button {
                            id: button2
                            anchors.left: parent.left
                            anchors.right: parent.right
                            text: qsTr("Lassít/Tolat!")
                            onClicked: {
                                log({ message: "Lassítás parancs elküldve!", colorCode: "white", logIndex: -1 });
                                rp.sendCommand(RobotProxy.Brake)
                            }
                            enabled: rp.isOnline && (h.historyList[lastindex].status == RobotState.Manual)
                        }
                        Row {
                            spacing: 5
                            anchors.left: parent.left
                            anchors.right: parent.right
                            //Layout.fillWidth: true
                            Button {
                                id: leftbutton
                                text: qsTr("Balra!")
                                width: (parent.width/2 - parent.spacing/2)
                                onClicked: {
                                    log({ message: "Balra parancs elküldve!", colorCode: "white", logIndex: -1 });
                                    rp.sendCommand(RobotProxy.Left)
                                }
                                enabled: rp.isOnline && (h.historyList[lastindex].status == RobotState.Manual)
                            }
                            Button {
                                id: rightbutton
                                text: qsTr("Jobbra!")
                                width: (parent.width/2 - parent.spacing/2)
                                onClicked: {
                                    log({ message: "Jobbra parancs elküldve!", colorCode: "white", logIndex: -1 });
                                    rp.sendCommand(RobotProxy.Right)
                                }
                                enabled: rp.isOnline && (h.historyList[lastindex].status == RobotState.Manual)
                            }
                        }
                    }
                }
                GroupBox {
                    Layout.fillWidth: true
                    Layout.minimumHeight: controlpanel.height
                    Layout.minimumWidth: 260
                    ColumnLayout {
                    Text{
                        text: "Kapcsolódva: " + (rp.isOnline ? "igen" : "nem");
                        Layout.fillWidth: true
                        height: 10
                    }
                    Text{
                        text: "Státusz: " + (haveData ? h.historyList[lastindex].statusName : "nincs adat");
                        Layout.fillWidth: true
                        height: 10
                    }
                    Text{
                        text: "Akkumulátor feszültség: " + (haveData ? h.historyList[lastindex].battery : "nincs adat");
                        Layout.fillWidth: true
                        height: 10
                    }
                    Text{
                        text: "Fordulatszám: "  + (haveData ? h.historyList[lastindex].speed : "nincs adat");
                        Layout.fillWidth: true
                        height: 10
                    }
                    Text{
                        text: "Szervo: "  + (haveData ? h.historyList[lastindex].servo : "nincs adat");
                        Layout.fillWidth: true
                        height: 10
                    }
                    Text{
                        text: "History lista hossz: " + h.historyList.length;
                        Layout.fillWidth: true
                        height: 10
                    }
                    }
                }
            }
            //LogPanel
            Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.minimumHeight: 300
                Layout.minimumWidth: 200
                radius: 10
                color: "lightsteelblue"
                ScrollView {
                    anchors.fill: parent
                    ListView {
                        id: eventLogger
                        anchors.fill: parent
                        highlight: Rectangle { color: "steelblue"; radius: 5 }
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
                            MouseArea {
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                width: row2.width
                                onClicked: if (!onLineAdatok.checked && eventLogModel.get(index).logIndex > -1){
                                                    lastindex = eventLogModel.get(index).logIndex;
                                                    eventLogger.currentIndex = index;
                                               }
                                }

                            property int logIndex: 0
                          }
                        model: ListModel {
                            id: eventLogModel
                            ListElement {
                                message: "Program indítás..."
                                colorCode: "green"
                                logIndex: -1
                                        }
                                }
                        onCountChanged: {
                            if (onLineAdatok.checked) eventLogger.currentIndex = eventLogger.count -1;
                            }
                        }
                    }
                }
            }
        ColumnLayout {
            //LineSensor
            Layout.fillWidth: true
            GroupBox {
                id: groupBox1
                Layout.minimumHeight: 150
                ColumnLayout {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 1
                    spacing: 1
                    RowLayout {
                        id: rowl1
                        Layout.fillWidth: true
                        Layout.minimumHeight: 65
                        Repeater{
                            id: sensor_row1
                            model: 24
                            Rectangle {
                                anchors.bottom: parent.bottom
                                width: 14
                                height: (haveData ? h.historyList[lastindex].back_line[index]*65/4096 : 0)//index
                                color: "lightsteelblue"
                                Text {
                                    text: (parent.height*100/65).toFixed(0) //+ "%"
                                    font.pointSize: 7
                                    font.bold: true
                                    color: "black"
                                    anchors.bottom: parent.bottom
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }
                    }

                    RowLayout {
                        id: rowl2
                        Layout.fillWidth: true
                        height: 7
                        Repeater {
                            id: reptarg
                            model: 24
                            Rectangle {
                                id: sensor_teglalapok1
                                anchors.bottom: parent.bottom
                                anchors.top: parent.top
                                width: 14
                                color: "blue"//Color.rgb...
                                border.color: "black"
                                border.width: 1
                                ToolTip{
                                     id: tooltip1
                                     width: 70
                                     target: sensor_teglalapok1//sensor_row1.itemAt(index)
                                     text: (haveData ? (h.historyList[lastindex].back_line[index] + "/4096") : "Nincs adat!") //(h.historyList[lastindex].back_line[index]*100/4096).toFixed(0) + "%"
                                }
                            }
                        }
                    }
                    RowLayout {
                        id: rowl3
                        Layout.fillWidth: true
                        Layout.minimumHeight: 65
                        Repeater{
                            id: sensor_row2
                            model: 24
                            Rectangle {
                                anchors.bottom: parent.bottom
                                width: 14
                                height: (haveData ? h.historyList[lastindex].front_line[index]*65/4096 : 0)//index
                                color: "lightsteelblue"
                                Text {
                                    text: (parent.height*100/65).toFixed(0) //+ "%"
                                    font.pointSize: 7
                                    font.bold: true
                                    color: "black"
                                    anchors.bottom: parent.bottom
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }

                        }
                    }

                    RowLayout {
                        id: rowl4
                        Layout.fillWidth: true
                        height: 7
                        Repeater {
                            model: 24
                            Rectangle {
                                id: sensor_teglalapok2
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                width: 14
                                color: "blue"
                                border.color: "black"
                                border.width: 1
                                ToolTip{
                                     id: tooltip2
                                     width: 70
                                     target: sensor_teglalapok2
                                     text: (haveData ? (h.historyList[lastindex].front_line[index] + "/4096") : "Nincs adat!") //(h.historyList[lastindex].back_line[index]*100/4096).toFixed(0) + "%"
                                }
                            }
                        }
                    }
                }

            }
            property real velocity: 0
            property real direction: 0
            //Sebbesség
            RowLayout {
                id: gaugebox
                spacing: 5
                anchors.top: groupBox1.bottom
                anchors.left: groupBox1.left
                anchors.right: groupBox1.right
                GroupBox {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    ColumnLayout {
                        Text {
                            text: qsTr("Sebesség")
                            font.pixelSize: 12
                            Layout.fillWidth: true
                        }
                        CircularGauge {
                           id: speedgauge
                           scale: 1
                           value: (haveData ? Math.abs(velo_scale * h.historyList[lastindex].speed) : 0)
                           style: CircularGaugeStyle {
                               labelStepSize: 2
                           }
                           Text {
                               anchors.bottom: parent.bottom
                               anchors.horizontalCenter: parent.horizontalCenter
                               text: (haveData ? (h.historyList[lastindex].speed < 0 ? "R" : "D") : "D")
                               color: (haveData ? (h.historyList[lastindex].speed < 0 ? "red" : "green") : "green")
                               font.pointSize: 9
                           }
                       }
                        ComboBox {
                         //currentIndex: 3
                         Layout.fillWidth: true
                         model: ListModel {
                             id: cbItems
                             ListElement { text: "Sebesség     [Km/h]"; color: "Green" }
                             ListElement { text: "Sebesség     [m/s]"; color: "Green" }
                           }
                            onCurrentIndexChanged: {
                                switch(currentIndex){
                                case 0:
                                    velo_scale = (1/attetel)*((kerekatmero/10)*2*Math.PI)
                                    speedgauge.maximumValue = 40;
                                    break;
                                case 1:
                                    velo_scale = (1/attetel)*((kerekatmero/10)*2*Math.PI)*(1/3.6)
                                    speedgauge.maximumValue = 25;
                                    break;
                                }
                            }
                         }
                    }
                }
                Item {

                }

                GroupBox {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    ColumnLayout {
                        Text {
                            text: qsTr("Irány")
                            font.pixelSize: 12
                            Layout.fillWidth: true
                        }
                        CircularGauge {
                            id: directiongauge
                            minimumValue: -30
                            maximumValue: 30
                            value: (haveData ? h.historyList[lastindex].servo : 0)
                            scale: 1
                            style: CircularGaugeStyle {
                                minimumValueAngle: -90
                                maximumValueAngle: 90
                                labelStepSize: 5
                            }
                        }
                    }
                }
            }
            //Üres terület
            GroupBox {
                //title: qsTr("UI Tesztelése:")
                Layout.fillHeight: true
                anchors.right: groupBox1.right
                anchors.left: groupBox1.left
            }

        }
    }
}

