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
#include "quickitemgrabber.h"
#if USE_WEBENGINE
#include <qtwebengineglobal.h>
#endif

int main(int argc, char *argv[])
{
    QStringList imports, plugins;

    QGuiApplication app(argc, argv);
    app.setApplicationName("Terrarium");
    app.setOrganizationName("terrariumapp");
    app.setOrganizationDomain("terrariumapp.com");

#if defined(Q_OS_MACX)
    int platformId = 0;
#elif defined(Q_OS_IOS)
    int platformId = 1;
#elif defined(Q_OS_ANDROID)
    int platformId = 2;
#elif defined(Q_OS_LINUX)
    int platformId = 3;
#else
    int platformId = 4;
#endif 

    qmlRegisterType<QHttpServer>("HttpServer", 1, 0, "HttpServer");
    qmlRegisterType<DocumentHandler>("DocumentHandler", 1, 0, "DocumentHandler");
    qmlRegisterUncreatableType<QHttpRequest>("HttpServer", 1, 0, "HttpRequest", "Do not create HttpRequest directly");
    qmlRegisterUncreatableType<QHttpResponse>("HttpServer", 1, 0, "HttpResponse", "Do not create HttpResponse directly");

    QString platformIP; 
    foreach (const QHostAddress &address, QNetworkInterface::allAddresses()) {
        if (address.protocol() == QAbstractSocket::IPv4Protocol && address != QHostAddress(QHostAddress::LocalHost))
             platformIP = address.toString();
    }

    // Handle command line arguments
    const QStringList arguments = QCoreApplication::arguments();
    for (int i = 1, size = arguments.size(); i < size; ++i) {
      const QString lowerArgument = arguments.at(i).toLower();
      if (lowerArgument == QLatin1String("-i") && i + 1 < size) {
        imports.append(arguments.at(++i));
      } else if (lowerArgument == QLatin1String("-p") && i + 1 < size) {
        plugins.append(arguments.at(++i));
      }
    }

#if USE_WEBENGINE
    QtWebEngine::initialize();
#endif

#if QT_VERSION > QT_VERSION_CHECK(5, 1, 0)
    QQmlApplicationEngine engine;

    for(int i = 0; i < imports.size(); ++i) {
      engine.addImportPath(imports[i]);
    }
    for(int i = 0; i < plugins.size(); ++i) {
      engine.addPluginPath(plugins[i]);
    }
    engine.rootContext()->setContextProperty("platform", QVariant::fromValue(platformId));
    engine.rootContext()->setContextProperty("platformIP", QVariant::fromValue(platformIP));
    engine.rootContext()->setContextProperty("Grabber",new QuickItemGrabber(&app));
    engine.load(QUrl("qrc:///main.qml"));
#else
    QQuickView view;
    view.engine()->rootContext()->setContextProperty("platform", QVariant::fromValue(platformId));
    view.engine()->rootContext()->setContextProperty("platformIP", QVariant::fromValue(platformIP));
    view.setSource(QUrl("qrc:///main.qml"));
    view.show();
#endif 
    return app.exec();
}
