#include "robotproxy.h"

RobotProxy::RobotProxy(RobotState& state, Communication& communication, QObject *parent)
    : QObject(parent), _state(state), _communication(communication)
{
    _isOnline = false;
    _timeoutTimer.setSingleShot(true);

    QObject::connect(&_timeoutTimer, SIGNAL(timeout()), this, SLOT(commTimeout()));
    QObject::connect(&_communication, SIGNAL(msgReady(QDataStream&)), this, SLOT(processMsgFromRobot(QDataStream&)));
    QObject::connect(&_communication, SIGNAL(disconnected()), this, SLOT(CommDisconnect()));
    QObject::connect(&_communication, SIGNAL(connected()), this, SLOT(checkRobotOnline()));
}

void RobotProxy::processMsgFromRobot(QDataStream& msg)
{
    quint32 tmp_quint32;
    enum MsgType type;

    _timeoutTimer.stop();
    msg >> tmp_quint32;
    type = (enum MsgType)tmp_quint32;

    if(type == STATUS)
    {
        msg >> _state;
    }

    if(type == HELLO_ACK)
    {
        this->setIsOnline(true);
        this->refreshState();
    }
}

void RobotProxy::refreshState()
{
    _communication.send("DATAREQ\r\n");
    _timeoutTimer.start(2000);
}

void RobotProxy::checkRobotOnline()
{
    _communication.send("HELLO\r\n");
    _timeoutTimer.start(2000);
}

void RobotProxy::commTimeout()
{
    _communication.disconnect();
}

void RobotProxy::CommDisconnect()
{
    this->setIsOnline(false);
}
