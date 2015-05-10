/** Author:  Ben Lau (https://github.com/benlau)
 */
#include <QtGlobal>
#include <QtCore>
#include <QQuickWindow>
#include <QOpenGLFunctions>
#include "quickitemgrabber.h"

#if (QT_VERSION < QT_VERSION_CHECK(5, 4, 0))
#include <private/qquickitem_p.h>
#include <private/qquickshadereffectsource_p.h>
#else
// Added since Qt 5.4
#include <QQuickItemGrabResult>
#endif


QuickItemGrabber::QuickItemGrabber(QObject *parent) :
    QObject(parent)
{
    m_busy = false;
    m_ready = false;
}

bool QuickItemGrabber::busy() const
{
    return m_busy;
}

bool QuickItemGrabber::grab(QQuickItem *target,QSize targetSize)
{
    if (m_busy ||
        target == 0  ||
        !target->window() ||
        !target->window()->isVisible() ) {
        return false;
    }
    m_ready = false;
    m_targetSize = targetSize;
    m_target = target;
    m_window = target->window();

    if (m_targetSize.isEmpty()) {
        m_targetSize = QSize(m_target->width(),m_target->height());
    }

#if (QT_VERSION < QT_VERSION_CHECK(5, 4, 0))

    QQuickItemPrivate::get(m_target)->refFromEffectItem(false);

    m_target->window()->update();

    connect(m_window.data(),SIGNAL(beforeSynchronizing()),
            this,SLOT(ready()),Qt::DirectConnection);

    connect(m_window.data(),SIGNAL(afterRendering()),
            this,SLOT(capture()),Qt::DirectConnection);
#else

    result = target->grabToImage(m_targetSize);

    if (result.isNull()) {
        qDebug() << "Can't grab target item";
        return false;
    }

    connect(result.data(),SIGNAL(ready()),
            this,SLOT(onGrabResultReady()));
#endif

    setBusy(true);

    return true;
}

bool QuickItemGrabber::save(QString filename)
{
    if (m_image.isNull()) {
        qWarning() << "QuickItemGrabber::save() - The image is null";
        return false;
    }
    return m_image.save(filename);
}

void QuickItemGrabber::ready()
{
    m_ready = true;
}

#if (QT_VERSION >= QT_VERSION_CHECK(5, 4, 0))
void QuickItemGrabber::onGrabResultReady()
{
    QImage image =  result->image();
    setImage(image);

    result.clear();
    setBusy(false);
    emit grabbed();
}
#endif

QImage QuickItemGrabber::image() const
{
    return m_image;
}

#if (QT_VERSION < QT_VERSION_CHECK(5, 4, 0))

void QuickItemGrabber::capture()
{
    if (!m_ready) { // It is not ready yet
        return;
    }

    if (m_target) { // Just in case the item is destroyed before rendering completed
        QOpenGLContext* context = QOpenGLContext::currentContext();

        QQuickShaderEffectTexture *m_texture = new QQuickShaderEffectTexture(m_target);
        m_texture->setItem(QQuickItemPrivate::get(m_target)->itemNode());

        // Set the source rectangle
        QSize sourceSize;
        sourceSize = QSize(m_target->width(),m_target->height());
        m_texture->setRect(QRectF(0, sourceSize.height(), sourceSize.width(), -sourceSize.height()));

        QSize maxSize = maxTextureSize();
        /*
        if (!maxSize.isValid()) {
            GLint param;

            QOpenGLFunctions glFuncs(context);
            glFuncs.glGetIntegerv(GL_MAX_TEXTURE_SIZE,&param);

            maxSize = QSize(param,param);
            setMaxTextureSize(maxSize);
        }

        QSize textureSize = m_targetSize;
        if (maxSize.isValid() &&
                (textureSize.width() > maxSize.width() ||
                textureSize.height() > maxSize.height())) {
            FVRectToRect scaler;
            scaler.scaleToFit(textureSize,maxSize);
            // The required size is larger than max texture size.
            qDebug() << "Downgrade target image from" << textureSize << scaler.transformedRect().toRect().size();
            textureSize = scaler.transformedRect().toRect().size();
        }
        */

        QSize expectedSize = textureSize();

        QSGContext *sg = QSGRenderContext::from(context)->sceneGraphContext();
        const QSize minSize = sg->minimumFBOSize();
        m_texture->setSize(QSize(qMax<int>(minSize.width(), expectedSize.width()),
                                  qMax<int>(minSize.height(), expectedSize.height())));
        m_texture->scheduleUpdate();
        m_texture->updateTexture();
        QImage image =  m_texture->toImage();
        setImage(image);

        delete m_texture;
        m_texture = 0;
    }

    disconnect(m_window.data(), SIGNAL(afterRendering()), this, SLOT(capture()));
    disconnect(m_window.data(), SIGNAL(beforeSynchronizing()), this, SLOT(ready()));

    setBusy(false);
    emit grabbed();
}
#endif

void QuickItemGrabber::setBusy(bool value)
{
    if (m_busy != value) {
        m_busy = value;
        emit busyChanged();
    }
}

void QuickItemGrabber::setImage(QImage value)
{
    m_image = value;
    emit imageChanged();
}

void QuickItemGrabber::clear()
{
    setImage(QImage());
}

