QML Playgrounds
===============

![playgrounds](http://i.imgur.com/lBSQFC2.png)

### Reload-as-you-type QML editor and live viewer 

## Usage 

1. Install QML [HttpServer](https://github.com/rschroll/qhttpserver) plugin, see [more details](http://rschroll.github.io/beru/2013/08/16/a-http-server-in-qml.html)
2. Start the editor by: `qmlscene playgrounds.qml` 

Or

    qmake && make 
    ./playground

QML Playgrounds monitors changes in its `TextEdit`, and trigger the view to reload source from the local http server. If you're looking for a file system watcher implementation, please refer to [QML LiveReload](https://github.com/penk/qml-playgrounds). 
