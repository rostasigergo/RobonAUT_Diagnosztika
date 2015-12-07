#ifndef ROBOTSTATEHISTORY_H
#define ROBOTSTATEHISTORY_H

#include <QObject>
#include <QList>
#include <QQmlListProperty>
#include <memory>
#include <vector>
#include "RobotState.h"

class RobotStateHistory : public QObject
{
    Q_OBJECT
public:
    explicit RobotStateHistory(QObject *parent = 0);
    Q_PROPERTY(QQmlListProperty<RobotState> historyList READ historyList NOTIFY historyListChanged)
    QQmlListProperty<RobotState> historyList();

    /**
      * @brief Megadja melyik tömbelemen állunk éppen a historyList-ben
    */
    static RobotState* historyListAt(QQmlListProperty<RobotState> *historyList, int pos);
    /**
      * @brief Visszaadja hány letárolt elem van a historyList ben
    */
    static int historyListCount(QQmlListProperty<RobotState> *historyList);

    RobotState* at(int pos);

    /**
      * @brief Egy új robaot state-t helyez a historyba és jelez a historyListChanged() signalon kereszül hogy változás történt
    */
    void add(std::unique_ptr<RobotState> &state);

signals:
    void historyListChanged();

public slots:
private:
    std::vector<std::unique_ptr<RobotState>> _history;
};

#endif // ROBOTSTATEHISTORY_H
