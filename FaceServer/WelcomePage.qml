import QtQuick 2.0

Item {
    signal initOver();
    property bool massageConnect: false;
    property bool faceConnect: false;
    function initializeOverCheck()
    {
        console.log(massageConnect+"  "+faceConnect);
        if(massageConnect&&faceConnect)
        {
            initOver();
            sendUdpNews.stop();
        }
    }

    Timer{
        id:sendUdpNews;
        interval: 1000;
        repeat: true
        running: true;
        onTriggered: {
//            console.log(brocatNewStr.text);
            lanMangeServer.broadcastMessage("123456AT+LKSTT");
            lanMangeServer.iAmHere();
        }
    }
    Image {
//        id: name
//        source: "qrc:/image/source/Image/facebackground.png"
        source:"qrc:/image/source/Image/welcomebackg.png";
        fillMode: Image.PreserveAspectCrop;
    }
    /*
    Image {
        source: "qrc:/image/source/Image/welcometext.png"
        anchors.horizontalCenter: parent.horizontalCenter;
        y:parent.height/7
    }
    Image {
        source: "qrc:/image/source/Image/initing.png"
        anchors.horizontalCenter: parent.horizontalCenter;
        y:parent.height*4/7;
    }
    */
    MouseArea{
        anchors.fill: parent
        onClicked: {
            initOver();
        }
    }

}
