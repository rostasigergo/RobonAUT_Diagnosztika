import QtQuick 2.5
import QtQuick.Layouts 1.1
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4

Item {
    anchors.fill: parent

    property alias eventLogModel: eventLogModel

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
                        Button {
                            id: button1
                            Layout.fillWidth: true
                            text: qsTr("Start")
                            ColorAnimation {
                                from: "grey"
                                to: "green"
                                duration: 200
                            }
                            onClicked: {
                                log({ message: "Start...", colorCode: "green" });
                            }

                        }
                        Button {
                            id: button2
                            Layout.fillWidth: true
                            text: qsTr("Stop")
                            onClicked: {
                                log({ message: "Stop...", colorCode: "red" });
                            }
                        }
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
                        /*Button {
                            id: button3
                            Layout.fillWidth: true
                            text: qsTr("Beállít")
                            onClicked: {
                                log({ message: "Beállítás...", colorCode: "yellow" });
                            }
                        }*/
                        DelayButton {
                            id: button4
                            Layout.fillWidth: true

                            text: qsTr("Adatok frissítése")
                            onClicked: {
                                log({ message: "Frissítés...", colorCode: "blue" });
                                //rp.refreshState();

                            }
                            onActivated: {
                                log({ message: "Automatikus frissítés...", colorCode: "red" });
                                timer.start();
                            }
                            // enabled: rp.isOnline;
                        }
                        Timer {
                            id: timer
                            repeat: true
                            onTriggered: {
                                log({ message: "Timer triggered...", colorCode: "red" });
                                //rp.refreshState();
                            }
                        }
                    }
                }

                //Adatok
                GroupBox {
                    Layout.fillWidth: true
                    Layout.minimumHeight: controlpanel.height
                    Layout.minimumWidth: 260
                    ColumnLayout {
                    Text{
                        text: "Kapcsolódva: " //+ (rp.isOnline ? "igen" : "nem");
                        Layout.fillWidth: true
                        height: 10
                    }
                    Text{
                        text: "Státusz: "// + robot.statusName;
                        Layout.fillWidth: true
                        height: 10
                    }
                    Text{
                        text: "Akkumulátor feszültség: "// + robot.battery;
                        Layout.fillWidth: true
                        height: 10
                    }
                    Text{
                        text: "Sebesség: "//  + robot.speed;
                        Layout.fillWidth: true
                        height: 10
                    }
                    Text{
                        text: "Szervo: "//  + robot.servo;
                        Layout.fillWidth: true
                        height: 10
                    }
                    Text{
                        text: "History sebesség: " //+ h.historyList[0].speed;
                        Layout.fillWidth: true
                        height: 10
                    }
                    Text{
                        text: "History lista hossz: "// + h.historyList.length;
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
                        onCountChanged: {
                            eventLogger.currentIndex = eventLogger.count -1;
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
                    spacing: 50
                    RowLayout {
                        Layout.fillWidth: true
                        Repeater {
                            model: 24
                            Rectangle {
                                // id: sensor1
                                width: 14
                                height: 7
                                color: "blue"
                                border.color: "black"
                                border.width: 1
                            }
                        }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        Repeater {
                            model: 24
                            Rectangle {
                                // id: sensor1
                                width: 14
                                height: 7
                                color: "blue"
                                border.color: "black"
                                border.width: 1
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
                           value: 0 * velo_scale
                           //value: spedgauge.value = velo_scale * robot.speed
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
                                    velo_scale = 0.5*kerekatmero/100/attetel*3.6;
                                    speedgauge.maximumValue = 72;
                                    break;
                                case 1:
                                    velo_scale = 0.5*kerekatmero/100/attetel;//d->r 0.5,
                                    speedgauge.maximumValue = 27;//20
                                    break;
                                case 2:
                                    velo_scale = 1;
                                    speedgauge.maximumValue = 400*attetel;
                                    break;
                                }
                                speedgauge.value = slider1.value * velo_scale;//! frissítés váltáskor
                                //spedgauge.value = velo_scale * robot.speed;
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
                            value: 0
                            //value: velo_scale * robot.servo
                            scale: 1
                        }
                    }
                }
            }
            //Üres terület
            GroupBox {
                title: qsTr("UI Tesztelése:")
                Layout.fillHeight: true
                anchors.right: groupBox1.right
                anchors.left: groupBox1.left
                ColumnLayout {
                    Text {
                        text: qsTr("UI tesztelése:")
                    }
                    Slider {
                        id: slider1
                        minimumValue: 0
                        maximumValue: 400
                        onValueChanged: {
                            speedgauge.value = value*velo_scale;//
                        }
                    }
                    Slider {
                        minimumValue: -30
                        maximumValue: 30
                        onValueChanged: {
                            directiongauge.value = value;//irany
                        }
                    }


                }
            }

        }
    }
}

