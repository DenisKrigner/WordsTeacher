#ifndef IMAGEPARSER_H
#define IMAGEPARSER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QUrl>
#include <QStringList>
#include <QVector>
#include <utility>

class ImageParser : public QObject
{
    Q_OBJECT
public:
    explicit ImageParser(QObject *parent = nullptr);

    void parse(QString);

    Q_INVOKABLE QString sendImgUrls();

    Q_INVOKABLE int checkAnswer(QString,QString);
signals:
    void sendNameOfAnimal(QString str);
private slots:
    void getData(QNetworkReply*);

private:
    QNetworkAccessManager* m_manager;
    QVector<QString> imgSrcVec;
    QString imgUrl;

    unsigned int imgIterator = 0;
};

#endif // IMAGEPARSER_H
