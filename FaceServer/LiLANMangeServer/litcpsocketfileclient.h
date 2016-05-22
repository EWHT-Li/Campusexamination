#ifndef LITCPSOCKETFILECLIENT_H
#define LITCPSOCKETFILECLIENT_H

#include <QTcpSocket>
#include <QFile>
#include <QDebug>
#include <QString>
#include <QHostAddress>

class LiTcpSocketFileClient:public QTcpSocket
{
    Q_OBJECT
public:
    LiTcpSocketFileClient(QObject *parent=0);
    Q_INVOKABLE void receiveFileAggrement_One(QString &fileOrder,QString goalIPV4);
signals:
    void receiveFileOver(qintptr socketDescriptor);
    void returnMe(LiTcpSocketFileClient *me);
public slots:
    void onHandleData();
    void onConnected();

    void onDisconnect();
private:
    QString savePath;
    QFile *receiveFile;
    qint64 fileSize;
    quint16 goalPort;
};

#endif // LITCPSOCKETFILECLIENT_H
