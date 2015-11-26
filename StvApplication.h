#pragma once
#ifndef STVAPPLICATION
#define STVAPPLICATION
//#include <QApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <MainWindowsEventHandling.h>
//Robotproxy.h
//Communication
//RobotStateHistory

class StvApplication : public QGuiApplication
{
public:
    StvApplication(int argc, char *argv[]);
    ~StvApplication() = default;
private:
    QQmlApplicationEngine engine;
    //RobotStateHistory
    //Communication
    //Robotproxy
    //MainWindowsEventHandling handler;
};

#endif // STVAPPLICATION

