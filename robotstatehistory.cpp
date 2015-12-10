#include "robotstatehistory.h"

RobotStateHistory::RobotStateHistory(QObject *parent) : QObject(parent)
{

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

void RobotStateHistory::add(std::unique_ptr<RobotState> &state)
{
    this->_history.push_back(std::move(state));
    emit historyListChanged();
}
