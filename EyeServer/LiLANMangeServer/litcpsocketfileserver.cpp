#include "litcpsocketfileserver.h"

LiTcpSocketFileServer::LiTcpSocketFileServer(QObject *parent):QTcpServer(parent)
{
    while (!serverPort())
    {
        listen(QHostAddress::AnyIPv4);
    }
    eachPacket=262144;
    connect(this,SIGNAL(newConnection()),this,SLOT(onBeginSendFile()));


}

//发送协议指令一
QString LiTcpSocketFileServer::sendFileAggrement_One(QString &fileName)
{
    filePath=fileName;
    QFile tempSendFile(fileName);
    QFileInfo willSendFileInfo(tempSendFile);
    return QString("File|Port=="+QString::number(serverPort())+"|FileName=="+willSendFileInfo.fileName()+"|Size=="+QString::number(tempSendFile.size())+"|");
}

void LiTcpSocketFileServer::incomingConnection(qintptr handle)
{
    sendDataTcpSocket=new QTcpSocket(this);
    sendDataTcpSocket->setSocketDescriptor(handle);
    connect(sendDataTcpSocket,SIGNAL(disconnected()),this,SLOT(onDisconnect()));
}

void LiTcpSocketFileServer::onBeginSendFile()
{
    QFile file(filePath);
    if(!file.open(QIODevice::ReadOnly ))
    {
        qDebug()<<"打开失败";
        return;
    }
    QByteArray datapack;
    qint64 filesize=file.size();
    while (filesize>0)
    {
        datapack=file.read(qMin(eachPacket,filesize));
        filesize=filesize-sendDataTcpSocket->write(datapack);
        qDebug()<<"发送中";
    }

    qDebug()<<"发送完成";
}

void LiTcpSocketFileServer::setID(quint32 id)
{
    ID=id;
}

quint32 LiTcpSocketFileServer::returnID()
{
    return ID;
}

void LiTcpSocketFileServer::onDisconnect()
{
    emit sendFileOver(ID);
}
