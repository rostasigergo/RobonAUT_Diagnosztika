#include "robotstatehistory.h"

RobotStateHistory::RobotStateHistory(QObject *parent) : QObject(parent)
{
    int i;
    std::unique_ptr<RobotState> p;
    QList<int> list;
    list.append(1);
    list.append(2);

    for(i = 0; i < 10; i++)
    {
        p = std::make_unique<RobotState>(RobotState::Status::Auto_crashed, i, i, i, i, i, list, list);
        _history.push_back(std::move(p));
    }
}

QQmlListProperty<RobotState> RobotStateHistory::historyList()
{
    return QQmlListProperty<RobotState>(this, 0, historyListCount, historyListAt);
}

RobotState* RobotStateHistory::historyListAt(QQmlListProperty<RobotState> *historyList, int pos)
{
    RobotStateHistory *history = qobject_cast<RobotStateHistory *>(historyList->object);

    return history->_history.at(pos).get();
}


int RobotStateHistory::historyListCount(QQmlListProperty<RobotState> *historyList)
{
    RobotStateHistory *history = qobject_cast<RobotStateHistory *>(historyList->object);

    return history->_history.size();
}

RobotState* RobotStateHistory::at(int pos)
{
    return _history.at(pos).get();
}
