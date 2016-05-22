import QtQuick 2.0

Item {

    property int treetozerotime: 3;
    signal checkBlackOver();
    property bool solidInit: false;
    property int pageIndex: 0;
    property int textindex: 0;
    property bool want: true;

    function randomText()
    {
        textindex=Math.floor(Math.random()*4);
        console.log("文本变化"+textindex);
        switch(textindex)
        {
        case 0:
            resultText.text="日常建议：
    第一：纠正作息时间，保持充足的睡眠及正确的仰卧睡姿。
    第二：养成良好的饮食习惯。
    第三：常做眼周的保健按摩和护理";
            break;
        case 1:
            resultText.text="日常建议：
    第一：纠正作息时间，保持充足的睡眠及正确的仰卧睡姿
    第二：养成良好的饮食习惯
    第三：采用热敷的方式促进眼周血液循环";
            break;
        case 2:
            resultText.text="日常建议：
            第一：常做眼周的保健按摩和护理。
            第二：平时应用眼霜、眼膜保养，坚持一段时间会有改善。
            第三：采用热敷的方式促进眼周血液循环";
            break;
        case 3:
            resultText.text="日常建议：
            第一：养成良好的饮食习惯。
            第二：纠正作息时间，保持充足的睡眠及正确的仰卧睡姿。
            第三：采用热敷的方式促进眼周血液循环";
            break;
        default:
            resultText.text="日常建议：
    第一：纠正作息时间，保持充足的睡眠及正确的仰卧睡姿。
    第三：养成良好的饮食习惯。
    第四：常做眼周的保健按摩和护理。
    第五：平时应用眼霜、眼膜保养，坚持一段时间会有改善。
    第六：采用热敷的方式促进眼周血液循环";
            break;
        }
    }

    function playswitch()
    {

        switch(textindex)
        {
        case 0:
            liAudio.setMusicSource("assets:/advise0.mp3");
            liAudio.rootPlayerPlay();
            break;
        case 1:
            liAudio.setMusicSource("assets:/advise1.mp3");
            liAudio.rootPlayerPlay();
            break;
        case 2:
            liAudio.setMusicSource("assets:/advise2.mp3");
            liAudio.rootPlayerPlay();
            break;
        case 3:
            liAudio.setMusicSource("assets:/advise3.mp3");
            liAudio.rootPlayerPlay();
            break;
        default:
            liAudio.setMusicSource("assets:/advise.mp3");
            liAudio.rootPlayerPlay();
            break;
        }
    }

    Connections{
        target: lanMangeServer
        onReceiveFileOver:{
            //加载收到的图片并显示。。。
            if(want)
            {
                console.log("收到照片");
//                faceImage.source="";
                faceImage.source="file:////storage/sdcard0/data/detect.jpg";
                lanMangeServer.sendTcpNewstoFace(qmlShareDate.massageName,"#photo_light_close!");//关灯
                liAudio.setMusicSource   ("assets:/checkover.mp3");
                liAudio.rootPlayerPlay();
                allVisible(5);
                advisetime.start();
            }
        }
    }

    Timer{
        id:advisetime
        interval: 1500
        running: false;
        repeat: false;
        onTriggered: {
            playswitch();
            //            liAudio.setMusicSource("assets:/advise.mp3");
            //            liAudio.rootPlayerPlay();
        }
    }

    function restart()
    {
        randomText();
        treetozerotime=3;
        faceImage.source="";
        allVisible(3);
        lanMangeServer.sendTcpNewstoFace(qmlShareDate.massageName,"#mode3_photo_ready!");
        //        liAudio.setMusicSource("assets:/headHere.mp3")
        //        liAudio.rootPlayerPlay();
        want=true;
    }
    function allVisible(index)
    {
        resultPage.visible=false;
        headhere.visible=false;
        initPage.visible=false;
        checkingpage.visible=false;
        resultPage.visible=false;
        homingPage.visible=false;
        switch(index)
        {
        case 1:
            headhere.visible=true;
            pageIndex=1;
            break;
        case 2:
            resultPage.visible=true;
            pageIndex=2;
            break;
        case 3:
            initPage.visible=true;
            pageIndex=3
            break;
        case 4:
            checkingpage.visible=true;
            pageIndex=4;
            break;
        case 5:
            resultPage.visible=true;
            pageIndex=5;
            break;
        case 6:
            homingPage.visible=true;
            pageIndex=6;
            break;
        default:
            break;
        }
    }

    function toHeadhere()
    {
        liAudio.setMusicSource("assets:/headHere.mp3");
        liAudio.rootPlayerPlay();
        allVisible(1);
    }

    function upDataFace()
    {
        faceImage.source="";
        faceImage.source="file:////storage/sdcard0/data/detect.jpg";
    }

    function willOver()
    {
        lanMangeServer.sendTcpNewstoFace(qmlShareDate.massageName,"#photo_over_complete!");
        allVisible(6);
    }

    Image {
        source: "qrc:/image/source/Image/facebackground.png"
        fillMode: Image.PreserveAspectCrop;
        anchors.fill: parent;
    }

    Item {
        id: headhere
        width: parent.width;
        height: parent.height;
        visible: false;
        Image {
            source: "qrc:/image/source/Image/headhere.png";
            anchors.centerIn: parent;
        }
        Image {
            anchors.horizontalCenter: parent.horizontalCenter;
            source: "qrc:/image/source/Image/cancelButton.png";
            y:parent.height*6/7;
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    //                    checkBlackOver();
                }
            }
        }
    }

    Item {
        id: checkingpage
        width: parent.width;
        height: parent.height;
        visible: false;
        Image {
            source: "qrc:/image/source/Image/checking.png";
            anchors.centerIn: parent;
        }
        Image {
            anchors.horizontalCenter: parent.horizontalCenter;
            source: "qrc:/image/source/Image/cancelButton.png";
            y:parent.height*6/7;
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    //                    checkBlackOver();
                }
            }
        }
    }
    Item {
        id: resultPage
        anchors.fill: parent
        visible: false;
        Image {
            id: faceImage
            //        source: "";
            cache: false;
            width: parent.width/2-20;
            height: parent.height/2;
            anchors.margins: 10;
            anchors.left: parent.left;
            anchors.top: parent.top;
        }

        Item {
            width: (1/2)*parent.width-10;
            height:parent.height;
            anchors.top:parent.top;
            anchors.right: parent.right;
            anchors.margins: 10;
            clip:true;
            Flickable {
                id: flickable
                width: parent.width;
                height:parent.height*6/7;
                contentWidth:parent.width;
                contentHeight:resultText.contentWidth ;
                onMovementStarted: {
                    if(resultText.contentHeight>parent.height){
                        scrollbar.visible=true;
                    }
                }
                onMovementEnded: {
                    scrollbar.visible=false;
                }

                Text {
                    id: resultText
                    color: "black";
                    wrapMode:Text.Wrap
                    width: parent.width
                    text: "日常建议：
    第一：纠正作息时间，保持充足的睡眠及正确的仰卧睡姿。
    第三：养成良好的饮食习惯。
    第四：常做眼周的保健按摩和护理。
    第五：平时应用眼霜、眼膜保养，坚持一段时间会有改善。
    第六：采用热敷的方式促进眼周血液循环";//liStringFile.returnTextAllStr("assets:/advise.txt")";
                }
            }

            Rectangle {
                id: scrollbar
                visible:false;
                anchors.right: flickable.right
                y: flickable.visibleArea.yPosition * flickable.height
                width: 5
                height: flickable.visibleArea.heightRatio * flickable.height
                color: "white"
            }
        }

        Image {
            anchors.horizontalCenter: parent.horizontalCenter;
            source: "qrc:/image/source/Image/cancelButton.png";
            y:parent.height*6/7;
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    willOver();
                }
            }
        }
    }

    Item {
        id: initPage
        width: parent.width
        height: parent.height;
        visible: false;
        Image {
            source: "qrc:/image/source/Image/initialing.png"
            anchors.centerIn: parent
        }
    }

    Item {
        id: homingPage
        width: parent.width;
        height: parent.height;
        visible: false;
        Image {
            source: "qrc:/image/source/Image/homing.png";
            anchors.centerIn: parent;
        }
        MouseArea{
            anchors.fill: parent;
            onClicked: {
                //                willOver();
            }
        }
    }
}
