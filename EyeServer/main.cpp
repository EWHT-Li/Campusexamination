#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QQmlContext>
#include "./LiLANMangeServer/lilanmangeserver.h"
#include "./LiFile/LiStringFile/listringfile.h"
#include "./LiMediaPlay/Music/liaudio.h"
#include "./Date/qmlsharedate.h"
#include "./LiTTS/tts.h"
#include "./LIJSON/lifisteyejson.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    LiLANMangeServer lanMangeServer;
    LiStringFile liStringFile;
    LiAudio liAudio;
    QmlShareDate qmlShareDate;
    QQuickView view;
    TTS tts;
    LiFistEyeJSON tempJSON;
    view.rootContext()->setContextProperty("seeValueJSON",&tempJSON);
    view.rootContext()->setContextProperty("lanMangeServer",&lanMangeServer);
    view.rootContext()->setContextProperty("liStringFile",&liStringFile);
    view.rootContext()->setContextProperty("liAudio",&liAudio);
    view.rootContext()->setContextProperty("qmlShareDate",&qmlShareDate);
    view.rootContext()->setContextProperty("tts",&tts);
    view.setSource(QUrl(QStringLiteral("qrc:/main.qml")));
    view.show();

    return app.exec();
}

