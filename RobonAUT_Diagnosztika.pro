TEMPLATE = app

QT += qml quick
CONFIG += c++11

SOURCES += main.cpp \
    StvApplication.cpp \
    MainWindowsEventHandling.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

FORMS += \
    UIElements/LineSensor.ui \

DISTFILES += \
    MainForm.ui.qml

HEADERS += \
    StvApplication.h \
    MainWindowsEventHandling.h

