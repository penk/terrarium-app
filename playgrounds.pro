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
    CONFIG += x86
    QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.6
    QMAKE_INFO_PLIST = Info.plist
    ICON = icon.icns
}
