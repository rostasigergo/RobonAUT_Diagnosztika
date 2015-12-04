#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtQml>
#include <QTimer>
#include "RobotState.h"
#include "robotstatehistory.h"
#include "robotproxy.h"
#include "communication.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    RobotStateHistory h;
    Communication c;
    RobotProxy rp(h, c);

    qmlRegisterType<RobotState>("com.RobotState", 1, 0, "RobotState");
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("rp", &rp);
    engine.rootContext()->setContextProperty("c", &c);
    engine.rootContext()->setContextProperty("h", &h);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    QTimer::singleShot(3000, h.at(0), SLOT(incrementSpeed()));

    return app.exec();
}

