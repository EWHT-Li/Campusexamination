#ifndef LITCPSOCKETFILESERVER_H
#define LITCPSOCKETFILESERVER_H

#include <QTcpServer>
#include <QFile>
#include <QFileInfo>
#include <QTcpSocket>
#include <QByteArray>

class LiTcpSocketFileServer : public QTcpServer
{
    Q_OBJECT
public:
    LiTcpSocketFileServer(QObject *parent=0);
    QString sendFileAggrement_One(QString &fileName);
    void incomingConnection(qintptr handle);
    void setID(quint32 id);
    quint32 returnID();
signals:
    void sendFileOver(quint32 id);
public slots:
    void onBeginSendFile();

    void onDisconnect();
private:
    QFile *currentSendFile;
    QString filePath;
    QTcpSocket *sendDataTcpSocket;
    qint64 eachPacket;
    quint32 ID;
};

#endif // LITCPSOCKETFILESERVER_H
