import QtQuick 2.0
import QtQuick.Layouts 1.1

Item {
    RowLayout {
            Rectangle {
                id: sensor1
                width: 30
                height: 20
                border.color: black
                color: red
                visible: true
            }
            Rectangle {
                id: sensor2
                width: 30
                height: 20
            }
        }

        RowLayout {
            Rectangle {
                id: sensor33
                width: 30
                height: 20
            }
            Rectangle {
                id: sensor34
                width: 30
                height: 20
                visible: true
            }
        }
}

