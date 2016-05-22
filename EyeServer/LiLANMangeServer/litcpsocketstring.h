#ifndef LITCPSOCKETSTRING_H
#define LITCPSOCKETSTRING_H

#include <QTcpSocket>
#include <QHash>
#include <QString>
#include <QStringList>

class LiTcpSocketString : public QTcpSocket
{
    Q_OBJECT
public:
    LiTcpSocketString(QObject *parent=0);
    LiTcpSocketString(QHash<qintptr, QString> *rootNewsList, QObject *parent=0);
    LiTcpSocketString(qintptr descriptor,QHash<qintptr,QString> *rootNewsList,QObject *parent=0);

    Q_INVOKABLE void setGoalIPV4(QString str);
    Q_INVOKABLE QString returnGoalIPV4();
    Q_INVOKABLE void handleNews(QString str);
    Q_INVOKABLE QString returnGoalName();
signals:
    void connectSucceed(LiTcpSocketString *);
    void receiveNews(qintptr socketDescriptor);
    void disconnectDescriptor(qintptr socketDescriptor);
    void meKnowYourName(QString myName);

public slots:
    void onConnected();
    void onNews();
    void onDisConnect();

private:
    QHash<qintptr,QString> *newsList;
    QString goalIPV4;
    QString goalDescriptor;//对方我的描述符即我发信息的id
    QString goalName;
    QString tempStr;

    void handleRegistNews(QString str);
};

#endif // LITCPSOCKETSTRING_H
