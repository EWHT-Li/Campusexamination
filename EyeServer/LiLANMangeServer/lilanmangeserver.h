#ifndef LILANMANGESERVER_H
#define LILANMANGESERVER_H

//主动连接未测试
//文件传输完成的信号封装加详细信息

#include <QTcpServer>
#include <QUdpSocket>
#include <QTimer>
#include <QString>
#include <QDebug>
#include <QTextCodec>
#include <QByteArray>
#include <QNetworkInterface>
#include "litcpsocketstring.h"
#include "litcpsocketfileclient.h"
#include "litcpsocketfileserver.h"

//massageEye需要
#include "./Date/qmlsharedate.h"

class LiLANMangeServer : public QTcpServer
{
    Q_OBJECT
public:
    LiLANMangeServer(QObject *parent=0);
    //TCP自动监听
    Q_INVOKABLE bool autoListen();
    //处理udp信息
    Q_INVOKABLE void handleRootUdpNews(QString str,QHostAddress sendAddress);
    //广播信息
    Q_INVOKABLE void broadcastMessage(QString str);//广播信息
    Q_INVOKABLE void broadcastMessageAllAccurate(QString str);//广播信息到all指定地址和端口
    Q_INVOKABLE void broadcastMessageAllPort(QString str);//广播信息到all指定端口
//    Q_INVOKABLE void broadcastMessage();
    //添加广播对象,在广播信息时会向添加的对象发送
    Q_INVOKABLE bool addBroadcastGoal(QString senderAddress,quint16 senderPort);
    //添加广播端口号
    Q_INVOKABLE void addBroadcastPort(quint16 addPort);
    //第二步,回应
    Q_INVOKABLE void replayClientStart(int cycle=1000,int range=30000);
    //Tcp字符串发送
    Q_INVOKABLE void sendTcpNews(int socketDescript,QString str);
    Q_INVOKABLE void sendTcpNews(LiTcpSocketString *tcpsocket,QString str);
    Q_INVOKABLE void sendTcpNews(QString goalName,QString str);
    void incomingConnection(qintptr socketDescriptor);
    void registerTcpToGoal(LiTcpSocketString *tcpsocket);
    //通过goalName查询其描述符,没有返回-1
    Q_INVOKABLE int returnDescriptorFromGoalName(QString goalName);
    //文件
    Q_INVOKABLE void sendTcpFile(QString fileName,LiTcpSocketString *tcpSocketStr);
    Q_INVOKABLE void sendTcpFile(QString fileName,int tcpDescriptor);
    //Tcp信息处理--文件接收
    Q_INVOKABLE void handleTcpNews(qintptr tcpSocketDescript,QString tcpNews);
    //主动连接Tcp
    Q_INVOKABLE void connectToTcpString(QString address,quint16 port,QString goalName="");
    // 返回本机IP地址
    Q_INVOKABLE QString getLocalIPAddress();


    //属性修改
    Q_INVOKABLE int returnTcpSocketRegisteryCount();
    Q_INVOKABLE int returnTcpSocketRegisteryKey(int index);

signals:
//    测试
    void debug(QString str);
//    有新的tcp连接加入
    void updateTcpSocketRegistery();
//    udp新信息
    void udpNews(QString str);
//Kinect客户端需求
    void fromKinect(QString kinectStr);
//    按摩端需求
    void fromMassage(QString massageStr);
//    人脸识别端需求
    void fromFace(QString faceStr);
//    文件传输完成信号初级--项目需要（后期升级）
    void receiveFileOver();


public slots:
    //Udp信息预处理
    void onRootUdpNews();
//    我在这
    void iAmHere();
    void replayClientTimerStop();
    //Tcp信息处理
    void onTcpNews(qintptr tcpSocketDescript);
    //注册主动Tcp
    void onRegistTcpSocket(LiTcpSocketString* tcpScoketStr);
    //注册文件传输tcp
    void onRegistTcpSocketFile(LiTcpSocketFileClient *fileTcpSocket);

    //删除文件传输客户端
    void onDeleteTcpSocketFileClient(qintptr socketDescript);
    //删除文件传输服务端
    void onDeleteTcpSocketFileServer(quint32 id);
    //删除字符传输tcp套接字
    void onDeleteTcpSocketString(qintptr socketDescript);
//    void tempNew();
private:
    static quint16 allPort;
    //端口号增加函数
    void addAllPort();
    static quint32 allFileServerID;
    //文件服务端自增ID号
    void addAllFileServerID();
    
    QUdpSocket *rootUdpSocket;
    quint16 rootUdpPort;
    QString multicastAddress;//组播地址
    QString rootUdpAddress;//Udp绑定地址
    
    quint16 goalPort;

    QTextCodec *textCode;//发送字符串编码
    QString myName;//我的名字
    QTimer *replayClientTimer;
    QString tempRootStr;
    QHostAddress senderAddress;
    quint16 senderPort;
    QTimer *replayClientRange;
    QString localIPV4Address;//本地IPV4地址
    
    QHash<qintptr,QString> *tcpNewsList;//tcp信息列表
    QHash<qintptr,LiTcpSocketString*> *tcpSocketRegistery;//tcpsocket列表
    QHash<qintptr,LiTcpSocketFileClient*> *tcpSocketFileRegistery;//文件传输客户端注册表
    QHash<quint32,LiTcpSocketFileServer*> *tcpSocketFileServerRegistery;//文件传输服务器注册表
    QHash<QHostAddress*,quint16*> *udpaClientRegistery;//UDP广播目标注册表
    QList<quint16> *udpGoalPortList;//udp广播端口号注册表

//    按摩需求
    quint16 massagePort;
    bool connectControl;
    QmlShareDate qmlShareDate;
    
};

#endif // LILANMANGESERVER_H
