#include "litcpsocketfileclient.h"
//savePath要设置
LiTcpSocketFileClient::LiTcpSocketFileClient(QObject *parent):QTcpSocket(parent)
{
    savePath="/storage/sdcard0/data";
    connect(this,SIGNAL(readyRead()),this,SLOT(onHandleData()));
    connect(this,SIGNAL(connected()),this,SLOT(onConnected()));
//    connect(this,SIGNAL(disconnected()),this,SLOT(onDisconnect()));
}

//return QString("File|Port=="+QString::number(serverPort())+"|FileName=="+willSendFileInfo.fileName()+"|Size=="+QString::number(tempSendFile.size()));
void LiTcpSocketFileClient::receiveFileAggrement_One(QString &fileOrder,QString goalIPV4)
{
    qDebug()<<"asd2";
    if(fileOrder.startsWith(QLatin1String("File|")))
    {
        qDebug()<<"asd3";
        QStringList tempStrList=fileOrder.split("|");
        QString someOrder;
        someOrder=tempStrList.at(1);
        goalPort=someOrder.section("==",1,1).toUShort();
        someOrder=tempStrList.at(2);
        receiveFile=new QFile(savePath+"/"+someOrder.section("==",1,1),this);
        receiveFile->open(QIODevice::ReadWrite|QIODevice::Truncate);
        someOrder=tempStrList.at(3);
        fileSize=someOrder.section("==",1,1).toLongLong();
        connectToHost(goalIPV4,goalPort);
        qDebug()<<"asd4"<<goalIPV4<<goalPort;
    }
}

void LiTcpSocketFileClient::onHandleData()
{
    qDebug()<<"有东西";
    QByteArray datapack;
    datapack=readAll();
    receiveFile->write(datapack);
    qDebug()<<"接收中"+QString::number(receiveFile->size(), 10)<<"  "<<fileSize;
    if(receiveFile->size()==(fileSize))
    {
        receiveFile->close();
        qDebug()<<"接收完成";
        emit receiveFileOver(socketDescriptor());
//        return;
    }
}

void LiTcpSocketFileClient::onConnected()
{
    qDebug()<<"asd5"<<this<<"asd"<<(LiTcpSocketFileClient *)this;
    emit returnMe((LiTcpSocketFileClient *)this);
    qDebug()<<"asd6";
}






void LiTcpSocketFileClient::onDisconnect()
{
    qDebug()<<"有毛病";
}
