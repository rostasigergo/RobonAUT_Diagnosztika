#ifndef ROBOTPROXY_H
#define ROBOTPROXY_H

#include <QObject>
#include <QTimer>
#include "communication.h"
#include "RobotState.h"

class RobotProxy : public QObject
{
    Q_OBJECT
public:
    enum Mode {
        Auto = 1,
        Manual = 2
    };

    enum Command {
        Left,
        Right,
        Accelerate,
        Brake
    };

    explicit RobotProxy(RobotState& state, Communication& communication, QObject *parent = 0);

    Q_ENUM(Mode)
    Q_ENUM(Command)

    Q_PROPERTY(bool isOnline READ isOnline WRITE setIsOnline NOTIFY isOnlineChanged)
    bool isOnline() const { return _isOnline; }


signals:
    void isOnlineChanged();

public slots:
    void refreshState();
    //void sendCommand(enum Command cmd);
    //void setMode(enum Mode mode);
    void processMsgFromRobot(QDataStream& msg);
    void checkRobotOnline();
    void commTimeout();
    void CommDisconnect();

private:

    RobotState& _state;
    Communication& _communication;
    bool _isOnline;
    QTimer _timeoutTimer;

    enum MsgType {
        STATUS,
        HELLO_ACK,
        COMMAND_ACK
    };

    void setIsOnline(bool isOnline) { _isOnline = isOnline; emit isOnlineChanged(); }
};

#endif // ROBOTPROXY_H
