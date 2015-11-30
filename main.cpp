#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTimer>
#include "RobotState.h"
#include "robotproxy.h"
#include "communication.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    RobotState robot;
    Communication c(QString("COM12"));
    RobotProxy rp(robot, c);

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("robot", &robot);
    engine.rootContext()->setContextProperty("rp", &rp);
    engine.rootContext()->setContextProperty("c", &c);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

