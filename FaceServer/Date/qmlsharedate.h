#ifndef QMLSHAREDATE_H
#define QMLSHAREDATE_H

#include <QObject>

class QmlShareDate : public QObject
{
    Q_OBJECT
public:
    explicit QmlShareDate(QObject *parent = 0);

    Q_PROPERTY(QString massageName READ getMassageName WRITE setMassageName )
    QString getMassageName();
    void setMassageName(const QString massagename);
    Q_PROPERTY(QString kinectName READ getKinectName)
    QString getKinectName(){return m_kinectName;}
    Q_PROPERTY(QString faceName READ getFaceName )
    QString getFaceName(){return m_faceName;}

    Q_PROPERTY(QString prepareMassage READ getPrepareMassage)
    QString getPrepareMassage(){return m_prepareMassage;}
    Q_PROPERTY(QString appearMan READ getAppearMan)
    QString getAppearMan(){return m_appearMan;}
    Q_PROPERTY(QString openLight READ getOpenLight )
    QString getOpenLight(){return m_openLight;}
    Q_PROPERTY(QString closeLight READ getCloseLight )
    QString getCloseLight(){return m_closeLight;}
    Q_PROPERTY(QString openMassage READ getOpenMassage )
    QString getOpenMassage(){return m_openMassage;}
    Q_PROPERTY(QString closeMassage READ getCloseMassage)
    QString getCloseMassage(){return m_closeMassage;}
    Q_PROPERTY(QString openLaser READ getOpenLaser)
    QString getOpenLaser(){return m_openLaser;}
    Q_PROPERTY(QString closeLaser READ getCloseLaser)
    QString getCloseLaser(){return m_closeLaser;}



    Q_PROPERTY(QString startKinect READ getStartKinect)
    QString getStartKinect(){return m_startKinect;}

    Q_PROPERTY(QString sendPhoto READ getSendPhoto)
    QString getSendPhoto(){return m_sendPhoto;}
signals:

public slots:
private:
     QString m_massageName;
     QString m_kinectName;
     QString m_faceName;
//     massage指令
     QString m_prepareMassage;
     QString m_appearMan;
     QString m_openLight;
     QString m_closeLight;
     QString m_openMassage;
     QString m_closeMassage;
     QString m_openLaser;
     QString m_closeLaser;
     //kinect
     QString m_startKinect;
     //face
     QString m_sendPhoto;
//     QString
};

#endif // QMLSHAREDATE_H
