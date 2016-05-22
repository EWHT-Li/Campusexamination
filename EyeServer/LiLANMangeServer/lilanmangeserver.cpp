#include "lilanmangeserver.h"
//#include "LiLANMangeServer/lilanmangeserver.h"

quint16 LiLANMangeServer::allPort=2000;
quint32 LiLANMangeServer::allFileServerID=0;//用时加上是否超上限判断

LiLANMangeServer::LiLANMangeServer(QObject *parent):QTcpServer(parent)
{
    rootUdpPort=3001;//3001;
    multicastAddress="236.0.0.26";
    goalPort=3000;//3000;988
    myName="DevelopmentServer";
    textCode=QTextCodec::codecForName("UTF-8");
    rootUdpAddress="192.168.78.101";
    
    
    autoListen();
    
    rootUdpSocket=new QUdpSocket(this);
    rootUdpSocket->bind(QHostAddress::AnyIPv4,rootUdpPort,QUdpSocket::ReuseAddressHint);
    rootUdpSocket->setSocketOption(QAbstractSocket::MulticastLoopbackOption,0);//防止自己接受
//    224.0.1.0～238.255.255.255为用户可用的组播地址（临时组地址），全网范围内有效。
//    239.0.0.0～239.255.255.255为本地管理组播地址，仅在特定的本地范围内有效。
    rootUdpSocket->joinMulticastGroup(QHostAddress(multicastAddress));//加入组播地址
    connect(rootUdpSocket,SIGNAL(readyRead()),this,SLOT(onRootUdpNews()));
   
    
    replayClientTimer=new QTimer(this);
    replayClientTimer->setSingleShot(false);
    connect(replayClientTimer,SIGNAL(timeout()),this,SLOT(iAmHere()));
    replayClientRange=new QTimer(this);
    replayClientRange->setSingleShot(true);
    connect(replayClientRange,SIGNAL(timeout()),this,SLOT(replayClientTimerStop()));
    
    
    tcpNewsList=new QHash<qintptr,QString>;
    tcpSocketRegistery=new QHash<qintptr,LiTcpSocketString*>;
    tcpSocketFileRegistery=new QHash<qintptr,LiTcpSocketFileClient*>;
    tcpSocketFileServerRegistery=new QHash<quint32,LiTcpSocketFileServer*>;
    udpaClientRegistery=new QHash<QHostAddress*,quint16*>;

    udpGoalPortList=new QList<quint16>;
    localIPV4Address=getLocalIPAddress();
//    connect(rootUdpSocket,SIGNAL(readyRead()),this,SLOT(tempNew()));

//    按摩端需求
    massagePort=6000;
    connectControl=true;//防止多次Tcp连接


    //face需求
    quint16 tempQuint16=3002;
    addBroadcastPort(tempQuint16);
}

//端口号增加
void LiLANMangeServer::addAllPort()
{
    if(allPort<65535)
    {
        allPort++;
    }
    else {
        allPort=2000;
    }
}
//TCP自动监听
bool LiLANMangeServer::autoListen()
{
    while(serverPort()==0)
    {
        listen(QHostAddress::AnyIPv4,allPort);
        addAllPort();
    }
    qDebug()<<"Server绑定端口号："<<serverPort();
//    emit debug("Server绑定端口号："+serverPort());
    return true;
}
//Udp信息预处理
void LiLANMangeServer::onRootUdpNews()
{
    while (rootUdpSocket->hasPendingDatagrams()) {
        QByteArray datagram;
        datagram.resize(rootUdpSocket->pendingDatagramSize());
        rootUdpSocket->readDatagram(datagram.data(), datagram.size(),&senderAddress, &senderPort);
        tempRootStr=datagram.data();
        if(!udpaClientRegistery->contains(&senderAddress))//电脑似乎只能对固定地址广播，无奈。
        {
            udpaClientRegistery->insert(&senderAddress,&senderPort);
        }
        handleRootUdpNews(tempRootStr,senderAddress);
        emit udpNews(tempRootStr);
        qDebug()<<"root接受"<<tempRootStr<<senderAddress<<senderPort;
    }
}
//添加广播对象
bool LiLANMangeServer::addBroadcastGoal(QString senderAddress, quint16 senderPort)
{
    bool contain=false;
    QHash<QHostAddress*,quint16*>::const_iterator index=udpaClientRegistery->constBegin();
    while(index!=udpaClientRegistery->constEnd())
    {
        if((index.key()->toString()==senderAddress)&&(*(index.value())==senderPort))
        {
            contain=true;
        }
        index++;
    }
    if(contain)
    {
        return false;
    }
    else
    {
        QHostAddress* tempHost=new QHostAddress(senderAddress);
        udpaClientRegistery->insert(tempHost,&senderPort);
        qDebug()<<"UdpAdd："<<senderAddress<<senderPort;
        return true;
    }
}

void LiLANMangeServer::addBroadcastPort(quint16 addPort)
{

    udpGoalPortList->append(addPort);
}

//处理udp信息
void LiLANMangeServer::handleRootUdpNews(QString str,QHostAddress sendAddress)
{
    if(str.startsWith("HelloServer"))
    {
        replayClientStart(1000,30000);
    }
    //按摩端的需求
//    else if(str.startsWith("+OK=1")&&connectControl)
//    {
//        qDebug()<<"主动连："<<sendAddress.toString()<<massagePort<<qmlShareDate.getMassageName();
//        connectToTcpString(sendAddress.toString(),massagePort,qmlShareDate.getMassageName());
//        connectControl=false;
//    }
}
//我在这
void LiLANMangeServer::iAmHere()
{
    broadcastMessage("HelloClient|Name=="+myName+"|Port=="+QString::number(serverPort())+"|");
    broadcastMessageAllAccurate("*"+localIPV4Address+"*"+QString::number(serverPort())+"*");
}
//广播信息
void LiLANMangeServer::broadcastMessage(QString str)
{
    QByteArray data=textCode->fromUnicode(str);
//    QHash<QHostAddress*,quint16*>::const_iterator index=udpaClientRegistery->constBegin();
//    while(index!=udpaClientRegistery->constEnd())
//    {
//        rootUdpSocket->writeDatagram(data,*(index.key()),*(index.value()));
//        qDebug()<<"UdpSend:"<<index.key()->toString();
//        index++;
//    }
//    qDebug()<<"这会崩？1"<<udpGoalPortList->size()<<"  "<<udpGoalPortList->count();
    for(int i=0;i<udpGoalPortList->size();++i)
    {
        rootUdpSocket->writeDatagram(data,QHostAddress::Broadcast,udpGoalPortList->at(i));
    }
    rootUdpSocket->writeDatagram(data,QHostAddress::Broadcast,goalPort);
    rootUdpSocket->writeDatagram(data,QHostAddress(multicastAddress),goalPort);
    qDebug()<<"发送"+str;
}
void LiLANMangeServer::broadcastMessageAllPort(QString str)
{
    QByteArray data=textCode->fromUnicode(str);
    for(int i=0;i<udpGoalPortList->size();++i)
    {
        rootUdpSocket->writeDatagram(data,QHostAddress::Broadcast,udpGoalPortList->at(i));
    }
}
void LiLANMangeServer::broadcastMessageAllAccurate(QString str)
{
    QByteArray data=textCode->fromUnicode(str);
    QHash<QHostAddress*,quint16*>::const_iterator index=udpaClientRegistery->constBegin();
    while(index!=udpaClientRegistery->constEnd())
    {
        rootUdpSocket->writeDatagram(data,*(index.key()),*(index.value()));
        index++;
    }
}

void LiLANMangeServer::replayClientTimerStop()
{
    replayClientTimer->stop();
}

void LiLANMangeServer::replayClientStart(int cycle, int range)
{
    replayClientRange->stop();
    replayClientTimer->stop();
    replayClientTimer->start(cycle);
    replayClientRange->start(range);
}



//实现incoming函数
void LiLANMangeServer::incomingConnection(qintptr handle)
{
    LiTcpSocketString *tempTcpSocketString=new LiTcpSocketString(handle,tcpNewsList,this);
    tcpSocketRegistery->insert(handle,tempTcpSocketString);
    connect(tempTcpSocketString,SIGNAL(disconnectDescriptor(qintptr)),this,SLOT(onDeleteTcpSocketString(qintptr)));
    connect(tempTcpSocketString,SIGNAL(receiveNews(qintptr)),this,SLOT(onTcpNews(qintptr)));
    registerTcpToGoal(tempTcpSocketString);
    emit updateTcpSocketRegistery();
}
//Tcp信息处理
void LiLANMangeServer::onTcpNews(qintptr tcpSocketDescript)
{
    QHash<qintptr,QString>::const_iterator index=tcpNewsList->constBegin();
    while (!tcpNewsList->empty())
    {
        index=tcpNewsList->constBegin();
        //处理函数 index。key（） value（）
        handleTcpNews(index.key(),index.value());
        emit debug(QString::number(index.key())+index.value());
//        qDebug()<<"tcp数据表"<<index.key()<<index.value();
        tcpNewsList->remove(index.key());
    }
}

void LiLANMangeServer::sendTcpNews(LiTcpSocketString *tcpsocket, QString str)
{
    QByteArray bytest = textCode->fromUnicode(str);
    tcpsocket->write(bytest);
}

void LiLANMangeServer::sendTcpNews(QString goalName, QString str)
{

    qDebug()<<"a///////////////////////////////////////////////////////////////////////////a";
    QByteArray bytest = textCode->fromUnicode(str);
    int tempint=returnDescriptorFromGoalName(goalName);
    if(tempint>0)
    {
        LiTcpSocketString *tempSocket=tcpSocketRegistery->value(tempint);
        tempSocket->write(bytest);
    }
    qDebug()<<"发:"<<str<<"给"<<goalName;
}

void LiLANMangeServer::sendTcpNews(int socketDescript, QString str)
{
    QByteArray bytest = textCode->fromUnicode(str);
    LiTcpSocketString *tempSocket=tcpSocketRegistery->value(socketDescript);
    tempSocket->write(bytest);
}

void LiLANMangeServer::registerTcpToGoal(LiTcpSocketString *tcpsocket)
{
    sendTcpNews(tcpsocket,"RegistTcp|ID=="+QString::number(tcpsocket->socketDescriptor())+"|Name=="+myName+"|");
    qDebug()<<"qweasdzxc";
}

//文件

void LiLANMangeServer::sendTcpFile(QString fileName, LiTcpSocketString *tcpSocketStr)
{
    LiTcpSocketFileServer *tempTcpFile=new LiTcpSocketFileServer(this);
    addAllFileServerID();
    tempTcpFile->setID(allFileServerID);
    tcpSocketFileServerRegistery->insert(allFileServerID,tempTcpFile);
    sendTcpNews(tcpSocketStr,tempTcpFile->sendFileAggrement_One(fileName));
//    connect(tempTcpFile,SIGNAL(sendFileOver(quint32)),this,SLOT(onDeleteTcpSocketFileServer(quint32)));
}

void LiLANMangeServer::sendTcpFile(QString fileName, int tcpDescriptor)
{
    LiTcpSocketFileServer *tempTcpFile=new LiTcpSocketFileServer(this);
    addAllFileServerID();
    tempTcpFile->setID(allFileServerID);
    tcpSocketFileServerRegistery->insert(allFileServerID,tempTcpFile);
    sendTcpNews(tcpDescriptor,tempTcpFile->sendFileAggrement_One(fileName));
//    connect(tempTcpFile,SIGNAL(sendFileOver(quint32)),this,SLOT(onDeleteTcpSocketFileServer(quint32)));
}

//Tcp信息处理--文件接收
void LiLANMangeServer::handleTcpNews(qintptr tcpSocketDescript, QString tcpNews)
{
    emit debug(tcpNews+QString::number(tcpSocketDescript));
//    qDebug()<<"asd0"+tcpSocketRegistery->value(tcpSocketDescript)->returnGoalName();
    qDebug()<<"asd1"+tcpNews;
//    if(tcpNews=="TCPOK!")
//    {
//        sendTcpNews(tcpSocketDescript,"TCPOK!");
//        qDebug()<<"我发了RegistTcp";
//    }
    if(tcpNews.startsWith(QLatin1String("File|")))
    {
        qDebug()<<"asd1";
        LiTcpSocketFileClient *tempTcpSocketFile=new LiTcpSocketFileClient(this);
        connect(tempTcpSocketFile,SIGNAL(returnMe(LiTcpSocketFileClient *)),this,SLOT(onRegistTcpSocketFile(LiTcpSocketFileClient*)));
        connect(tempTcpSocketFile,SIGNAL(receiveFileOver(qintptr)),this,SLOT(onDeleteTcpSocketFileClient(qintptr)));
        connect(tempTcpSocketFile,SIGNAL(receiveFileOver(qintptr)),this,SIGNAL(receiveFileOver()));//eye项目临时需要，后期升级
        LiTcpSocketString *tempTcpSocketStr=(*tcpSocketRegistery)[tcpSocketDescript];
        tempTcpSocketFile->receiveFileAggrement_One(tcpNews,tempTcpSocketStr->peerAddress().toString());
    }
    //需求
    else if(tcpSocketRegistery->value(tcpSocketDescript)->returnGoalName()=="KinectClient")
    {
        emit fromKinect(tcpNews);
    }
    else if(tcpSocketRegistery->value(tcpSocketDescript)->returnGoalName()=="MassageEye")
    {
        emit fromMassage(tcpNews);
    }
    else if (tcpSocketRegistery->value(tcpSocketDescript)->returnGoalName()=="FaceClient") {
        emit fromFace(tcpNews);
    }
}
//主动连接Tcp
void LiLANMangeServer::connectToTcpString(QString address, quint16 port, QString goalName)
{
    LiTcpSocketString *tempSocket=new LiTcpSocketString(tcpNewsList,this);
    tempSocket->connectToHost(QHostAddress(address),port);
//    tempSocket->setGoalIPV4(address);
//    tempSocket->setGoalName(goalName);
//    tempSocket->

    connect(tempSocket,SIGNAL(connectSucceed(LiTcpSocketString*)),this,SLOT(onRegistTcpSocket(LiTcpSocketString*)));
//    connect(tempSocket,SIGNAL(receiveNews(qintptr)),this,SLOT(onTcpNews(qintptr)));
}
//注册主动Tcp
void LiLANMangeServer::onRegistTcpSocket(LiTcpSocketString *tcpScoketStr)
{
    tcpSocketRegistery->insert(tcpScoketStr->socketDescriptor(),tcpScoketStr);
    connect(tcpScoketStr,SIGNAL(disconnectDescriptor(qintptr)),this,SLOT(onDeleteTcpSocketString(qintptr)));
    connect(tcpScoketStr,SIGNAL(receiveNews(qintptr)),this,SLOT(onTcpNews(qintptr)));
    registerTcpToGoal(tcpScoketStr);
    emit updateTcpSocketRegistery();
}
//注册文件传输tcp
void LiLANMangeServer::onRegistTcpSocketFile(LiTcpSocketFileClient *fileTcpSocket)
{
    qDebug()<<"asd7"<<fileTcpSocket->socketDescriptor();
    tcpSocketFileRegistery->insert(fileTcpSocket->socketDescriptor(),fileTcpSocket);
    qDebug()<<"asd8";
}
//文件服务端自增ID号
void LiLANMangeServer::addAllFileServerID()
{
    if(allFileServerID<65535)
    {
        while (tcpSocketFileServerRegistery->contains(allFileServerID)) {
            allFileServerID++;
        }
    }
    else
    {
        allFileServerID=0;
    }
}
//删除文件传输客户端
void LiLANMangeServer::onDeleteTcpSocketFileClient(qintptr socketDescript)
{
    LiTcpSocketFileClient *tempTcpSocketFileClient=(*tcpSocketFileRegistery)[socketDescript];
    tempTcpSocketFileClient->deleteLater();
    tcpSocketFileRegistery->remove(socketDescript);
}
//删除文件传输服务端
void LiLANMangeServer::onDeleteTcpSocketFileServer(quint32 id)
{
    LiTcpSocketFileServer *tempTcpSocketFileServer=(*tcpSocketFileServerRegistery)[id];
    tempTcpSocketFileServer->deleteLater();
    tcpSocketFileServerRegistery->remove(id);
}
//删除字符传输tcp套接字
void LiLANMangeServer::onDeleteTcpSocketString(qintptr socketDescript)
{
    LiTcpSocketString *tempTcpSocketString=(*tcpSocketRegistery)[socketDescript];
    tempTcpSocketString->deleteLater();
    tcpSocketRegistery->remove(socketDescript);
    emit updateTcpSocketRegistery();
    qDebug()<<"到底行不行";
}

//通过goalName查询其描述符,没有返回-1
int LiLANMangeServer::returnDescriptorFromGoalName(QString goalName)
{
    QHash<qintptr,LiTcpSocketString*>::const_iterator index=tcpSocketRegistery->constBegin();
    while(index!=tcpSocketRegistery->constEnd())
    {
        LiTcpSocketString *tempSocket=index.value();
        if(tempSocket->returnGoalName()==goalName)
        {
            return (int)index.key();
        }
        index++;
    }
    return -1;
}
//    返回本机IP地址
QString LiLANMangeServer::getLocalIPAddress()
{
    QString ipAddress;
        QList<QHostAddress> ipAddressesList = QNetworkInterface::allAddresses();
        for (int i = 0; i < ipAddressesList.size(); ++i) {
            if (ipAddressesList.at(i) != QHostAddress::LocalHost &&
                ipAddressesList.at(i).toIPv4Address()) {
                ipAddress = ipAddressesList.at(i).toString();
                break;
            }
        }
        if (ipAddress.isEmpty())
            ipAddress = QHostAddress(QHostAddress::LocalHost).toString();
        return ipAddress;
}


























//void LiLANMangeServer::tempNew()
//{
//    qDebug()<<"有信息";
//}
//属性修改
int LiLANMangeServer::returnTcpSocketRegisteryCount()
{
    return tcpSocketRegistery->count();
}
int LiLANMangeServer::returnTcpSocketRegisteryKey(int index)
{
    QList<qintptr> tempList=tcpSocketRegistery->keys();
    return (int)(tempList.at(index));
}
