import QtQuick 2.5
import QtQuick.Window 2.2

Rectangle {
    visible: true

    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    property double pxPermmwidth: 5.2692
    property double pxPermmheigth: 5.649
    property var seeValue: shuzhu[seeValueindex];
    property double mathtan: Math.tan((1/60/seeValue)*Math.PI/180)*15*1000;
    property var shuzhu: new Array(0.06,0.1,0.12,0.15,0.2,0.25,0.3,0.4,0.5,0.6,0.8,1.0,1.2,1.5);
    property var shuzhu2: new Array(3.8,4.0,4.1,4.2,4.3,4.4,4.5,4.6,4.7,4.8,4.9,5.0,5.1,5.2);
    property int seeValueindex:0;
    property int rotationIndex: 0;

    property int stateSeeValueindex : -1;
    property int checkTime: 0;
    property int reallySeeValue: -1;
    property int trueTime:0;

    property int threetozooIndex: 3;

    property double leftEyeValue: -1;
    property double rightEyeValue: -1;
    property bool kinectOpen: false;

    property bool adjustState:false;

    signal checkAllOver();
    signal checkTempOver();
    signal toChart2;

//kinect信号处理器
    /*
      Kinect准备完毕：prepareOK
      打开Kinect:startKinect
   */
    Connections{
        target: lanMangeServer;
        onFromKinect:{
            console.log("Kinect"+kinectStr);

            if(kinectStr==="prepareOK")
            {
                console.log("KinectB"+"prepareOK")
                stateCheck();
                liAudio.setMusicSource("assets:/checkEyeOpen.mp3");
                liAudio.rootPlayerPlay();
                checkOPenmusic.start();
            }
            else if(kinectStr!=="kinect_init_success#!"&&kinectOpen)
            {
                handleDirection(parseInt(kinectStr));
            }
        }
    }

    Item {
        id: checkSeeOverSignal
        signal checkSeeOver();
        onCheckSeeOver: {
            console.log("over1"+leftEyeValue+reallySeeValue)
            if(leftEyeValue===-1)
            {
                console.log("over2"+leftEyeValue+reallySeeValue)
                leftEyeValue=reallySeeValue;
                stateOther()
                liAudio.setMusicSource("assets:/coverLeftEye.mp3");
                liAudio.rootPlayerPlay();
            }
            else
            {
                console.log("over3"+rightEyeValue+"   "+reallySeeValue)
                rightEyeValue=reallySeeValue;
                if(adjustState) {
                    adjustresultPage.visible=true;
                    adjustresultPage.z=1;
                }else {
                    resultPage.visible=true;
                    resultPage.z=1;
                    seeValueJSON.addData(shuzhu2[leftEyeValue],shuzhu2[rightEyeValue]);
                    checkTempOver();
                }
                kinectOpen=false;



                //有网
//                tts.getvoice("经测试，你左眼视力为"+shuzhu[leftEyeValue]+",右眼视力为"+shuzhu[rightEyeValue]);
                //断网
                if(!adjustState)
                {
                    liAudio.setMusicSource("assets:/advise.mp3");
                    liAudio.rootPlayerPlay();
                }
                else
                {
                    liAudio.setMusicSource("assets:/advise2.mp3");
                    liAudio.rootPlayerPlay();
                }

            }
        }
    }

    Connections{
        target: tts
        onOver:{
//            有网
//            if(!adjustState)
//            {
//                liAudio.setMusicSource("assets:/advise.mp3");
//                liAudio.rootPlayerPlay();
//            }
//            else
//            {
//                liAudio.setMusicSource("assets:/advise2.mp3");
//                liAudio.rootPlayerPlay();
//            }
        }
    }

    Timer{
        id:eWorldToWhite
        interval: 500;
        repeat: false;
        running: false;
        onTriggered: {
            eWorld.color="white";
        }
    }
    Timer{
        id:checkOPenmusic
        interval: 6000
        repeat: false
        running: false;
        onTriggered: {
            threetozooTimer.start();
            treetozooimage.source="qrc:/image/source/image/"+threetozooIndex+".png";
        }
    }

    Timer{
        id:threetozooTimer
        interval: 1000;
        repeat: true
        running: false
        onTriggered: {
            console.log("threeto"+threetozooIndex);
            threetozooIndex--;

            if(threetozooIndex==0)
            {
                liAudio.setMusicSource("assets:/"+threetozooIndex+".mp3");
                liAudio.rootPlayerPlay();
                treetozooimage.source="qrc:/image/source/image/"+threetozooIndex+".png";
                lanMangeServer.sendTcpNews(qmlShareDate.kinectName,""+rotationIndex);//发送视力方向
                eWorld.visible=true;
                stop();
                kinectOpen=true;
            }
            else
            {
                liAudio.setMusicSource("assets:/"+threetozooIndex+".mp3");
                liAudio.rootPlayerPlay();
                treetozooimage.source="qrc:/image/source/image/"+threetozooIndex+".png";

            }
        }
    }

    //0 1 2 3 右 下 左 上
//    property var falseTime: 0;
    //1局1胜
    //3局2胜

    function eWorldColor(bol)
    {
        if(bol)
        {
            eWorld.color="green";
            eWorldToWhite.start();
        }
        else
        {
            eWorld.color="red";
            eWorldToWhite.start();
        }
    }
    //进入页面前调用
//检测初始化
    function stateCheck()
    {
        stateSeeValueindex=-1;//检测状态，是否出错
        reallySeeValue=-1;//检测后视力值
        treetozooimage.source="qrc:/image/source/image/eWorldInit.png";
        rotationIndex=0;//旋转方向
        seeValueindex=0;//视力数组索引
        threetozooIndex=3;//3->0
        leftEyeValue=-1;//左右眼视力
        rightEyeValue=-1;
        resultPage.visible=false;
        adjustresultPage.visible=false;
        eWorld.visible=false;
        console.log("bigInit");
        kinectOpen=false;
    }
    //初始化信息发送
    function stateNewsSend()
    {
        lanMangeServer.sendTcpNews(qmlShareDate.kinectName,qmlShareDate.startKinect);
        lanMangeServer.sendTcpNews(qmlShareDate.massageName,qmlShareDate.openLaser);

    }
//测试另一只眼睛初始化
    function stateOther()
    {
        stateSeeValueindex=-1;//检测状态，是否出错
        reallySeeValue=-1;//检测后视力值
        seeValueindex=0;//视力数组索引
        console.log("smallInit");
    }

//视力索引增加
    function seeValueindexAdd()
    {
        if(seeValueindex<shuzhu.length-1)
            seeValueindex++;
    }
//视力索引减小
    function seeValueindexReduce()
    {
        if(seeValueindex>0)
            seeValueindex--;
    }
//随机旋转
    function randomRotationIndex()
    {
        rotationIndex=Math.floor(Math.random()*4);
        lanMangeServer.sendTcpNews(qmlShareDate.kinectName,""+rotationIndex);//发送视力方向
    }
//视力判断
    function ifelseDirection1(direction)
    {
        if(direction===rotationIndex)
        {
            randomRotationIndex();
            eWorldColor(true);
            return true;
        }
        else
        {
            randomRotationIndex();
            eWorldColor(false);
            return false;
        }
    }
    //新视力判断
    function ifelseDirection(bol)
    {

        if(bol)
        {
            randomRotationIndex();
            //发送方向
            eWorldColor(true);
            return true;
        }
        else
        {
            randomRotationIndex();
            //发送方向
            eWorldColor(false);
            return false;
        }
    }
//    手势处理
    function handleDirection1(direction)
    {
        console.log("方向"+direction+"  "+rotationIndex);
        if(stateSeeValueindex===0)
        {
            if(ifelseDirection(direction))
            {
                seeValueindexAdd();
            }
            else
            {
                randomRotationIndex();
                stateSeeValueindex=seeValueindex;
            }
            if(seeValueindex===shuzhu.length-1)
            {
                stateSeeValueindex=shuzhu.length-1;
            }
        }
        else
        {
            if(checkTime<3)
            {
                checkTime++;
                if(ifelseDirection(direction))
                {
                    trueTime++;
                }
            }
            else
            {
                checkTime=0;
                ifelseDirection(direction);
                if(trueTime>=2)
                {
                    trueTime=0;
                    seeValueindexAdd();
                    console.log(shuzhu.length-1);
                    console.log(seeValueindex);
                    if(seeValueindex===shuzhu.length-1)
                    {
                        reallySeeValue=seeValueindex;
                        checkSeeOverSignal.checkSeeOver();
                    }
                }
                else
                {
                    trueTime=0;
                    reallySeeValue=seeValueindex-1;
                    checkSeeOverSignal.checkSeeOver();
                }
            }
        }
    }
    //手势处理2
    function handleDirection(bol)
    {
        if(stateSeeValueindex===-1)
        {
            if(ifelseDirection(bol))
            {
                console.log("ifelse1"+bol);
                seeValueindexAdd();
            }
            else
            {
                console.log("ifelse2"+bol);
                stateSeeValueindex=seeValueindex;
            }
            if(seeValueindex===shuzhu.length-1)
            {
                console.log("ifelse3"+bol);
                stateSeeValueindex=shuzhu.length-1;
            }
        }
        else
        {
            if(checkTime<3)
            {
                console.log("ifelse4"+"checktimes"+checkTime);
                checkTime++;
                if(ifelseDirection(bol))
                {
                    console.log("ifelse5"+"trueTime"+trueTime);
                    trueTime++;
                }
            }
            else
            {
                checkTime=0;
                ifelseDirection(bol);
                console.log("ifelse6"+"trueTime"+trueTime);
                if(trueTime>=2)
                {
                    trueTime=0;
                    seeValueindexAdd();
                    console.log(shuzhu.length-1);
                    console.log(seeValueindex);
                    if(seeValueindex===shuzhu.length-1)
                    {
                        console.log("ifelse7"+"trueTime"+trueTime);
                        reallySeeValue=seeValueindex;
                        checkSeeOverSignal.checkSeeOver();
                    }
                }
                else
                {
                    console.log("ifelse8"+"trueTime"+trueTime);
                    trueTime=0;
                    reallySeeValue=seeValueindex-1;
                    if(seeValueindex===0)
                    {
                        reallySeeValue=0;
                    }
                    checkSeeOverSignal.checkSeeOver();
                }
            }
        }
    }
    Rectangle{
        id:eWorld
        visible: !treetozoo.visible;
        width: 75*pxPermmwidth;
        height: 75*pxPermmheigth
        anchors.centerIn: parent
        rotation: rotationIndex*90;
        color: "white";
        Component.onCompleted: {
            console.log(shuzhu.length);
        }

        Behavior on color{
            PropertyAnimation{
                properties: "color"
                duration: 1000;
                easing.type:  Easing.OutQuint;
            }
        }

        Rectangle{
            color: "black";
            width: mathtan*pxPermmwidth;
            height: mathtan*pxPermmheigth;
            anchors.centerIn: parent;
            Component.onCompleted: {
                console.log(mathtan);
            }
//        }
//            /*
            Rectangle{
                id:set2
                width: parent.width*4/5;
                height: parent.height/5;
                color: "black";
                anchors.verticalCenter: parent.verticalCenter;
                anchors.right: parent.right;
            }
            Rectangle{
                id:set1
                width: parent.width*4/5;
                height: parent.height/5;
                color: eWorld.color;
                anchors.bottom: set2.top;
                anchors.right: parent.right;
            }
            Rectangle{
                id:set3
                width: parent.width*4/5;
                height: parent.height/5;
                color: eWorld.color;
                anchors.top:set2.bottom;
                anchors.right: parent.right;
            }
        }
//        */
    }
    Rectangle{
        radius: 10;
        visible: eWorld.visible;
        width: parent.width/10;
        height: parent.height/7;
        anchors.bottom: parent.bottom;
        anchors.right: parent.right;
        anchors.margins: 20;
        color: "black";
        Text {
//            id: name
            anchors.centerIn: parent
            text: qsTr("退出");
            font.pointSize: 22;
            color: "white"
        }
        MouseArea{
            anchors.fill: parent;
            onClicked: {
                resultPage.toControlPage();
            }
        }
    }
    Rectangle{
        id:treetozoo
        anchors.fill: parent
        visible: threetozooIndex===0?false:true;
        Image {
            id: treetozooimage
            source: "qrc:/image/source/image/eWorldInit.png";
            fillMode: Image.PreserveAspectCrop;
            anchors.fill: parent;
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
            }
        }
    }

    CheckSeeResult{
        id:resultPage
        visible: false;
        leftseevalue: ""+shuzhu2[leftEyeValue];
        rightseevalue: ""+shuzhu2[rightEyeValue];
        seeClass: (((shuzhu2[leftEyeValue]<5)?"左眼近视":"左眼视力正常")+((shuzhu2[rightEyeValue]<5)?"右眼近视":"右眼视力正常"));
        onToControlPage: {
            eWorld.visible=false;
            resultPage.visible=false;
            checkAllOver();
            liAudio.rootPlayerStop();
            lanMangeServer.sendTcpNews(qmlShareDate.kinectName,"stopKinect");
        }
        onToChart: {
            eWorld.visible=false;
            resultPage.visible=false;
            liAudio.rootPlayerStop();
            lanMangeServer.sendTcpNews(qmlShareDate.kinectName,"stopKinect");
            toChart2();
        }
    }

    AdjustSeeResult{
        id:adjustresultPage
        visible: false;
        leftseevalue: ""+shuzhu2[leftEyeValue];
        rightseevalue: ""+shuzhu2[rightEyeValue];
        seeClass: (((shuzhu2[leftEyeValue]<1)?"左眼近视":"左眼视力正常")+((shuzhu2[rightEyeValue]<1)?"右眼近视":"右眼视力正常"));
        onToControlPage: {
            eWorld.visible=false;
            resultPage.visible=false;
            checkAllOver();
            liAudio.rootPlayerStop();
            lanMangeServer.sendTcpNews(qmlShareDate.kinectName,"stopKinect");
        }
    }
}

