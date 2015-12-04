#include "communication.h"

Communication::Communication(QObject *parent) : QObject(parent)
{
    _msg_len = 0;
    _isConnected = false;

    _send_stream = std::make_unique<QDataStream>();
    _recv_stream = std::make_unique<QDataStream>();

    _ser.setPortName("COM12");
    _ser.setBaudRate(115200);

    QObject::connect(&_ser, SIGNAL(aboutToClose()), this, SLOT(processClose()));

}

void Communication::connect()
{
    _ser.open(QIODevice::ReadWrite);

    if(_ser.isOpen())
    {
        _send_stream = std::make_unique<QDataStream>(&_ser);
        _send_stream->setByteOrder(QDataStream::LittleEndian);

        _recv_stream = std::make_unique<QDataStream>(&_ser);
        _recv_stream->setByteOrder(QDataStream::LittleEndian);

        QObject::connect(&_ser, SIGNAL(readyRead()), this, SLOT(processData()));

        this->setIsConnected(true);
        emit connected();
    }
}

void Communication::disconnect()
{
    if(_ser.isOpen())
    {
            _ser.close();
    }
}

void Communication::processClose()
{
    _send_stream = std::make_unique<QDataStream>();
    _recv_stream = std::make_unique<QDataStream>();

    this->setIsConnected(false);
    emit disconnected();
}

void Communication::processData()
{
    QDataStream &stream = *_recv_stream;

    if(_msg_len == 0)
    {
        if(_ser.bytesAvailable() < sizeof(quint32))
            return;
        stream >> _msg_len;
    }

    if(_ser.bytesAvailable() < _msg_len)
        return;

    _msg_len = 0;
    emit msgReady(stream);
}


void Communication::send(const char* msg)
{
    QDataStream& stream = *_send_stream;

    stream.writeRawData(msg, strlen(msg));
}

void Communication::setPortName(QString& portName)
{
    this->disconnect();
    this->_ser.setPortName(portName);
}

void Communication::setPort(QSerialPortInfo &port)
{
    this->disconnect();
    this->_ser.setPort(port);
}

void Communication::updateAvailablePorts()
{
    QList<QString> &names = this->_availablePorts;

    names.clear();

    QList<QSerialPortInfo> ports = QSerialPortInfo::availablePorts();

    for(auto it = ports.begin(); it != ports.end(); it++)
    {
        names.append(it->portName());
    }

    emit availablePortsChanged();

}
