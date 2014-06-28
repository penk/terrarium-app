#include <QtQuick/QQuickView>
#include <QtGui/QGuiApplication>
#include <QtQml>
#if QT_VERSION > QT_VERSION_CHECK(5, 1, 0)
#include <QQmlApplicationEngine>
#endif
#include "qhttpserver/src/qhttpserver.h"
#include "qhttpserver/src/qhttprequest.h"
#include "qhttpserver/src/qhttpresponse.h"
#include "qhttpserver/src/qhttpconnection.h"
#include "documenthandler.h"
#if USE_WEBENGINE
#include <qtwebengineglobal.h>
#endif

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setApplicationName("Terrarium");
    app.setOrganizationName("terrariumapp");
    app.setOrganizationDomain("terrariumapp.com");

    qmlRegisterType<QHttpServer>("HttpServer", 1, 0, "HttpServer");
    qmlRegisterType<DocumentHandler>("DocumentHandler", 1, 0, "DocumentHandler");
    qmlRegisterUncreatableType<QHttpRequest>("HttpServer", 1, 0, "HttpRequest", "Do not create HttpRequest directly");
    qmlRegisterUncreatableType<QHttpResponse>("HttpServer", 1, 0, "HttpResponse", "Do not create HttpResponse directly");
#if USE_WEBENGINE
    QWebEngine::initialize();
#endif
#if QT_VERSION > QT_VERSION_CHECK(5, 1, 0)
    QQmlApplicationEngine engine(QUrl("qrc:///qml/main.qml"));
#else
    QQuickView view;
    view.setSource(QUrl("qrc:///qml/main.qml"));
    view.show();
#endif 
    return app.exec();
}
