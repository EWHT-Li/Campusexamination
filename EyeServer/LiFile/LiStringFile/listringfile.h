#ifndef LISTRINGFILE_H
#define LISTRINGFILE_H

#include <QObject>
#include <QTextStream>
#include <QFile>

class LiStringFile : public QObject
{
    Q_OBJECT
public:
    explicit LiStringFile(QObject *parent = 0);
    Q_INVOKABLE QString returnTextAllStr(QString Name);
signals:

public slots:
};

#endif // LISTRINGFILE_H
