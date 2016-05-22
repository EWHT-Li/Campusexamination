#include "lifisteyejson.h"

LiFistEyeJSON::LiFistEyeJSON(QObject *parent) : QObject(parent)
{
    jsonFile=new QFile("/storage/sdcard0/data/JSONFile");
    if(!jsonFile->exists())//判断文件是否存在，open只有在带写的情况下才会创建
    {
        jsonFile->open(QIODevice::WriteOnly);
        jsonFile->close();
    }
    qDebug()<<jsonFile->open(QIODevice::ReadOnly);
    QJsonParseError jsError;
    jsDoc=QJsonDocument::fromJson(jsonFile->readAll(),&jsError);//从文件中读取数据
    jsonFile->close();
    qDebug()<<jsError.errorString();
    if(jsError.error==QJsonParseError::NoError)//判断文件是否为空
    {
        QJsonObject tempJSObj=jsDoc.object();
        checkTime=tempJSObj.value("Time").toArray();
        checkLeftData=tempJSObj.value("Left").toArray();
        checkRightData=tempJSObj.value("Right").toArray();
    }else if (jsError.error==QJsonParseError::IllegalValue) {
        addData(0,0);
    }
    qDebug()<<checkTime.size();
}

QString LiFistEyeJSON::addData(double left, double right)
{
    if(left>0&&right>0)
    {
        checkTime.append((checkTime.size()+1));
        checkLeftData.append(left);
        checkRightData.append(right);
    }
    cleanJSONObjeck(jsRoot);//清空一下
    jsRoot.insert("Time",checkTime);
    jsRoot.insert("Left",checkLeftData);
    jsRoot.insert("Right",checkRightData);
    jsDoc.setObject(jsRoot);
    jsonFile->open(QIODevice::WriteOnly|QIODevice::Truncate);
    jsonFile->write(jsDoc.toJson(QJsonDocument::Indented));
    jsonFile->close();
    qDebug()<<"JSON"+jsDoc.toJson(QJsonDocument::Indented);
    return jsDoc.toJson(QJsonDocument::Indented);
}

void LiFistEyeJSON::cleanJSONObjeck(QJsonObject &jsonObj)
{
    if(!jsonObj.isEmpty())
    {
        QStringList tempList=jsonObj.keys();
        QList<QString>::iterator tempIterator=tempList.begin();
        while(tempIterator!=tempList.end())
        {
            qDebug()<<*tempIterator;
            jsonObj.remove(*tempIterator);
            tempIterator++;
        }
    }
}

QString LiFistEyeJSON::returnJSONStr()
{
    qDebug()<<"JSON2"+jsDoc.toJson(QJsonDocument::Indented);
    return jsDoc.toJson(QJsonDocument::Compact);
}
