#pragma once
#ifndef ROBOTSTATE_H
#define ROBOTSTATE_H
#include <QDataStream>
#include <QString>

class RobotState : public QObject
{
    Q_OBJECT

public:

    enum class Status
    {
        Manual = 0,
        Auto_ready = 1,
        Auto_line_ok = 2,
        Auto_line_lost = 3,
        Auto_crashed = 4
    };

    /**
     * @brief Konstruktor
     */
    RobotState();

    /**
     * @brief Konstruktor adott értékekkel.
     * @param status    Robot állapot
     * @param timestamp Időbélyeg
     * @param x Pozíció
     * @param v Sebesség
     * @param a Gyorsulás
     * @param light Robot lámpájának állapota
     */
    RobotState(Status status, qint64 systick,
        float x, float v, float a, qint8 light);

    ~RobotState() = default;

    // A NOTIFY signalokat nem implementáljuk, mert nincs rájuk szükség.

    /** Állapot (vagy parancs) */
    Q_PROPERTY(Status status READ status WRITE setStatus MEMBER _status NOTIFY statusChanged)
    Status status() const { return _status; }
    void setStatus(const Status status) { _status = status; }

    /** Időbélyeg (ms) */
    Q_PROPERTY(float systick READ systick WRITE setSystick MEMBER _systick NOTIFY systickChanged)
    quint32 systick() const { return _systick; }
    void setSystick(const quint32 systick) { _systick = systick; }

    Q_PROPERTY(float throttle READ throttle WRITE setThrottle MEMBER _throttle NOTIFY throttleChanged)
    float throttle() const { return _throttle; }
    void setThrottle(float throttle) { _throttle = throttle; }

    /** Sebesség (m/s) */
    Q_PROPERTY(float speed READ speed WRITE setSpeed MEMBER _speed NOTIFY speedChanged)
    float speed() const { return _speed; }
    void setSpeed(float speed) { _speed = speed; }

    Q_PROPERTY(float servo READ servo WRITE setServo NOTIFY servoChanged)
    float servo() const { return _servo; }
    void setServo(float servo) { _servo = servo; }

    Q_PROPERTY(QList<int> front_line READ front_line WRITE setFront_line MEMBER _front_line NOTIFY front_lineChanged)
    QList<int> front_line() const { return _front_line; }
    void setFront_line(QList<int> front_line) { _front_line = front_line; }

    Q_PROPERTY(QList<int> back_line READ back_line WRITE setback_line MEMBER _back_line NOTIFY back_lineChanged)
    QList<int> back_line() const { return _back_line; }
    void setBack_line(QList<int> back_line) { _back_line = back_line; }

    /** Az aktuális állapot QStringként. */
    // In QML, it will be accessible as model.statusName
    Q_PROPERTY(QString statusName READ getStatusName NOTIFY statusChanged)

    /** Sorosítja az objektumot a megadott streambe. */
    void WriteTo(QDataStream& stream) const;

    /** Beolvassa az objektumot a streamből. */
    void ReadFrom(QDataStream& stream);

    /** Másolat készítés. */
    // Erre azért van szükség, mert a QObject-ek másolására speciális szabályok vonatkoznak.
    void CopyFrom(const RobotState& other);

    /** Olvaható formában visszaadja az állapotot. */
    QString getStatusName() const;

signals:
    // Ezeket a signalokat most nem használjuk */
    void statusChanged();
    void systickChanged();
    void throttleChanged();
    void speedChanged();
    void front_lineChanged();
    void servoChanged();

private:

    Status _status;
    float _systick;
    float _speed;
    float _servo;
    float _throttle;
    QList<int> _front_line;
    QList<int> _back_line;


    /** Az állapotok és szöveges verziójuk közti megfeleltetés.
     * A getStatusName() használja. */
    static std::map<int,QString> statusNames;

    /** Beállítja a statusNames értékeit. A konstruktor hívja. */
    void initStatusNames();
};

/** Beburkolja a RobotState.WriteTo metódust. */
QDataStream &operator<<(QDataStream &, const RobotState &);

/** Beburkolja a RobotState.ReadFrom metódust. */
QDataStream &operator>>(QDataStream &, RobotState &);

#endif // ROBOTSTATE_H
