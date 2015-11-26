#include "StvApplication.h"

StvApplication::StvApplication(int argc, char *argv[])
    : QGuiApplication(argc,argv),engine()
{
    //
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    auto roobObjects = engine.rootObjects();
    if (roobObjects.size() == 0)
    {
        qDebug() << "HIBA: QML környezet nem jött létre";
        return;
    }
    QObject *rootObject = rootObjects[0];

    //

    //QObject::connect(roobObject,SIGNAL(---),&handler, SLOT(connection()));
    //QObject::connect
}
