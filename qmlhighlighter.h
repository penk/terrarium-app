#include <QSyntaxHighlighter>

class QMLHighlighter : public QSyntaxHighlighter
{
    Q_OBJECT
public:
        //BUG: QSyntaxHighlighter(0) crashes!
    QMLHighlighter(QObject* parent=new QObject()) : QSyntaxHighlighter(parent)
    {

    }
    QMLHighlighter(QTextDocument* parent) : QSyntaxHighlighter(parent)
    {
    }
protected:
    virtual void highlightBlock(const QString &text);
private:
    void applyBasicHighlight(const QString &text, QRegExp &re, QTextCharFormat &format);
};
