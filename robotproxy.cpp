#include "robotproxy.h"

RobotProxy::RobotProxy(RobotStateHistory &history, Communication& communication, QObject *parent)
    : QObject(parent), _history(history), _communication(communication)
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
        auto p = std::make_unique<RobotState>();
        msg >> *p;
        this->_history.add(p);
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

void RobotProxy::setMode(enum Mode mode)
{

    switch(mode)
    {
    case RobotProxy::Mode::Auto:
        _communication.send("MODE_AUTO\r\n");
        break;
    case RobotProxy::Mode::Manual:
        _communication.send("MODE_MANUAL\r\n");
    }

    this->refreshState();
}

void RobotProxy::sendCommand(enum Command cmd)
{
    switch(cmd)
    {
    case RobotProxy::Command::Left:
        _communication.send("CMD_LEFT\r\n");
        break;
    case RobotProxy::Command::Right:
        _communication.send("CMD_RIGHT\r\n");
        break;
    case RobotProxy::Command::Accelerate:
        _communication.send("CMD_ACCELERATE\r\n");
        break;
    case RobotProxy::Command::Brake:
        _communication.send("CMD_BRAKE\r\n");
        break;
    }

    this->refreshState();
}
