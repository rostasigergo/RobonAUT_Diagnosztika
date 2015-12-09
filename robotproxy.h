#ifndef ROBOTPROXY_H
#define ROBOTPROXY_H

#include <QObject>
#include <QTimer>
#include <memory>
#include "communication.h"
#include "robotstatehistory.h"

/**
  * @brief A robotproxy osztály végzi a C++ oldal vezérlését, itt példányosodik a Communication és a RobotStateHistory is
*/

class RobotProxy : public QObject
{
    Q_OBJECT
public:
    enum Mode {
        /**
          * @param Autonóm mód, a robot magától közlekedik
        */
        Auto = 1,
        /**
          * @brief Kézi irányítás, a robot a felhasználói felületektől kapott parancsok alapján mozog
        */
        Manual = 2
    };
    /**
      * @brief A robot által értelmezett kézi parancsok
    */
    enum Command {
        /**
          * @brief balra fordítja a robot kormányát (servo PWM++)
        */
        Left,
        /**
          * @brief jobbra fordítja a robot kormányát (servo PWM--)
        */
        Right,
        /**
          * @brief megnöveli a motor sebességét (motor PWM++)
        */
        Accelerate,
        /**
          * @brief csökkenti a motor sebességét (motor PWM--)
        */
        Brake
    };

    explicit RobotProxy(RobotStateHistory& history, Communication& communication, QObject *parent = 0);

    Q_ENUM(Mode)
    Q_ENUM(Command)

    Q_PROPERTY(bool isOnline READ isOnline WRITE setIsOnline NOTIFY isOnlineChanged)
    bool isOnline() const { return _isOnline; }

    Q_PROPERTY(RobotStateHistory* history READ history NOTIFY historyChanged)
    /**
      * @brief viszaadja a history-t
    */
    RobotStateHistory* history() { return &_history; }


signals:
    /**
      * @brief változott a kapcsolat állapota a robottal
    */
    void isOnlineChanged();
    /**
      * @brief a historyba új elem került
    */
    void historyChanged();

public slots:
    void refreshState();
    /**
      * @brief Egy új adatigénylést (DATAREQ) intéz a robot felé ami erre válaszolva visszaküldi az adatait
    */
    void sendCommand(enum Command cmd);
    /**
      * @brief Autonóm és Manuális mód közötti váltás
    */
    void setMode(enum Mode mode);
    /**
      * @brief A robottól érező adatot dolgozza föl ha HELLO akkor jelzi hogy él a kapcsolat, ha STATUS akkor elmenti a historyba ás jelez hogy új status érzkezett
    */
    void processMsgFromRobot(QDataStream& msg);
    /**
      * @brief A robot felé küld egy HELLO üzenetet amire az ACK al válaszol ha ott van a vonal msik végén
    */
    void checkRobotOnline();

    void commTimeout();
    void CommDisconnect();

private:
    /**
      * @brief a history osztáyl példánya
    */
    RobotStateHistory& _history;
    /**
      * @brief Autonóm és Manuális mód közötti váltás
    */
    Communication& _communication;
    /**
      * @brief Autonóm és Manuális mód közötti váltás
    */
    bool _isOnline;
    /**
      * @brief Autonóm és Manuális mód közötti váltás
    */
    QTimer _timeoutTimer;

    enum MsgType {
        STATUS,
        HELLO_ACK,
        COMMAND_ACK
    };

    void setIsOnline(bool isOnline) { _isOnline = isOnline; emit isOnlineChanged(); }
};

#endif // ROBOTPROXY_H
