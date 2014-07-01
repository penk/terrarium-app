TEMPLATE = app
TARGET = Terrarium
QT += qml quick network sql
webengine {
    QT += webengine
    DEFINES += USE_WEBENGINE
}

SOURCES += main.cpp \
    qmlhighlighter.cpp \
    documenthandler.cpp \
    qhttpserver/src/qhttpconnection.cpp \
    qhttpserver/src/qhttprequest.cpp \
    qhttpserver/src/qhttpresponse.cpp \
    qhttpserver/src/qhttpserver.cpp \
    qhttpserver/http-parser/http_parser.c

HEADERS += qhttpserver/src/qhttpserver.h \
    qhttpserver/src//qhttpresponse.h \
    qhttpserver/src//qhttprequest.h \
    qmlhighlighter.h \
    documenthandler.h \
    qhttpserver/src//qhttpconnection.h 

INCLUDEPATH += ./qhttpserver/http-parser/
RESOURCES += assets.qrc

mac {
    QMAKE_INFO_PLIST = mac/Info.plist
    ICON = mac/icon.icns
    #QMAKE_POST_LINK += macdeployqt Terrarium.app/ -qmldir=qml/ -verbose=1 -dmg
}

ios {
    QMAKE_INFO_PLIST = ios/Info.plist
    QTPLUGIN += qsqlite
}

#android {
#    ANDROID_DEPLOYMENT_DEPENDENCIES += /plugins/platforms/android/libqtforandroid.so \
#    qml/QtQuick/LocalStorage/libqmllocalstorageplugin.so \
#    qml/QtQuick/LocalStorage/qmldir \
#    plugins/sqldrivers/libqsqlite.so 
#}
