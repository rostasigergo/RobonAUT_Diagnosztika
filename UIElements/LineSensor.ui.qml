import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import QtQuick.Extras 1.4

GroupBox {
    height: 100
    width: 330
    property int rectwidth: 10
    property int rectheight: 7
    //Grid??
    //GridLayout
    ColumnLayout {
       /* RowLayout {
            Repeater{
                model: 32
                Gauge {
                    minimumValue: 0
                    value: 50
                    maximumValue: 100
                }
            }
        }*/

        RowLayout {
            Layout.fillWidth: true
            Repeater {
                model: 32
                Rectangle {
                    // id: sensor1
                    width: rectwidth
                    height: rectheight
                    color: "blue"
                    border.color: "black"
                    border.width: 1
                }
            }
        }

        /*RowLayout {
            Repeater{
                model: 32
                ProgressBar {
                    width: rectwidth - 5
                    height: progreheight
                    value: 20
                    maximumValue: 100
                    orientation: 2
                }
            }
        }*/

        RowLayout {
            Layout.fillWidth: true
            Repeater {
            model: 32
            Rectangle {
                //id: sensor1
                width: rectwidth
                height: rectheight
                color: "blue"
                border.color: "black"
                border.width: 1
            }
        }
        }
    }
}

