unix:!android {
    isEmpty(target.path) {
        qnx {
            target.path = /tmp/$${TARGET}/bin
        } else {
            target.path = /opt/$${TARGET}/bin
        }
        export(target.path)
    }
    INSTALLS += target
}

export(INSTALLS)

HEADERS += \
    $$PWD/Date/qmlsharedate.h \
    $$PWD/LiLANMangeServer/lilanmangeserver.h \
    $$PWD/LiLANMangeServer/litcpsocketfileclient.h \
    $$PWD/LiLANMangeServer/litcpsocketfileserver.h \
    $$PWD/LiLANMangeServer/litcpsocketstring.h \
    $$PWD/LiMediaPlay/Music/liaudio.h

SOURCES += \
    $$PWD/Date/qmlsharedate.cpp \
    $$PWD/LiLANMangeServer/lilanmangeserver.cpp \
    $$PWD/LiLANMangeServer/litcpsocketfileclient.cpp \
    $$PWD/LiLANMangeServer/litcpsocketfileserver.cpp \
    $$PWD/LiLANMangeServer/litcpsocketstring.cpp \
    $$PWD/LiMediaPlay/Music/liaudio.cpp
