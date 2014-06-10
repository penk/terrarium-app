#include <QtQuick/QQuickView>
#include <QtGui/QGuiApplication>
#include <QtQml>
#include "qhttpserver/src/qhttpserver.h"
#include "qhttpserver/src/qhttprequest.h"
#include "qhttpserver/src/qhttpresponse.h"
#include "qhttpserver/src/qhttpconnection.h"
#include "documenthandler.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<QHttpServer>("HttpServer", 1, 0, "HttpServer");
    qmlRegisterType<DocumentHandler>("DocumentHandler", 1, 0, "DocumentHandler");
    qmlRegisterUncreatableType<QHttpRequest>("HttpServer", 1, 0, "HttpRequest", "Do not create HttpRequest directly");
    qmlRegisterUncreatableType<QHttpResponse>("HttpServer", 1, 0, "HttpResponse", "Do not create HttpResponse directly");

    QQuickView view;
    view.setSource(QUrl("qrc:/playgrounds.qml"));
    view.show();

    return app.exec();
}
