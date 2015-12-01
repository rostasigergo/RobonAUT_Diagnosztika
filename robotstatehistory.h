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

    static RobotState* historyListAt(QQmlListProperty<RobotState> *historyList, int pos);
    static int historyListCount(QQmlListProperty<RobotState> *historyList);

    RobotState* at(int pos);

signals:
    void historyListChanged();

public slots:
private:
    std::vector<std::unique_ptr<RobotState>> _history;
};

#endif // ROBOTSTATEHISTORY_H
