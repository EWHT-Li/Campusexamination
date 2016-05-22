#ifndef LIAUDIO_H
#define LIAUDIO_H

#include <QObject>
#include <QMediaPlayer>

class LiAudio : public QObject
{
    Q_OBJECT
public:
    explicit LiAudio(QObject *parent = 0);
    Q_INVOKABLE void setMusicSource(QString musicPath);
    Q_INVOKABLE void rootPlayerPlay();
    Q_INVOKABLE void rootPlayerStop();
    Q_INVOKABLE void rootPlayerPause();

//    是否单曲循环
    Q_PROPERTY(bool playRepeat READ getPlayRepeat WRITE setPlayRepeat)
    bool getPlayRepeat();
    void setPlayRepeat(const bool bol);

signals:
    void musicStop();
public slots:
    void onRootPlayerStop(QMediaPlayer::State state);
private:
    QMediaPlayer rootPlayer;
    bool m_playRepeat;
};

#endif // LIAUDIO_H
