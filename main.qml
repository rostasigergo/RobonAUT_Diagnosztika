import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2

import "UIElements"
//TODO: Button ColorAnimation
//TODO: Adatok megjelenítése
//TODO: Diagram, mit? választható?
//Ötlet: kiválsztható típusok log-ban


ApplicationWindow {
    title: qsTr("RobonAUT Diagnosztika")
    visible: true
    height: 720
    width: 1280

    //C++ oldali kommunikáció
    //Signals
    signal upArrow
    signal downArrow
    signal leftArrow
    signal rightArrow


    menuBar: MenuBar {
        Menu {
            title: qsTr("Menü")
            MenuItem {
                text: qsTr("COM kiválasztása")
                enabled: true
                onTriggered: {
                    comchoosenDialog.open();
                }
            }
            MenuItem {
                text: qsTr("Csatlakozás...")
                onTriggered: {
                    //Csatlakozás
                }
                enabled: true
            }
            MenuItem {
                text: qsTr("Kapcsolat bontása")
                onTriggered: {
                    //SzétCsatlakozás
                }
                enabled: false
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
                //velo_scale nem frissül!!!!
            }
            else{
                //
            }

        }
    }
    Dialog {
        id: comchoosenDialog
        title: qsTr("COM kiválasztása")
        standardButtons: StandardButton.Ok | StandardButton.Cancel
        height: 75
        width: 250
        //
    }
}

