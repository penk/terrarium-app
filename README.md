Terrarium
=========

![Doge](http://www.terrariumapp.com/images/doge.png)

### Live QML Editor and Viewer

## Install

    git clone https://github.com/penk/terrarium-app.git
    cd terrarium-app && git submodule init && git submodule update 
    qmake && make 

## Usage

    ./Terrarium

Terrarium is a cross platform QML Playgrounds! It monitors changes in its `TextEdit`, and trigger the view to reload source from the local http server. If you're looking for a file system watcher implementation, please refer to [QML LiveReload](https://github.com/penk/qml-livereload). 

## Build for Mac/iOS

To add icons to iOS build, first generate and open `Terrarium.xcodeproj`, switch AppIcon to use (Assets Catalog)[https://developer.apple.com/library/ios/recipes/xcode_help-image_catalog-1.0/Recipe.html], then replace `Terrarium/Images.xcassets/` with `ios/Images.xcassets`. 

As for Mac OSX, refer to `macdeployqt` command in `terrarium-app.pro` file. 

## Build for Ubuntu Linux

If you're using apt-get instead of (qt-project.org)[http://download.qt-project.org/] releases, here's the dependencies: 

    sudo apt-get install qt5-qmake qtbase5-dev qtdeclarative5-dev 

## Tested Platforms

* [Mac OSX 10.9](http://i.imgur.com/iEoTDLa.png)
* [iOS 7.1](http://i.imgur.com/NezPpL9.png)
* [Ubuntu Touch](http://i.imgur.com/NPlxNx0.png)
* [Ubuntu 14.04](http://i.imgur.com/lrMH7OY.png)

## LICENSE 

The MIT License  
Copyright © 2014 Ping-Hsun (penk) Chen <penkia@gmail.com>
