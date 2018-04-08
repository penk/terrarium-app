Terrarium - UI Prototyping Tool for Coders
=========

![Doge](http://i.imgur.com/Z0KMIaf.png)

Terrarium is a cross platform QML Playground: the view [renders lively](http://i.imgur.com/MCA641U.gif) as you type in the editor, makes prototyping and experimenting with [QtQuick](http://qt.digia.com/qtquick/) a lot more fun!  

It monitors changes in its `TextEdit`, and triggers the view to reload source from the local http server. If you're looking for a file system watcher implementation, please refer to [QML LiveReload](https://github.com/penk/qml-livereload).

### More details on http://www.terrariumapp.com

## Download

* [iOS](https://itunes.apple.com/us/app/terrarium/id891232736?ls=1&mt=8)
* [Android](https://play.google.com/store/apps/details?id=com.terrariumapp.penk.Terrarium) or [download apk](https://github.com/penk/terrarium-app/releases/download/V1.5/TerrariumApp_1.5.apk)
* [Mac OSX](https://github.com/penk/terrarium-app/releases/download/V1.5/Terrarium-1.5.dmg)
* [Ubuntu Linux](https://github.com/penk/terrarium-app/releases/download/V1.5/terrarium_1.5_amd64.deb)
* [Ubuntu Touch](https://github.com/penk/terrarium-app/releases/download/V1.5/com.ubuntu.developer.penk.terrarium_1.5_armhf.click)

## Build Instructions

    git clone https://github.com/penk/terrarium-app.git
    cd terrarium-app && git submodule init && git submodule update
    qmake && make

## Platform Specific Instructions

### For Arch-Linux
Just go to AUR:
`yaourt -S terrarium-git`

### For Mac OSX/iOS

To add icons to iOS build, first generate and open `Terrarium.xcodeproj`, switch AppIcon to use [Assets Catalog](https://developer.apple.com/library/ios/recipes/xcode_help-image_catalog-1.0/Recipe.html), then replace `Terrarium/Images.xcassets/` directory with `platform/ios/Images.xcassets`.

As for Mac OSX, refer to `macdeployqt` command in `terrarium-app.pro` file.

### For Ubuntu Desktop/Phone

If you're using Qt packages from apt archive instead of [qt-project.org](http://download.qt-project.org/) releases, here's the dependencies:

    sudo apt-get install qt5-qmake qt5-default qtbase5-dev qtdeclarative5-dev build-essential

All `debian/` package information can be found under `platform/ubuntu/` directory, copy it to current path and build the package by:

    cp -r platform/ubuntu/debian .
    cp platform/ubuntu/terrarium.desktop .
    dpkg-buildpackage -b

If you're building click package, execute following command on device (for native compile):

    cp platform/ubuntu/* .
    click build .

And install it

    pkcon --allow-untrusted install-local com.ubuntu.developer.penk.terrarium_1.5_armhf.click

### For Android

First generate your keystore by `keytool`

    keytool -genkey -v -keystore ../TerrariumApp.keystore -alias TerrariumApp -keyalg RSA -keysize 2048 -validity 10000

then

    ~/Qt5.4.1/5.4/android_armv7/bin/qmake
    make
    make install INSTALL_ROOT=../android-terrarium

Build and sign apk by:

    ~/Qt5.4.1/5.4/android_armv7/bin/androiddeployqt --input \
        android-libTerrarium.so-deployment-settings.json \
        --output ../android-terrarium --release --sign ../TerrariumApp.keystore TerrariumApp

## Screenshots

* [Android 5.0.0](http://i.imgur.com/0X6e6wK.png)
* [iOS 8.2](http://i.imgur.com/n2EPoha.png)
* [Mac OSX 10.10.2](http://i.imgur.com/Z0KMIaf.png)
* [Ubuntu Touch](http://i.imgur.com/KShLea0.png)
* [Ubuntu 14.10](http://i.imgur.com/TI2rLIX.png)

## LICENSE

Copyright © 2014-2015 Ping-Hsun (penk) Chen <penkia@gmail.com>  
The source code is, unless otherwise specified, distributed under the terms of the MIT License.

## CREDITS

* [DocumentHandler](https://github.com/khertan/ownNotes) by Benoît HERVIER
* [QMLHighligher](https://gitorious.org/aalperts-automatons/bragi) by Alan Alpert
* [QHttpServer](https://github.com/rschroll/qhttpserver) by Robert Schroll
* [Font Awesome](http://fontawesome.io) by Dave Gandy
