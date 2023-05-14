#include "imageparser.h"

#include <QDebug>
#include <random>



ImageParser::ImageParser(QObject *parent) : QObject(parent),
    m_manager(new QNetworkAccessManager)
{

    parse("https://animalcorner.org/animals/");
    connect(m_manager, SIGNAL(finished(QNetworkReply*)), SLOT(getData(QNetworkReply*)));


}

void ImageParser::parse(QString url)
{
    m_manager->get(QNetworkRequest(QUrl(url)));
}

QString ImageParser::sendImgUrls()
{
    auto seed = std::random_device{}();
        std::mt19937 gen(seed);
        std::uniform_int_distribution<int> dis(1, imgSrcVec.size());

        int imgIterator = dis(gen);

        int startIndex = 0;
        int lastIndex = 0;

        QString nameOfAnimal;

        imgUrl = imgSrcVec.at(imgIterator);

        startIndex = imgUrl.indexOf("2015/02");
        lastIndex =  imgUrl.indexOf("-150x150");

        nameOfAnimal = imgUrl.mid(startIndex + 8, lastIndex - startIndex - 10);

        emit sendNameOfAnimal(nameOfAnimal);

        return imgSrcVec.at(imgIterator);
}

int ImageParser::checkAnswer(QString nameOfAnimal, QString userAnswer)
{
    int verdict = 0;
    int score = 0;

    int userAnswerLen = userAnswer.length();
    userAnswerLen /= 2;

    QString strForSearch = userAnswer.mid(0,3);
    QString withUpper;

    int index = nameOfAnimal.indexOf(strForSearch);

    if(index == -1)
    {
        withUpper = strForSearch.left(1).toUpper() + strForSearch.mid(1);
        index = nameOfAnimal.indexOf(withUpper);
    }

    if(index != -1)
    {
        for(auto &x : userAnswer)
        {
            if(x == nameOfAnimal.at(index))
            {
                score++;
                index++;
            }
        }
    }

    if(score >= userAnswerLen && userAnswer != "")
        { verdict = 1;}

    qDebug() << nameOfAnimal<< " " << userAnswer;

    return verdict;
}

void ImageParser::getData(QNetworkReply *reply)
{
    imgSrcVec.clear();


    if(reply->error() == QNetworkReply::NoError)
    {
        QString HTMLres = QString(reply->readAll());
        QStringList imgList = HTMLres.split("one-third");
        QString line;
        QString nameOfUrl;


        unsigned int size = imgList.length();

        int startIndex = 0; //propose i can`t difene it like unsigned,
        int lastIndex = 0;  // if indexof() func return -1 this vars have to be -1

        for(size_t i = 0; i < size; i++)
        {
            line = imgList[i];

            if(HTMLres.contains("one-third"))
            {
                startIndex = line.indexOf("src=\"");
                lastIndex = line.indexOf("\"",startIndex + 5);

                imgUrl = line.mid(startIndex + 5, lastIndex - startIndex - 5);


                imgSrcVec.append(imgUrl);
            }
        }


    }else
        qDebug() << reply->errorString();



    reply->deleteLater();
}

