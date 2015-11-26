#include <QGuiApplication>
#include <QQmlApplicationEngine>
//#include <QDebug>
//#include <QQmlContext>
//#include <stvapplication.h>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    //StvApplication app(argc, argv);


    return app.exec();
}

