#ifndef TTS_H
#define TTS_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QScriptValue>
#include <QScriptEngine>
#include <QScriptValueIterator>
#include <QFile>
#include<QDebug>
#include "./LiMediaPlay/Music/liaudio.h"

class TTS : public QObject
{
    Q_OBJECT
public:
    explicit TTS(QObject *parent = 0);
    Q_INVOKABLE void getvoice(QString text,QString para_API_id="6196327",QString para_API_language="zh" );
    Q_INVOKABLE QString retemp(){savevoice->close();return temp;}
signals:
    void over();
public slots:
    void replyFinish(QNetworkReply *reply);
    void dealFinish(){temp=temp+"finish";}
private:
    int flag;
    QFile *savevoice;
    QString temp;
    QString API_access_token;
    QString API_id;
    QString API_key;
    QString API_secret_key;
    QString API_language;
    QNetworkAccessManager *manager;
    LiAudio liaudio;
};

#endif // TTS_H
