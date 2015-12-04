#ifndef COMMUNICATION_H
#define COMMUNICATION_H

#include <QObject>
#include <QtSerialPort/QSerialPort>
#include <QSerialPortInfo>
#include <QBuffer>
#include <QDataStream>
#include <memory>

class Communication : public QObject
{
    Q_OBJECT

public:
    explicit Communication(QObject *parent = 0);
    void send(const char* msg);

    Q_PROPERTY(bool isConnected READ isConnected WRITE setIsConnected NOTIFY isConnectedChanged)
    bool isConnected() const { return _isConnected; }

    Q_PROPERTY(QList<QSerialPortInfo> availablePorts READ availablePorts)
    QList<QSerialPortInfo> availablePorts() { return QSerialPortInfo::availablePorts(); }

signals:
    void msgReady(QDataStream& msg);
    void disconnected();
    void connected();
    void isConnectedChanged();

public slots:
    void processData();
    void connect();
    void disconnect();
    void processClose();

    void setPortName(QString& portName);
    void setPort(QSerialPortInfo& port);

private:

    QSerialPort _ser;
    std::unique_ptr<QDataStream> _send_stream;
    std::unique_ptr<QDataStream> _recv_stream;
    quint32 _msg_len;
    bool _isConnected;

    void setIsConnected(bool isConnected) { _isConnected = isConnected; emit isConnectedChanged(); }
};

#endif // COMMUNICATION_H
