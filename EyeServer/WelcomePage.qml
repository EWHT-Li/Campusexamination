import QtQuick 2.5
import QtQuick.Window 2.2

Item {
    id: name
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    property alias qiang: name;
    signal initializeOver();
//    void fromMassage(QString massageStr);
    property bool massageConnect: false;
    property bool kinectConnect: false;
    property bool faceConnect: false;
//    property int connectTime: 0;//连接数

    function initializeOverCheck()
    {
        console.log("massageConnect："+massageConnect);
        console.log("kinectConnect："+kinectConnect);
        console.log("faceConnect："+faceConnect);
        if(massageConnect&&kinectConnect)
        {
            if(faceConnect)
            {
                initializeOver();
                sendUdpNews.stop();
                liAudio.setMusicSource("assets:/openmusic.mp3");
                liAudio.rootPlayerPlay();
                loadingImageAnimator.stop();
            }
        }
    }

    Connections{
        target: lanMangeServer
        onFromMassage:{
//            if(connectTime<3)//测试一个端时可设为1;
//            {
                if(massageStr==="stm32_init_complete#!")
                {
                    massageConnect=true;
                    initializeOverCheck();
                }

//            }
//            else
//            {
//                sendUdpNews.stop();
//            }

        }

        onFromFace:{
            if(faceStr==="face_init_success#!")
            {
                faceConnect=true;
                initializeOverCheck();
            }
        }

        onFromKinect:{
            if(kinectStr==="kinect_init_success#!")
            {
                kinectConnect=true;
                initializeOverCheck();
            }
        }


    }

    Flickable{
        id:firstPage
        width: parent.width
        height: parent.height
        contentHeight: height
        contentWidth:parent.width*4/3;
        contentX:firstPage.width/3
        rebound: Transition {
            NumberAnimation {
                properties: "x,y"
                duration: 1000
                easing.type: Easing.OutBounce
            }
        }
        Behavior on contentX { NumberAnimation{ duration:500} }
        clip: true;
        Item {
            id: setPage
            width: firstPage.width/3;
            height: firstPage.height;
            anchors.left: parent.left;
            anchors.top:parent.top;
            clip: true;
            Image {
                anchors.fill: parent
                source: "qrc:/image/source/image/setBackground.jpg"
            }
            Item {
                id: setPagetitle
                anchors.top:parent.top;
                anchors.left: parent.left
                width: parent.width
                height: parent.height/10
                clip:true;
                Text {
                    text: "初始化信息配置"
                    font.pointSize: 24;
                    font.bold: true
                    font.weight :Font.Black;
                    anchors.centerIn: parent;
                }
            }
            Column{
                anchors.top:setPagetitle.bottom;
                anchors.horizontalCenter:  setPagetitle.horizontalCenter;
                width: setPage.width-10;
                height: setPage.height
                spacing: 5;
                clip: true
                Text {
                    id: udpBrocatAddressText
                    text: "UDP广播地址：";
                    font.pointSize: 20;
                }
                Rectangle{
                    width: setPage.width-10;
                    height: setPage.height/15;
                    anchors.left: parent.left
                    color: "#80ffffff"
                    TextInput{
                        //                                inputMask :"000.000.000.000"
                        font.pointSize: 20;
                        anchors.fill: parent
                    }
                }
                //                    }
                Text {
                    id: udpBrocatPortText
                    text: "UDP广播端口："
                    font.pointSize: 20;
                }
                Rectangle{
                    width: setPage.width-10
                    height: setPage.height/15;
                    anchors.left: parent.left
                    color: "#80ffffff";
                    TextInput{
                        font.pointSize: 20;
                        anchors.fill: parent
                    }
                }
                Text {
                    id: udpBrocatNewsText
                    text: "广播信息："
                    font.pointSize: 20;
                }
                Rectangle{
                    width: setPage.width-10
                    height: setPage.height/15;
                    anchors.left: parent.left
                    color: "#80ffffff"
                    TextInput{
                        id:brocatNewStr;
                        text:"123456AT+LKSTT";
                        font.pointSize: 20;
                        anchors.fill: parent
                    }
                }
            }
            Rectangle{
                width: parent.width/3
                height: parent.height/10;
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10;
                radius: width/10;
                Text {
                    text: "设置完毕";
                    font.pointSize: 20;
                    anchors.centerIn: parent;
                }
                Timer{
                    id:sendUdpNews;
                    interval: 1000;
                    repeat: true
                    running: true;
                    onTriggered: {
//                        console.log(brocatNewStr.text);
                        lanMangeServer.iAmHere();
                    }
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        lanMangeServer.sendTcpNews(qmlShareDate.massageName,brocatNewStr.text);
                    }
                }
            }

        }
        Item {
            id:welcomePage
            anchors.left: setPage.right;
            anchors.top:parent.top
            width: firstPage.width
            height: firstPage.height
            clip:true;
            Image {
                anchors.fill: parent;
                fillMode: Image.PreserveAspectCrop;
                source: "qrc:/image/source/image/eyebackground.png";
                clip: true;
            }
            Image {
                id: welcometext
                source: "qrc:/image/source/image/welcometext.png"
                anchors.horizontalCenter: parent.horizontalCenter;
                anchors.top:parent.top;
                anchors.topMargin: 3;
            }
//            Item {
//                id: welcome
//                width: parent.width
//                height: parent.height/3;
//                anchors.left: parent.left
//                anchors.leftMargin: 50;
//                anchors.verticalCenter: parent.verticalCenter;
//                Text {

//                    text: "欢迎使用"
//                    font.pointSize: 100;
//                    font.bold: true
//                    font.letterSpacing :parent.width/9;
//                    font.weight :Font.Black;
//                    style: Text.Outline;
//                    styleColor:"black";
//                    anchors.centerIn: parent

//                }
//            }
//            Rectangle{
//                width: parent.width/5
//                height: parent.height/11
//                radius: width/30;
//                anchors.top: welcome.bottom
//                anchors.topMargin: height
//                anchors.horizontalCenter: parent.horizontalCenter;
//                color: "#80ffffff"
//                Text {
//                    text:"开始使用";
//                    font.pointSize: 30;
//                    anchors.centerIn: parent
//                }
//                MouseArea{
//                    anchors.fill: parent
//                    onClicked: {
//                        loadingImageAnimator.stop();
//                        initializeOver();
//                    }
//                }
//            }
            Item {
                id: loadingText
                visible: false;
                x:parent.width*7/10;
                anchors.top:welcometext.bottom;
                anchors.topMargin: 5;
                width: parent.width/5
                height: parent.height/10
                clip: true;
                Text {
                    text: "硬件初始化中。。。"
                    font.pointSize: 20;
                    font.bold: true;
                    anchors.fill: parent
                }
            }

            Item {
                id: massageCon
                visible: false;
                anchors.bottom: loadingText.top
                anchors.bottomMargin: 3;
                anchors.right: parent.right
                anchors.rightMargin: 15;
                width: parent.width/5
                height: parent.height/10
                clip: true;
                Text {
                    text: "硬件初始化中。。。"
                    font.pointSize: 20;
                    font.bold: true;
                    anchors.fill: parent
                }
            }

            Item {
                id: loadingImage
                width: parent.height/10;//parent.width/20;
                height: parent.height/10;//width;
                anchors.verticalCenter: loadingText.verticalCenter;
                anchors.right: loadingText.left
                anchors.rightMargin: 15;
                visible: false
                Image {
                    source: "qrc:/image/source/image/loading.png";
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectCrop;
                }
            }
            RotationAnimator{
                id:loadingImageAnimator
                target: loadingImage
                running: true;
                from: 0;
                to:360
                duration: 1000
                loops: Animation.Infinite
                onStarted: {
                    loadingImage.visible=true;
                    loadingText.visible=true;
                }
                onStopped: {
                    loadingImage.visible=false;
                    loadingText.visible=false;
                }
            }
        }
    }
}
