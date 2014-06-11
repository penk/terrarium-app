QML Playgrounds
===============

![playgrounds](http://i.imgur.com/nyPoJfI.png)

### Reload-as-you-type QML editor and live viewer 

## Install

    git clone https://github.com/penk/qml-playgrounds.git
    cd qml-playgrounds && git submodule init && git submodule update 
    qmake && make 

## Usage

    ./Playgrounds


QML Playgrounds monitors changes in its `TextEdit`, and trigger the view to reload source from the local http server. If you're looking for a file system watcher implementation, please refer to [QML LiveReload](https://github.com/penk/qml-playgrounds). 

## LICENSE 

The MIT License  
Copyright © 2014 Ping-Hsun (penk) Chen <penkia@gmail.com>
