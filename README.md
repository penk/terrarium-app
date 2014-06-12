Terrarium
===============

![playgrounds](http://i.imgur.com/nyPoJfI.png)

### Live QML Editor and Viewer

## Install

    git clone https://github.com/penk/terrarium-app.git
    cd terrarium-app && git submodule init && git submodule update 
    qmake && make 

## Usage

    ./Terrarium

Terrarium is a cross platform QML Playgrounds! It monitors changes in its `TextEdit`, and trigger the view to reload source from the local http server. If you're looking for a file system watcher implementation, please refer to [QML LiveReload](https://github.com/penk/qml-livereload). 

## Tested Platforms

* [Mac OSX 10.9](http://i.imgur.com/iEoTDLa.png)
* [iOS 7.1](http://i.imgur.com/NezPpL9.png)
* [Ubuntu Touch](http://i.imgur.com/NPlxNx0.png)
* [Ubuntu 14.04](http://i.imgur.com/lrMH7OY.png)

## LICENSE 

The MIT License  
Copyright © 2014 Ping-Hsun (penk) Chen <penkia@gmail.com>
