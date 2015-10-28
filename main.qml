import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4

import "UIElements"


ApplicationWindow {
    title: qsTr("RobonAUT Diagnosztika")
    visible: true

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("Connect...")
                onTriggered: {
                    //Do something
                }
                enabled: true
            }
            MenuItem {
                text: qsTr("Disconnect")
                onTriggered: {
                    //Do something
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


    LineSensor {
        anchors.bottom: parent
        anchors.right: parent
    }



    /*MainForm {
        anchors.bottom: parent
        mouseArea.onClicked: {
            Qt.quit();
        }
    }*/

}

