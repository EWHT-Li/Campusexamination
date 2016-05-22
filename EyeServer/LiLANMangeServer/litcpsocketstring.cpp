#include "litcpsocketstring.h"

LiTcpSocketString::LiTcpSocketString(QObject *parent):QTcpSocket(parent)
{
    goalIPV4="";
    connect(this,SIGNAL(connected()),this,SLOT(onConnected()));
    connect(this,SIGNAL(readyRead()),this,SLOT(onNews()));
    connect(this,SIGNAL(disconnected()),this,SLOT(onDisConnect()));
}

LiTcpSocketString::LiTcpSocketString(QHash<qintptr, QString> *rootNewsList, QObject *parent):QTcpSocket(parent)
{
    newsList=rootNewsList;

    connect(this,SIGNAL(connected()),this,SLOT(onConnected()));
    connect(this,SIGNAL(readyRead()),this,SLOT(onNews()));
}

LiTcpSocketString::LiTcpSocketString(qintptr descriptor,QHash<qintptr,QString> *rootNewsList,QObject *parent):QTcpSocket(parent)
{
    setSocketDescriptor(descriptor);
    newsList=rootNewsList;

    connect(this,SIGNAL(connected()),this,SLOT(onConnected()));
    connect(this,SIGNAL(readyRead()),this,SLOT(onNews()));
}

void LiTcpSocketString::onConnected()
{
    emit connectSucceed(this);
}

void LiTcpSocketString::setGoalIPV4(QString str)
{
    goalIPV4=str;
}

void LiTcpSocketString::onNews()
{
    while (bytesAvailable()>0)
    {
        QByteArray dataGram;
        dataGram.resize(bytesAvailable());
        read(dataGram.data(),dataGram.size());
        tempStr=dataGram.data();       
        handleNews(tempStr);
    }
    emit receiveNews(socketDescriptor());
}
//"RegistTcp|ID=="+QString::number(tcpsocket->socketDescriptor())+"|Name=="+myName+"|"//
void LiTcpSocketString::handleNews(QString str)
{
    qDebug()<<"多余的东东"<<str;
    if(str.startsWith("RegistTcp|"))
    {
        handleRegistNews(str);
    }
    else {
        newsList->insert(socketDescriptor(),str);
    }
}

QString LiTcpSocketString::returnGoalName()
{
    return goalName;
}

void LiTcpSocketString::handleRegistNews(QString str)
{
    qDebug()<<"收到注册信息"+str;
    QStringList tempList=str.split("|");
    QString temp;
    temp=tempList.at(1);
    goalDescriptor=temp.section("==",1,1).toInt();
    temp=tempList.at(2);
    goalName=temp.section("==",1,1);
    emit meKnowYourName(goalName);
}

QString LiTcpSocketString::returnGoalIPV4()
{
    return goalIPV4;
}

void LiTcpSocketString::onDisConnect()
{
    qDebug()<<"真的断开了？";
    emit disconnectDescriptor(socketDescriptor());
}
