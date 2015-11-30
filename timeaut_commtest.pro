TEMPLATE = app

QT += qml quick serialport
CONFIG += c++14

SOURCES += main.cpp \
    communication.cpp \
    RobotState.cpp \
    robotproxy.cpp \
    robotstatehistory.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    communication.h \
    RobotState.h \
    robotproxy.h \
    robotstatehistory.h

