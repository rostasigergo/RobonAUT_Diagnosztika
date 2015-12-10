#ifndef ROBOTSTATEHISTORY_H
#define ROBOTSTATEHISTORY_H

#include <QObject>
#include <QList>
#include <QQmlListProperty>
#include <memory>
#include <vector>
#include "RobotState.h"

/**
 * @brief A RobotStateHistory tárolóósztály, a feladata a RobotState-k tárolása, az add metóduson keresztül tudunk hozzádni új elemet,
 * ekkor meghívódik a historyListChanged() amire megváltozik a HMI-n kijelezett érték.
 */


class RobotStateHistory : public QObject
{
    Q_OBJECT
public:
    explicit RobotStateHistory(QObject *parent = 0);
    Q_PROPERTY(QQmlListProperty<RobotState> historyList READ historyList NOTIFY historyListChanged)
    /**
     * @brief a tároló tömb
     */
    QQmlListProperty<RobotState> historyList();

    /**
     * @brief historyListAt az utolsó elem a listában
     * @param historyList
     * @param pos
     * @return
     */
    static RobotState* historyListAt(QQmlListProperty<RobotState> *historyList, int pos);
    /**
     * @brief historyListCount a lista hossza
     * @param historyList
     * @return
     */
    static int historyListCount(QQmlListProperty<RobotState> *historyList);

    RobotState* at(int pos);
    void add(std::unique_ptr<RobotState> &state);

signals:
    void historyListChanged();

public slots:
private:
    std::vector<std::unique_ptr<RobotState>> _history;
};

#endif // ROBOTSTATEHISTORY_H
