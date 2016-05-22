import QtQuick 2.0

Item {
    signal saunaPageOver();
    property int minute: 1;
    property int second: 0;
    property bool solidInit: false;
    property int pageIndex: 0;
    property alias residuetime: residueTime;
    function restart()
    {
        minute=1;
        second=0;
        solidInit=false;
    }

    function  addminute()
    {
        if(minute<59)
        {
            minute++;
        }
        else
        {
            minute=0;
        }
    }
    function decreaseminute()
    {
        if(minute>0)
        {
            minute--;
            return true;
        }
        else
        {
            minute=59;
        }
    }
    function addsecond()
    {
        if(second<59)
        {
            second++
        }
        else
        {
            second=0;
        }
    }
    function decreasesecond()
    {
        if(second===0)
        {
            second=59;
            return true;
        }
        if(second>0)
        {
            second--;
            return true;
        }
    }

    function allVisible(index)
    {
        pageIndex=index;
        initPage.visible=false;
        setTimePage.visible=false;
        residueTimePage.visible=false;
        headhere.visible=false;
        homingPage.visible=false;
        switch(index)
        {
        case 1:
            setTimePage.visible=true;
            break;
        case 2:
            residueTimePage.visible=true;
            break;
        case 3:
            homingPage.visible=true;
            break;
        case 4:
            initPage.visible=true;
            break;
        case 5:
            headhere.visible=true;
            break;
        default:
            break;
        }
    }

    function toHeadhere()
    {
        liAudio.setMusicSource("assets:/headHere.mp3");
        liAudio.rootPlayerPlay();
        allVisible(5);
    }

    function willOver()
    {
        lanMangeServer.sendTcpNewstoFace(qmlShareDate.massageName,"#vapour_over!");
        allVisible(3);
    }
    Image {
        anchors.fill: parent
        source: "qrc:/image/source/Image/facebackground.png"
        fillMode: Image.PreserveAspectCrop;
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
        MouseArea{
            anchors.fill: parent;
            onClicked: {
                allVisible(1);
            }
        }
    }

    Item {
        id: setTimePage
        anchors.fill: parent
        visible: false;
        Image {
            id: setTimeText
//            source: "qrc:/image/source/Image/setTimeText.png"
            source: "qrc:/image/source/Image/saunasetTime.png";
            anchors.verticalCenter: parent.verticalCenter;
            anchors.left: parent.left;
            anchors.leftMargin: 140                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          ;
        }
        Image {
            id: valuedisplayarea1
            width: sourceSize.width
            height: sourceSize.height
            source: "qrc:/image/source/Image/valuedisplayarea.png"
            anchors.verticalCenter: setTimeText.verticalCenter;
            anchors.left: setTimeText.right;
            anchors.leftMargin: 20;
            Text {
//                id: name
                text: (minute<10?"0":"")+minute;
                font.pointSize: 24;
                color: "#e2a346";
                anchors.centerIn: parent;
            }
        }

        Image {
            id: valuedisplayarea2
            width: sourceSize.width
            height: sourceSize.height
            source: "qrc:/image/source/Image/valuedisplayarea.png"
            anchors.verticalCenter: valuedisplayarea1.verticalCenter;
            anchors.left: valuedisplayarea1.right;
            anchors.leftMargin: 10;
            Text {
//                id: name
                text: (second<10?"0":"")+second ;
                font.pointSize: 24;
                color: "#e2a346";
                anchors.centerIn: parent;
            }
        }

        Image {
            id: up1
            width: sourceSize.width
            height: sourceSize.height
            source: "qrc:/image/source/Image/updownButton.png"
            anchors.horizontalCenter: valuedisplayarea1.horizontalCenter;
            anchors.bottom: valuedisplayarea1.top;
            anchors.bottomMargin: 3;
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    addminute();
                    console.log("1");
                }
                onPressed: {
                    up1timer.start();
                }
                onExited: {
                    up1timer.stop();
                }

                Timer{
                    id:up1timer
                    interval: 200
                    repeat: true;
                    running: false;
                    onTriggered: {
                        addminute();
                    }
                }
            }
        }

        Image {
            id: up2
            width: sourceSize.width
            height: sourceSize.height
            source: "qrc:/image/source/Image/updownButton.png"
            anchors.horizontalCenter: valuedisplayarea2.horizontalCenter;
            anchors.bottom: valuedisplayarea2.top;
            anchors.bottomMargin: 3;
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    addsecond();
                    console.log("2");
                }
                onPressed: {
                    up2timer.start();
                }
                onExited: {
                    up2timer.stop();
                }

                Timer{
                    id:up2timer
                    interval: 200
                    repeat: true;
                    running: false;
                    onTriggered: {
                        addsecond();
                    }
                }
            }
        }

        Image {
            id: down1
            width: sourceSize.width
            height: sourceSize.height
            source: "qrc:/image/source/Image/updownButton.png"
            anchors.horizontalCenter: valuedisplayarea1.horizontalCenter;
            anchors.top: valuedisplayarea1.bottom;
            anchors.topMargin: 3;
            rotation: 180;
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    decreaseminute();
                    console.log("3");
                }
                onPressed: {
                    decrease1.start();
                }
                onExited: {
                    decrease1.stop();
                }

                Timer{
                    id:decrease1
                    interval: 200
                    repeat: true;
                    running: false;
                    onTriggered: {
                        addsecond();
                    }
                }
            }
        }

        Image {
            id: down2
            width: sourceSize.width
            height: sourceSize.height
            source: "qrc:/image/source/Image/updownButton.png"
            anchors.horizontalCenter: valuedisplayarea2.horizontalCenter;
            anchors.top: valuedisplayarea2.bottom;
            anchors.topMargin: 3;
            rotation: 180;
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    decreasesecond();
                    console.log("4");
                }
                onPressed: {
                    decrease2.start();
                }
                onExited: {
                    decrease2.stop();
                }

                Timer{
                    id:decrease2
                    interval: 200
                    repeat: true;
                    running: false;
                    onTriggered: {
                        addsecond();
                    }
                }
            }
        }

        Row{
            y:parent.height*6/7;

            anchors.horizontalCenter: parent.horizontalCenter
            spacing: parent.width*2/5;

            Image {
//                id: name
                source: "qrc:/image/source/Image/confirmButton.png"
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        residueTimePage.residueminute=minute;
                        residueTimePage.residuesecond=second;
                        if(solidInit)
                        {
                            toHeadhere();
                        }
                        else
                        {
                            allVisible(4);
                        }
                        console.log("5");
                    }
                }
            }

            Image {
//                id: name
                source: "qrc:/image/source/Image/cancelButton.png"
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                         lanMangeServer.sendTcpNewstoFace(qmlShareDate.massageName,"#vapour_over!");//emassage1
                        saunaPageOver();
                        console.log("6");
                    }
                }
            }
        }
    }

    Timer{
        id:residueTime
        interval: 1000;
        running: false;
        repeat: true;
        onTriggered: {
            residueTimePage.decreaseresiduesecond();
            if(residueTimePage.residueminute===0)
            {
                if(residueTimePage.residuesecond===3)
                {
                    liAudio.setMusicSource("assets:/saunawillclose.mp3");
                    liAudio.rootPlayerPlay();
                }
                else if(residueTimePage.residuesecond===0)
                {
                    residueTimePage.residueOver();
                }
            }
        }
    }

    Item {
        id: residueTimePage
        width: parent.width
        height: parent.height
        visible: false;
        property int residueminute: 1;
        property int residuesecond: 0;
        signal residueOver();
        onResidueOver: {
            residueTime.stop();
            liAudio.setMusicSource("assets:/saunaover.mp3");
            liAudio.rootPlayerPlay();
//            lanMangeServer.sendTcpNews(qmlShareDate.massageName,"#vapour_over!");
//            saunaPageOver();
            willOver();
        }

        function decreaseresidueminute()
        {
            if(residueminute>0)
            {
                residueminute--;
                return true;
            }
            else
            {
                return false;
            }
        }
        function decreaseresiduesecond()
        {
            if(residuesecond===0)
            {
                if(decreaseresidueminute())
                {
                    residuesecond=59;
                    return true;
                }
                else
                {
                    residueOver();
                }
            }
            if(residuesecond>0)
            {
                residuesecond--;
                return true;
            }
        }
        Image {
            id: saunaresiduetime
            source: "qrc:/image/source/Image/saunaresiduetime.png";
            anchors.verticalCenter: parent.verticalCenter;
            x: 80;
        }

        Text {
            id: saunaresiduetimetext
            text:(residueTimePage.residueminute<10?"0":"")+residueTimePage.residueminute+":"+(residueTimePage.residuesecond<10?"0":"")+residueTimePage.residuesecond;
            font.pointSize: 48;
            font.bold: true;
            anchors.verticalCenter: saunaresiduetime.verticalCenter;
            anchors.left: saunaresiduetime.right
            anchors.leftMargin: 10;
        }

        Image {
//            id: name
            anchors.horizontalCenter: parent.horizontalCenter;
            source: "qrc:/image/source/Image/cancelButton.png";
            y:parent.height*6/7;
            MouseArea{
                anchors.fill: parent
                onClicked: {
//                    lanMangeServer.sendTcpNews(qmlShareDate.massageName,"#vapour_over!");
//                    saunaPageOver();
                    residueTime.stop();
                    willOver();
                    console.log("0");
                }
            }
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

    Item {
        id: headhere
        width: parent.width;
        height: parent.height;
        visible: false;
        Image {
//            id: name
            source: "qrc:/image/source/Image/headhere.png";
            anchors.centerIn: parent;
        }
        Image {
//                id: name
            source: "qrc:/image/source/Image/cancelButton.png"
            anchors.horizontalCenter: parent.horizontalCenter;
            y:parent.height*6/7;
            MouseArea{
                anchors.fill: parent
                onClicked: {
//                    lanMangeServer.sendTcpNews(qmlShareDate.massageName,"#vapour_over!");//emassage1
//                    saunaPageOver();
                    willOver();
                    console.log("6");
                }
            }
        }
    }

}
