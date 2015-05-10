/** Author:  Ben Lau (https://github.com/benlau)
 */
#ifndef QUICKITEMGRABBER_H
#define QUICKITEMGRABBER_H

#include <QObject>
#include <QQuickItem>
#include <QImage>
#include <QPointer>

/// QuickItemGrabber grabs QQuickItem into QImage

class QuickItemGrabber : public QObject
{
    Q_OBJECT
    /// "Busy" flag. It is TRUE if the grabber is running. It won't accept another request when busy.
    Q_PROPERTY(bool busy READ busy NOTIFY busyChanged)

    /// The grabbed image
    Q_PROPERTY(QImage image READ image NOTIFY imageChanged)

public:
    explicit QuickItemGrabber(QObject *parent = 0);

    bool busy() const;
    QImage image() const;

    /// Grab the target item and save to "image" property
    Q_INVOKABLE bool grab(QQuickItem* target,QSize targetSize = QSize());

    /// Save the grabbed image into file. It is a blocked call.
    Q_INVOKABLE bool save(QString filename);

    /// Clear the captured image.
    Q_INVOKABLE void clear();

signals:
    void busyChanged();
    void imageChanged();
    void grabbed();
    void maxTextureSizeChanged();

private:
    // Ready for capture
    Q_INVOKABLE void ready();

#if (QT_VERSION < QT_VERSION_CHECK(5, 4, 0))
    Q_INVOKABLE void capture();
#else
    Q_INVOKABLE void onGrabResultReady();
    QSharedPointer<QQuickItemGrabResult> result;
#endif

    void setBusy(bool value);
    void setImage(QImage value);

    bool m_busy;
    bool m_ready;
    QSize m_targetSize;
    QPointer<QQuickItem> m_target;
    QPointer<QQuickWindow> m_window;
    QImage m_image;
};

#endif // QUICKITEMGRABBER_H
