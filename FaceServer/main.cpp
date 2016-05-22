#include <QGuiApplication>
//#include <QQmlApplicationEngine>

//int main(int argc, char *argv[])
//{
//    QGuiApplication app(argc, argv);

//    QQmlApplicationEngine engine;
//    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

//    return app.exec();
//}
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QQmlContext>
#include "./LiLANMangeServer/lilanmangeserver.h"
#include "./LiMediaPlay/Music/liaudio.h"
#include "./Date/qmlsharedate.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    LiLANMangeServer lanMangeServer;
//    LiStringFile liStringFile;
    LiAudio liAudio;
    LiAudio backgroundmusic;
    backgroundmusic.setMusicSource("qrc:/source/Voice/backgroundmusic.mp3");
    backgroundmusic.setPlayRepeat(true);
    backgroundmusic.rootPlayerPlay();
    QmlShareDate qmlShareDate;
    QQmlApplicationEngine view;
//    TTS tts;
    view.rootContext()->setContextProperty("lanMangeServer",&lanMangeServer);
//    view.rootContext()->setContextProperty("liStringFile",&liStringFile);
    view.rootContext()->setContextProperty("liAudio",&liAudio);
    view.rootContext()->setContextProperty("qmlShareDate",&qmlShareDate);
//    view.rootContext()->setContextProperty("tts",&tts);
    view.load(QUrl(QStringLiteral("qrc:/main.qml")));
//    view.show();

    return app.exec();
}

