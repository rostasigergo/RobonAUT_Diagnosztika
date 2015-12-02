#include <QDebug>
#include "RobotState.h"

std::map<int,QString> RobotState::statusNames;

RobotState::RobotState()
{
    initStatusNames();
    _status = Status::Manual;
}

RobotState::RobotState(Status status, quint32 systick,
    float throttle, float speed, float servo, float battery,
    QList<int> front_line, QList<int> back_line)
    : _status(status), _systick(systick), _throttle(throttle),
      _speed(speed), _servo(servo), _battery(battery), _front_line(front_line), _back_line(back_line)
{
    initStatusNames();
}

void RobotState::initStatusNames()
{
    if (statusNames.empty())
    {
        // Még nincsen inicializálva.
        statusNames[(int)Status::Manual] = QString("Manuális");
        statusNames[(int)Status::Auto_ready] = QString("Autonóm - Indításra vár");
        statusNames[(int)Status::Auto_line_ok] = QString("Autonóm - Vonalkövetés OK");
        statusNames[(int)Status::Auto_line_lost] = QString("Autonóm - Nincs vonal");
        statusNames[(int)Status::Auto_crashed] = QString("Autonóm - Ütközés");
    }
}

QString RobotState::getStatusName() const
{
    auto it = statusNames.find((int)_status);
    Q_ASSERT(it != statusNames.end());
    return it->second;
}

void RobotState::ReadFrom(QDataStream& stream)
{
    quint32 tmp_quint32;
    qint32 tmp_qint32;
    QList<int> tmp_list;

    stream >> tmp_qint32;
    this->setThrottle(tmp_qint32);
    stream >> tmp_qint32;
    this->setSpeed(tmp_qint32);
    stream >> tmp_qint32;
    this->setServo(tmp_qint32);
    stream >> tmp_quint32;
    this->setBattery(tmp_quint32);
    stream >> tmp_quint32;
    this->setStatus((Status)tmp_quint32);
    stream >> tmp_quint32;
    this->setSystick(tmp_quint32);

    for(int i = 0; i < 24; i++)
    {
        stream >> tmp_quint32;
        tmp_list.append(tmp_quint32);
    }

    this->setFront_line(tmp_list);
    tmp_list.clear();

    for(int i = 0; i < 24; i++)
    {
        stream >> tmp_quint32;
        tmp_list.append(tmp_quint32);
    }

    this->setBack_line(tmp_list);

    return;
}

/*QDataStream &operator<<(QDataStream& stream, const RobotState& state)
{
    state.WriteTo(stream);
    return stream;
}*/

QDataStream &operator>>(QDataStream& stream, RobotState& state)
{
    state.ReadFrom(stream);
    return stream;
}

void RobotState::incrementSpeed()
{
    this->setSpeed(this->speed() + 1);
}
