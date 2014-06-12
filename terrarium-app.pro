TEMPLATE = app
TARGET = Terrarium
QT += qml quick network

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
RESOURCES += resource.qrc

mac {
    QMAKE_INFO_PLIST = mac/Info.plist
    ICON = mac/icon.icns
    #QMAKE_POST_LINK += macdeployqt Terrarium.app/ -qmldir=qml/ -verbose=1 -dmg
}

ios {
    QMAKE_INFO_PLIST = ios/Info.plist
}
