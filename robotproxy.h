#ifndef ROBOTPROXY_H
#define ROBOTPROXY_H

#include <QObject>
#include <QTimer>
#include <memory>
#include "communication.h"
#include "robotstatehistory.h"

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

    explicit RobotProxy(RobotStateHistory& history, Communication& communication, QObject *parent = 0);

    Q_ENUM(Mode)
    Q_ENUM(Command)

    Q_PROPERTY(bool isOnline READ isOnline WRITE setIsOnline NOTIFY isOnlineChanged)

    /**
     * @brief isOnline ha a robot a megfelelő (ACK) üzenettel reagál a (HELLO) parancsra a robot online van.
     */
    bool isOnline() const { return _isOnline; }

    Q_PROPERTY(RobotStateHistory* history READ history NOTIFY historyChanged)
    RobotStateHistory* history() { return &_history; }


signals:

    void isOnlineChanged();
    void historyChanged();

public slots:
    void refreshState();
    //void sendCommand(enum Command cmd);
    //void setMode(enum Mode mode);
    void processMsgFromRobot(QDataStream& msg);
    void checkRobotOnline();
    void commTimeout();
    void CommDisconnect();

private:

    RobotStateHistory& _history;
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
