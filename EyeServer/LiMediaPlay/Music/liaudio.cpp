#include "liaudio.h"

LiAudio::LiAudio(QObject *parent) : QObject(parent)
{
    connect(&rootPlayer,SIGNAL(stateChanged(QMediaPlayer::State)),this,SLOT(onRootPlayerStop(QMediaPlayer::State)));
//    connect(rootPlayer,SIGNAL(stateChanged))

    m_playRepeat=false;
}

void LiAudio::setMusicSource(QString musicPath)
{
    QUrl tempUrl(musicPath);
    QMediaContent tempContent(tempUrl);
    rootPlayer.setMedia(tempContent);
}

void LiAudio::rootPlayerPlay()
{
    rootPlayer.play();
}

void LiAudio::rootPlayerStop()
{
    rootPlayer.stop();
}

void LiAudio::rootPlayerPause()
{
    rootPlayer.pause();
}

void LiAudio::onRootPlayerStop(QMediaPlayer::State state)
{
    if(state==QMediaPlayer::StoppedState)
    {
        emit musicStop();
        if(m_playRepeat)
        {
            rootPlayerPlay();
        }
    }
}

bool LiAudio::getPlayRepeat()
{
    return m_playRepeat;
}

void LiAudio::setPlayRepeat(const bool bol)
{
    m_playRepeat=bol;
}
