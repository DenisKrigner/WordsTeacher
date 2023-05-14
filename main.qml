import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import ImagePars 1.0

Window {
    id: root
    width: 640
    height: 480
    visible: true
    title: qsTr("Word Teacher")
    color: "green"

     property string nameOfAnimal: ""

    Keys.onPressed:{
        if(event.key === Qt.Key_Enter)
            _answerBut.clicked();
    }

     Button{
        id: _startBtn
        anchors.centerIn: parent
        width: parent.width / 4
        height: parent.height / 7

        background: Rectangle{
            id: _startButBg
            color: "lightblue"
            radius: 16
        }

        Text{
            anchors.centerIn: _startBtn
            text: "start"
            color: "green"
                font{
                    pointSize: Math.min(parent.width, parent.height) / 3
                    bold: true
                }
        }

        onClicked: {
            var temp = _imageParser.sendImgUrls();
            console.log(temp);

            _mainGameImg.source = temp

            _mainGameImg.visible = true
            _startBtn.visible = false
            _textInputRect.visible = true
            _answerBut.visible = true

            _textInput.focus = true
            _textInput.text = ""

            _questrectAnim.start()
        }

      }


    ImageParser{
        id: _imageParser
        onSendNameOfAnimal:{
            console.log("Recive from C++ " + str);
            nameOfAnimal = str;
        }
    }

    Image{
        id: _mainGameImg
        anchors.fill: parent
//        anchors.topMargin: 90
//        anchors.bottomMargin: 90
//        anchors.leftMargin: 25
//        anchors.rightMargin: 25
        visible: false
        Column{
            anchors.centerIn: parent
            visible: _mainGameImg.status == Image.Loading ?
                         true : false
            BusyIndicator{}
        }
    }
RowLayout{
    id: _rowLayout
 width: parent.width / 2
 height: parent.height / 9
 anchors.bottom: parent.bottom
 anchors.bottomMargin: 7
 anchors.horizontalCenter: parent.horizontalCenter

    Rectangle{
        id: _textInputRect

        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
        Layout.maximumWidth: _rowLayout.width*2/3

        radius: 16
        border.color: "black"
        border.width: 2

        visible: false


        TextInput{
            id: _textInput
            anchors.centerIn: _textInputRect
            width: _textInputRect * (2 / 3)
            maximumLength: 13
            color: "red"
            font{
                pointSize: Math.min(parent.width, parent.height) / 4
                bold: true
            }
            onAccepted: {
                _answerBut.clicked();
            }
         }

       }
    Button{
        id: _answerBut
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
        Layout.maximumWidth: parent.width/3

        visible: false

        Text{
            anchors.centerIn: _answerBut
            text: "->"
            color: "green"
                font{
                    pointSize: Math.min(parent.width, parent.height) / 2
                    bold: true
                }
        }
        background: Rectangle{
            id: _answerButBg
            color: "lightblue"
            radius: 16
        }

        onClicked: {
            var verdict = _imageParser.checkAnswer(nameOfAnimal,_textInput.text)
            console.log("From QML " + verdict)
            if(verdict === 1)
            {
                _victoryAnim.start();
            }

                  _startBtn.clicked()
        }
    }
}

Rectangle{
    id: _qustTextRect
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    width: parent.width / 2.5
    height: parent.height / 9
    anchors.topMargin: 25
    opacity: 0

    radius: 16
    border.color: "black"
    border.width: 2


    Text{
        text: "What animal is it ?"
        anchors.centerIn: _qustTextRect
        color: "red"
        font{
            pointSize: Math.min(parent.width, parent.height) / 4
            bold: true
        }
    }
    SequentialAnimation{
        id: _questrectAnim
    PropertyAnimation{

        target: _qustTextRect
        property: "opacity"
        to: 1
        duration: 1500
    }
    PropertyAnimation{
        target: _qustTextRect
        property: "opacity"
        to: 0
        duration: 4000
    }
    }
   }

    SequentialAnimation{
        id: _victoryAnim


        PropertyAnimation{
            target: _victoryRect
            property: "opacity"
            to: 1
            duration: 1000
        }
        PropertyAnimation{
            target: _victoryRect
            property: "opacity"
            to: 0
            duration: 3000
        }

    }

    Rectangle{
        id: _victoryRect
        anchors.fill: parent
        opacity: 0

        Text{
            text: "You are right"
            anchors.centerIn: parent
            color: "red"
            font{
                pointSize: Math.min(parent.width, parent.height) / 20
                bold: true
            }
        }
    }
}

