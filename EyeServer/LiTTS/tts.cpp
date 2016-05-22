#include "tts.h"
#include <QUrl>
#include <QFile>
TTS::TTS(QObject *parent) : QObject(parent)
{
    flag=1;
    API_id="6196327";
    API_key="GvZoZ651bHqvGXZISE1oyCFf";
    API_secret_key="12cac8c453b83e945a485a5fef8072a0";
    API_access_token="";//进入令牌
    API_language="zh";
    manager = new QNetworkAccessManager();
    connect(manager,SIGNAL(finished(QNetworkReply*)),this,SLOT(replyFinish(QNetworkReply*)));
    savevoice=new QFile("/storage/sdcard0/data/temptts.mp3");
    manager->get(QNetworkRequest(QUrl( "https://openapi.baidu.com/oauth/2.0/token?grant_type=client_credentials&client_id="+API_key+"&client_secret="+API_secret_key)));
//    manager->get(QNetworkRequest(QUrl( "https://openapi.baidu.com/oauth/2.0/token?grant_type=client_credentials&client_id=GvZoZ651bHqvGXZISE1oyCFf&client_secret=12cac8c453b83e945a485a5fef8072a0")));
    //需求
    connect(&liaudio,SIGNAL(musicStop()),this,SIGNAL(over()));
}
//24.b6ae86de62102709f44cb4ef5469ffc6.2592000.1448266867.282335-6196327
//http://tsn.baidu.com/text2audio?tex=拉升快点进来看&lan=zh&cuid=6196327ctp=1&tok=24.b6ae86de62102709f44cb4ef5469ffc6.2592000.1448266867.282335-6196327
void TTS::replyFinish(QNetworkReply *reply)
{
    connect(reply,SIGNAL(finished()),this,SLOT(dealFinish()));
    if(flag==1)
    {
        QString strJsonAccess=reply->readAll();//获得http返回的信息
        qDebug()<<strJsonAccess;
        QScriptValue jsonAccess;//容器数据类型脚本
        QScriptEngine engineAccess;
        jsonAccess = engineAccess.evaluate("value = " + strJsonAccess);
        QScriptValueIterator iteratorAccess(jsonAccess);
        while (iteratorAccess.hasNext())
        {
                iteratorAccess.next();
              if(iteratorAccess.name()=="access_token")
                  API_access_token = iteratorAccess.value().toString();//得到 API_access_token,验证是百度用户
              qDebug()<<"验证"<<API_access_token;
         }
        if(API_access_token=="")
        {
            return;
        }
        flag=0;
        reply->deleteLater();//释放
    }
    else
    {
        qDebug()<<"qweasdzxc";
        temp=reply->rawHeader("Content-Type:");
        QByteArray datapack;
        datapack=reply->readAll();
        savevoice->write(datapack);
        savevoice->close();
//        emit over();
        liaudio.setMusicSource("file:////storage/sdcard0/data/temptts.mp3");
        liaudio.rootPlayerPlay();
    }
}

void TTS::getvoice(QString text, QString para_API_id, QString para_API_language)
{
    savevoice->open(QIODevice::ReadWrite|QIODevice::Truncate);
    QString  getTextUrl = "http://tsn.baidu.com/text2audio?tex="+text+"&lan="+para_API_language+"&cuid="+para_API_id+"&ctp=1&tok="+API_access_token;
//     QString  getTextUrl = "http://tsn.baidu.com/text2audio?tex=啥来的快&lan=zh&cuid=6196327&ctp=1&tok=24.bb2166a6d21072fb26ae5eea20755d5b.2592000.1448267783.282335-6196327";
    QUrl url(getTextUrl);
    QNetworkRequest request(url);
    manager->get(request);
    qDebug()<<"tts65"<<text;
}
