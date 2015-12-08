#ifndef COMMUNICATION_H
#define COMMUNICATION_H

#include <QObject>
#include <QtSerialPort/QSerialPort>
#include <QSerialPortInfo>
#include <QBuffer>
#include <QDataStream>
#include <memory>
/**
 * @brief Kommunikációs osztály, a soros kommunikációt valósítja meg a COM soros porton kereszül.
 * A robotproxy osztály küldi el neki karaktertömb formájában a parancsokat melyeket a robotnak közvetít majd veszi sz onnan érkező
 * adatcsomagot és visszaadja a stream objektumot feldolgozásra az msgReady signal segítségével.
*/

class Communication : public QObject
{
    Q_OBJECT

public:
    explicit Communication(QObject *parent = 0);
    /**
      * @brief SEND metódus, bemenete egy karaktersorozat ami a parancsot tartalmazza
    */
    void send(const char* msg);

    Q_PROPERTY(bool isConnected READ isConnected WRITE setIsConnected NOTIFY isConnectedChanged)

    bool isConnected() const { return _isConnected; }
    /**
      * @brief Az elérhető soros portok listája
    */
    Q_PROPERTY(QStringList availablePorts READ availablePorts NOTIFY availablePortsChanged)
    QStringList availablePorts() { return _availablePorts; }


signals:
    /**
     * @brief Megérkezett az egész üzenet jelzést küld a feldolgozáshoz
     */
    void msgReady(QDataStream& msg);
    /**
     * @brief A kapcsolat megszűnt a soros porttal
     */
    void disconnected();
    /**
     * @brief A kapcsolat létrejött a soros porttal
     */
    void connected();
    /**
      * @brief A kapcsolódás státusza változott (connect vagy disconnect történt)
    */
    void isConnectedChanged();
    /**
      * @brief Megváltozott az elérhető portok listája
    */
    void availablePortsChanged();

public slots:
    /**
     * @brief A beérkezett adatok feldolgozása, ha az egész üzenet megérkezett
     *  (aminek a hosszát az első bájt tartalmazza) meghívja az msgReady signalt
     */
    void processData();
    /**
     * @brief disconnect: csatlakozik a kiválasztott COM porthoz, ha az nyitva van,
     *  illetve beálltja a bájtsorrendet, (mivel az eszköz BigEndianban küld)
     */
    void connect();
    /**
     * @brief disconnect: bezárja a jeleleg nyitva lévő soros portot
     */
    void disconnect();
    /**
      * @brief kiadja a disconnected() signalt
    */
    void processClose();
    /**
      * @brief port nevének beállítása
    */
    void setPortName(QString portName);
    /**
      * @brief port beállítása már létező port alapján
    */
    void setPort(QSerialPortInfo& port);
    /**
      * @brief törli az elérhető portok listáját majd újra föltölti az elérhető portokkal
    */
    void updateAvailablePorts();

private:

    /**
      * @brief Serial port handler
    */
    QSerialPort _ser;
    /**
      * @brief Küldő stream unique pointer (törléskor megszűnik a steream)
    */
    std::unique_ptr<QDataStream> _send_stream;
    /**
      * @brief Fogadó stream unique pointer (törléskor megszűnik a steream)
    */
    std::unique_ptr<QDataStream> _recv_stream;
    /**
      * @brief A beérkezett üzenet hossza
    */
    quint32 _msg_len;
    /**
      * @brief Bool változó mai megmondja kapcsolódva vagyunk-e a streamhoz
    */
    bool _isConnected;
    /**
      * @brief Elérhető portok listája
    */
    QStringList _availablePorts;

    void setIsConnected(bool isConnected) { _isConnected = isConnected; emit isConnectedChanged(); }
};

#endif // COMMUNICATION_H
