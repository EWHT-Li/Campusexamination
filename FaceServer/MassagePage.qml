import QtQuick 2.0

Item {

    property int minute: 0;
    property int second: 30;
    signal massageOver();
    property alias leftTime: leftface;
    property alias rightTime: rightface;
    property bool solidInit: false;
    property int pageIndex: 0;
    property alias aResidueTimePage: residueTimePage;

    function restart()
    {
        minute=0;
        second=30;
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
//            return true;
        }
        else
        {
            second=0;
        }

//        if(second===60)
//        {
//            if(addminute())
//            {
//                second=0;
//                return true;
//            }

//        }
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
        setTimePage.visible=false;
        residueTimePage.visible=false;
        homingPage.visible=false;
        initPage.visible=false;
        headhere.visible=false;
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
        lanMangeServer.sendTcpNewstoFace(qmlShareDate.massageName,"#mode1_massage_over!");
        allVisible(3);
    }

    function willOver2()
    {
        allVisible(3);
    }

    Image {
//        id: name
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
//            id: name
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
            source: "qrc:/image/source/Image/massagesettime.png";
            anchors.verticalCenter: parent.verticalCenter;
            anchors.left: parent.left;
//            anchors.leftMargin: 140;
            anchors.leftMargin: 110;
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
                text:(second<10?"0":"")+second ;
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
                        decreaseminute();
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
                        decreasesecond();
                    }
                }
            }
        }

        Image {
            source: "qrc:/image/source/Image/sideText.png"
            anchors.verticalCenter: valuedisplayarea2.verticalCenter;
            anchors.left: valuedisplayarea2.right;
            anchors.leftMargin: 30;
        }

        Row{
            y:parent.height*6/7;
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: parent.width*2/5;

            Image {
                source: "qrc:/image/source/Image/confirmButton.png"
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        residueTimePage.leftminute=minute;
                        residueTimePage.rightminute=minute;
                        residueTimePage.leftsecond=second;
                        residueTimePage.rightsecond=second;

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
                        massageOver();
                        lanMangeServer.sendTcpNewstoFace(qmlShareDate.massageName,"#mode1_massage_over!");
                        console.log("6");
                    }
                }
            }
        }
    }

    Timer{
        id:leftface
        interval: 1000;
        running: false;
        repeat: true;
        onTriggered: {
            residueTimePage.decreaseleftsecond();
        }
    }

    Timer{
        id:rightface
        interval: 1000;
        running: false;
        repeat: true;
        onTriggered: {
            residueTimePage.decreaserightsecond();
            if(residueTimePage.rightminute===0)
            {
                if(residueTimePage.rightsecond===3)
                {
                    liAudio.setMusicSource("assets:/massagewillover.mp3");
                    liAudio.rootPlayerPlay();
                }
                else if(residueTimePage.rightsecond===0)
                {
                    residueTimePage.rightMassageOver();
                }
            }
        }
    }

    Item {
        id: residueTimePage
        width: parent.width
        height: parent.height
        visible: false;
        property int leftminute: 1;
        property int leftsecond: 0;
        property int rightminute: 1;
        property int rightsecond: 0;
        signal leftMassageOver();
        signal rightMassageOver();
        function residueClose()
        {
            console.log("断时间");
            leftface.stop();
            rightface.stop();
        }

        onLeftMassageOver: {
            leftface.stop();
            liAudio.setMusicSource("assets:/leftmasssageclose.mp3");
            liAudio.rootPlayerPlay();
            lanMangeServer.sendTcpNewstoFace(qmlShareDate.massageName,"#massage_left_over!");//massage5
        }
        onRightMassageOver: {
            rightface.stop();
            liAudio.setMusicSource("assets:/massageover.mp3");
            liAudio.rootPlayerPlay();
            willOver();
//            lanMangeServer.sendTcpNews(qmlShareDate.massageName,"#massage_right_over!");//massage8
//            allVisible(3);
        }

        function decreaseleftminute()
        {
            if(leftminute>0)
            {
                leftminute--;
                return true;
            }
            else
            {
                return false;
            }
        }
        function decreaseleftsecond()
        {
            if(leftsecond===0)
            {
                if(decreaseleftminute())
                {
                    leftsecond=59;
                    return true;
                }
                else
                {
                    leftMassageOver();
                }
            }
            if(leftsecond>0)
            {
                leftsecond--;
                return true;
            }
        }
        ///////////////////////////////////////////////////
        function decreaserightminute()
        {
            if(rightminute>0)
            {
                rightminute--;
                return true;
            }
            else
            {
                return false;
            }
        }
        function decreaserightsecond()
        {
            if(rightsecond===0)
            {
                if(decreaserightminute())
                {
                    rightsecond=59;
                    return true;
                }
                else
                {
                    rightMassageOver();
                }
            }
            if(rightsecond>0)
            {
                rightsecond--;
                return true;
            }
        }
        Image {
//            id: name
            x:60;
            y:55
            source: "qrc:/image/source/Image/massagesettime.png"
        }
        Image {
            id: leftresiduetime
            source: "qrc:/image/source/Image/leftresiduetime.png";
            anchors.bottom: parent.verticalCenter;
            anchors.bottomMargin: 5;
            x: 80;
        }
        Image {
            id: rightresiduetime
            source: "qrc:/image/source/Image/rightresiduetime.png"
            anchors.top: parent.verticalCenter;
            anchors.topMargin: 5;
            x:80;
        }

        Text {
            id: leftresiduetimetext
            text: (residueTimePage.leftminute<10?"0":"")+residueTimePage.leftminute+":"+(residueTimePage.leftsecond<10?"0":"")+residueTimePage.leftsecond ;
            font.pointSize: 48;
            font.bold: true;
            anchors.verticalCenter: leftresiduetime.verticalCenter;
            anchors.left: leftresiduetime.right
            anchors.leftMargin: 60;
        }

        Text {
            id: rightresiduetimetext
            text: (residueTimePage.rightminute<10?"0":"")+residueTimePage.rightminute+":"+(residueTimePage.rightsecond<10?"0":"")+residueTimePage.rightsecond;
            font.pointSize: 48;
            font.bold: true;
            anchors.verticalCenter: rightresiduetime.verticalCenter;
            anchors.left: rightresiduetime.right
            anchors.leftMargin: 60;
        }

//        Image {
//            anchors.horizontalCenter: parent.horizontalCenter;
//            source: "qrc:/image/source/Image/cancelButton.png";
//            y:parent.height*6/7;
//            MouseArea{
//                anchors.fill: parent
//                onClicked: {
//                    willOver();
//                    residueTimePage.residueClose();
//                    console.log("0");
//                }
//            }
//        }
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
                willOver();
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
//                    lanMangeServer.sendTcpNews(qmlShareDate.massageName,"#mode1_massage_over!");//emassage1
//                    massageOver();
                    willOver();
                    console.log("6");
                }
            }
        }
    }
}
