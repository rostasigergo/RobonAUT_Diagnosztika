#include "robotstatehistory.h"

RobotStateHistory::RobotStateHistory(QObject *parent) : QObject(parent)
{
    /*int i;
    std::unique_ptr<RobotState> p;

    for(i = 0; i < 10; i++)
    {
        p = std::make_unique<RobotState>(RobotState::Status::Auto_crashed, i, i, i, i, i, QList<int>(), QList<int>());
        _history.append(p);
    }*/
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
