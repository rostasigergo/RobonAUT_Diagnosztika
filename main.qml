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
            text: "Státusz: " + rp.history.historyList[rp.history.historyList.length - 1].statusName;
        }
        Text {
            text: "Sebesség: " + rp.history.historyList[rp.history.historyList.length - 1].speed;
        }
        Text {
            text: "Szervó: " + rp.history.historyList[rp.history.historyList.length - 1].servo;
        }
        Text {
            text: "Akku: " + rp.history.historyList[rp.history.historyList.length - 1].battery;
        }
        Text {
            text: "Kapcsolódva: " + (rp.isOnline ? "igen" : "nem");
        }
        Text {
            text: "History lista hossz: " + rp.history.historyList.length;
        }

        anchors.fill: parent
    }
}

