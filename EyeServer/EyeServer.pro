TEMPLATE = app

QT += qml quick widgets network core multimedia script
CONFIG += c++11

SOURCES += main.cpp \
    LiLANMangeServer/lilanmangeserver.cpp \
    LiLANMangeServer/litcpsocketfileclient.cpp \
    LiLANMangeServer/litcpsocketfileserver.cpp \
    LiLANMangeServer/litcpsocketstring.cpp \
    Date/qmlsharedate.cpp \
    LiFile/LiStringFile/listringfile.cpp \
    LiMediaPlay/Music/liaudio.cpp \
    LiTTS/tts.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    android/assets/yanbaojianchao.mp4

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

HEADERS += \
    LiLANMangeServer/lilanmangeserver.h \
    LiLANMangeServer/litcpsocketfileclient.h \
    LiLANMangeServer/litcpsocketfileserver.h \
    LiLANMangeServer/litcpsocketstring.h \
    Date/qmlsharedate.h \
    LiFile/LiStringFile/listringfile.h \
    LiMediaPlay/Music/liaudio.h \
    LiTTS/tts.h

