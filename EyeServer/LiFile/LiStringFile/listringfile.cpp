#include "listringfile.h"
#include <QDebug>

LiStringFile::LiStringFile(QObject *parent) : QObject(parent)
{

}

QString LiStringFile::returnTextAllStr(QString Name)
{
    QFile tempFile(Name);
    qDebug()<< tempFile.open(QIODevice::ReadOnly);
    QTextStream tempStrStream(&tempFile);
    return tempStrStream.readAll();
}
