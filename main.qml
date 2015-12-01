import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Layouts 1.2
import QtQuick.Controls 1.4
import com.RobotState 1.0

Window {
    visible: true
    width: 300;
    height: 300;

    ColumnLayout {
        id: mainlayout

        Button {
            text: "Soros port megnyitása"
            onClicked: c.connect();
            enabled: !c.isConnected;
        }

        Button {
            text: "Csatlakozás ellenőrzése";
            onClicked: rp.checkRobotOnline();
            enabled: c.isConnected;
        }

        Button {
            text: "Adatok frissítése";
            onClicked: rp.refreshState();
            enabled: rp.isOnline;
        }

        Text {
            text: "Státusz: " + robot.statusName;
        }
        Text {
            text: "Sebesség: " + robot.speed;
        }
        Text {
            text: "Szervó: " + robot.servo;
        }
        Text {
            text: "Akku: " + robot.battery;
        }
        Text {
            text: "Kapcsolódva: " + (rp.isOnline ? "igen" : "nem");
        }
        Text {
            text: "History sebesség: " + h.historyList[0].speed;
        }
        Text {
            text: "History lista hossz: " + h.historyList.length;
        }

        anchors.fill: parent
    }
}

