#ifndef LIFISTEYEJSON_H
#define LIFISTEYEJSON_H

#include <QObject>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include <QFile>
#include <QDebug>
#include <iterator>

class LiFistEyeJSON : public QObject
{
    Q_OBJECT
public:
    explicit LiFistEyeJSON(QObject *parent = 0);
    Q_INVOKABLE QString addData(double left,double right);//添加数据
    Q_INVOKABLE QString returnJSONStr();//返回当前jsRoot的文本格式JSON数据
    void cleanJSONObjeck(QJsonObject &jsonObj);//清空QJSONObject
signals:

public slots:

private:
    QFile* jsonFile;
    QJsonDocument jsDoc;
    QJsonObject jsRoot;
    QJsonArray checkTime;
    QJsonArray checkLeftData;
    QJsonArray checkRightData;
};

#endif // LIFISTEYEJSON_H
