TEMPLATE = app
TARGET = Terrarium
QT += qml quick network sql
webengine {
    QT += webengine
    DEFINES += USE_WEBENGINE
}

SOURCES += src/main.cpp \
    src/qmlhighlighter.cpp \
    src/documenthandler.cpp \
    qhttpserver/src/qhttpconnection.cpp \
    qhttpserver/src/qhttprequest.cpp \
    qhttpserver/src/qhttpresponse.cpp \
    qhttpserver/src/qhttpserver.cpp \
    qhttpserver/http-parser/http_parser.c

HEADERS += qhttpserver/src/qhttpserver.h \
    qhttpserver/src//qhttpresponse.h \
    qhttpserver/src//qhttprequest.h \
    src/qmlhighlighter.h \
    src/documenthandler.h \
    qhttpserver/src//qhttpconnection.h 

INCLUDEPATH += ./qhttpserver/http-parser/
RESOURCES += qml/assets.qrc

android {
    ANDROID_PACKAGE_SOURCE_DIR = ./platform/android
}

mac {
    QMAKE_MAC_SDK = macosx10.10
    QMAKE_INFO_PLIST = platform/mac/Info.plist
    ICON = platform/mac/icon.icns
    #QMAKE_POST_LINK += macdeployqt Terrarium.app/ -qmldir=qml/ -verbose=1 -dmg
}

ios {
    QMAKE_INFO_PLIST = platform/ios/Info.plist
}
