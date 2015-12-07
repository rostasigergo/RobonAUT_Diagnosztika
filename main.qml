import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2


ApplicationWindow {
    title: qsTr("RobonAUT Diagnosztika")
    visible: true
    height: 720
    width: 1280

    //C++ oldali kommunikáció
    //Signals

    Connections {
        target: h
        onHistoryListChanged: mainFormControl.log({ message: (h.historyList.length - 1) + ": Státusz: " + h.historyList[h.historyList.length - 1].statusName + ";   Sebesség: " + h.historyList[h.historyList.length - 1].speed.toFixed(2) + ";   Irány: " + h.historyList[h.historyList.length - 1].servo.toFixed(2) +";   Akkumulátor feszültség: " +h.historyList[h.historyList.length - 1].battery.toFixed(2) + " [V];", colorCode: "yellow",logIndex: (h.historyList.length - 1) });
        }

    property int lastindex: (mainFormControl.onlineadatok.checked ? h.historyList.length - 1 : 0)//if(mainFormControl.onlineadatok.checked) h.historyList.length - 1

    function logfromCpp(msg){
        mainFormControl.log({message: msg, colorCode: "red",logIndex: -1 })
    }

    menuBar: MenuBar {
        Menu {
            title: qsTr("Menü")
            MenuItem {
                text: qsTr("COM kiválasztása")
                enabled: true
                onTriggered: {
                    c.updateAvailablePorts();
                    comchoosenDialog.open();
                }
            }
            MenuItem {
                text: qsTr("Csatlakozás...")
                onTriggered: {
                    c.connect();
                }
                enabled: !c.isConnected;
            }
            MenuItem {
                text: qsTr("Kapcsolat ellenőrzése")
                onTriggered: {
                    rp.checkRobotOnline();
                }
                enabled: c.isConnected;
            }
            MenuItem {
                text: qsTr("Kapcsolat bontása")
                onTriggered: {
                    c.disconnect();
                }
                enabled: c.isConnected;
            }
            MenuItem {
                text: qsTr("Kilépés")
                onTriggered: {
                    Qt.quit();
                }
                enabled: true
            }
        }
        Menu {
            title: qsTr("Beállítások")
            MenuItem {
                text: qsTr("Kerék átmérő beállítása")
                enabled: true
                onTriggered: {
                    setwheeldiameterDialog.open();
                }
            }
            MenuItem {
                text: qsTr("Áttétel beállítása")
                enabled: true
                onTriggered: {
                    setgearingDialog.open();
                }
            }
        }

    }

    //Property
    property real velo_scale: 1
    property real kerekatmero: 10
    property real attetel: 1


    MainForm {
        id: mainFormControl
        function log(Message){
            eventLogModel.append(Message);
        }
    }
    //Dialógusok
    Dialog {
        id:setwheeldiameterDialog
        title: qsTr("Kerék átmérő beállítása")
        standardButtons: StandardButton.Ok | StandardButton.Cancel
        height: 75
        width: 250


        Column {
            anchors.fill: parent
            spacing: 10
            Text {
                text: qsTr("Kerekek átmérője: ")
                font.pixelSize: 16
            }
            Row{
                Rectangle{
                width: 50
                height: 20

                color: "white"
                    TextInput {
                        id: wheeldiameterinput
                        text: kerekatmero.toString()
                        anchors.fill: parent
                        color: "#151515"
                        font.bold: true
                        font.pixelSize: 16
                        //finished
                    }
                }
                Text {
                    text: qsTr("[cm]")
                    font.pixelSize: 16
                    font.bold: true
                }
            }

        }
        onButtonClicked: {
            if (clickedButton == StandardButton.Ok){
                kerekatmero = wheeldiameterinput.text
                mainFormControl.log({ message: "Kerék átmérő állítva " + kerekatmero + " cm-re!", colorCode: "red", logIndex: -1 });
                //velo_scale nem frissül!!!!
            }
            else{
                //
            }

        }
    }
    Dialog {

        id:setgearingDialog
        title: qsTr("Áttétel beállítása")
        standardButtons: StandardButton.Ok | StandardButton.Cancel
        height: 75
        width: 250

        Column {
            anchors.fill: parent
            spacing: 10
            Text {
                text: qsTr("Áttétel: ")
                font.pixelSize: 16
            }
            Row{
                Rectangle{
                width: 50
                height: 20
                color: "white"
                    TextInput {
                        id: attetelinput
                        text: attetel.toString()
                        anchors.fill: parent
                        color: "#151515"
                        font.bold: true
                        font.pixelSize: 16
                        //finished
                    }
                }
                Text {
                    text: qsTr("[]")
                    font.pixelSize: 16
                    font.bold: true
                }
            }

        }
        onButtonClicked: {
            if (clickedButton == StandardButton.Ok){
                attetel = attetelinput.text
                mainFormControl.log({ message: "Áttétel állítva, új értéke: " + kerekatmero, colorCode: "red", logIndex: -1 });
                //velo_scale nem frissül!!!!
            }
            else{
                //
            }

        }
    }
    property int selectedCOM: 0
    Dialog {
        id: comchoosenDialog
        title: qsTr("COM kiválasztása")
        standardButtons: StandardButton.Ok | StandardButton.Cancel
        height: 95
        width: 135
        Column {
            anchors.fill: parent
            spacing: 10
            /*Text {
                text: qsTr("COM: ")
                font.pixelSize: 16
            }*/
            ComboBox {
                anchors.left: parent.left
                anchors.right: parent.right

                model: c.availablePorts

                onCurrentIndexChanged: {
                    selectedCOM = currentIndex;
                    //console.log("this");
                }
            }

        }
        onButtonClicked: {
            if (clickedButton == StandardButton.Ok){
                c.setPortName(c.availablePorts[selectedCOM]);
                mainFormControl.log({ message: "Soros port átállítva " + c.availablePorts[selectedCOM] + " -ra", colorCode: "red", logIndex: -1 });
                //console.log("that");
            }
        }
    }
}

