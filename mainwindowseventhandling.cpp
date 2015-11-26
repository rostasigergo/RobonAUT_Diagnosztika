#include "MainWindowsEventHandling.h"
//#include "RobotProxy.h"
#include <QQmlContext>
//#include "RobotStateHistory.h"

#include <QQuickItem>
#include <QQmlApplicationEngine>

MainWindowsEventHandling::MainWindowsEventHandling(
        QQmlContext& qmlContext)
    :qmlContext(qmlContext)
{
    //
}


void MainWindowsEventHandling::connect()
{
    qDebug() << "Csatlakozás gomb lenyomva";
}
void MainWindowsEventHandling::disconnect()
{
    qDebug() << "SzétCsatlakozás gomb lenyomva";
}
void MainWindowsEventHandling::startCommand()
{
    qDebug() << "Start gomb lenyomva";
}
void MainWindowsEventHandling::stopCommand()
{
    qDebug() << "Stop gomb lenyomva";
}
void MainWindowsEventHandling::upArrowPressed()
{
    qDebug() << "Fel gomb lenyomva";
}
void MainWindowsEventHandling::upArrowReleased()
{
    qDebug() << "Fel gomb elengedve";
}
void MainWindowsEventHandling::downArrowPressed()
{
    qDebug() << "Le gomb lenyomva";
}
void MainWindowsEventHandling::downArrowReleased()
{
    qDebug() << "Le gomb elengedve";
}
void MainWindowsEventHandling::leftArrowPressed()
{
    qDebug() << "Bal gomb lenyomva";
}
void MainWindowsEventHandling::leftArrowReleased()
{
    qDebug() << "Bal gomb elengedve";
}
void MainWindowsEventHandling::rightArrowPressed()
{
    qDebug() << "Jobb gomb lenyomva";
}
void MainWindowsEventHandling::rightArrowReleased()
{
    qDebug() << "Jobb gomb elengedve";
}
