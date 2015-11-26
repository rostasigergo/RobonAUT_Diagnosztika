#pragma once
#ifndef MAINWINDOWSEVENTHANDLING
#define MAINWINDOWSEVENTHANDLING
#include <QObject>
#include <QDebug>


class MainWindowsEventHandling : public QObject
{
    Q_OBJECT

public slots:
    void connection();
    void disconnection();
    void startCommand();
    void stopCommand();

    void upArrowPressed();
    void downArrowPressed();
    void leftArrowPressed();
    void rightArrowPressed();
    void upArrowReleased();
    void downArrowReleased();
    void leftArrowReleased();
    void rightArrowReleased();
};


#endif // MAINWINDOWSEVENTHANDLING

