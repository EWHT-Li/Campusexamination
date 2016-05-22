import QtQuick 2.0
import QtQuick.Window 2.2

Item {
    width: Screen.width
    height: Screen.height
    property int treetozerotime: 3;
    signal massageOver();
    property bool ismassage: false;

    function restart()
    {
        treetozerotime=3;
        liAudio.setMusicSource("assets:/headHere.mp3")
        liAudio.rootPlayerPlay();
        faceImage.source="qrc:/image/source/image/loading.png";
    }

    function midCloss()
    {
        lanMangeServer.sendTcpNews(qmlShareDate.massageName,qmlShareDate.closeMassage);
        lanMangeServer.sendTcpNews(qmlShareDate.faceName,"massage_close_send_photo#!");
        midClosspass.start();
    }
Timer{
    id:midClosspass
    interval: 500;
    running: false;
    repeat: false;
    onTriggered: {
        lanMangeServer.sendTcpNews(qmlShareDate.massageName,qmlShareDate.closeLight);//关灯
        liAudio.playRepeat=false;
        liAudio.rootPlayerStop();
        threetozeroreally.stop();
        massageTime.stop();
        massageOver();
    }
}


    Connections{
        target: lanMangeServer
        onFromMassage:{
            if(massageStr===qmlShareDate.appearMan&&ismassage)
            {
                console.log("qml收到："+qmlShareDate.appearMan);
                lanMangeServer.sendTcpNews(qmlShareDate.massageName,qmlShareDate.openLight);//关灯
                threetozero.start();
//                lanMangeServer.sendTcpNews(qmlShareDate.massageName,qmlShareDate)
            }
            else if(massageStr==="massage_people_no#!"&&ismassage)
            {
                midCloss();
            }
            else if(massageStr==="massage_arrival#!"&&ismassage)
            {
                lanMangeServer.sendTcpNews(qmlShareDate.massageName,"massage_start#!");
                massageTime.start();//计时
            }
        }
        onReceiveFileOver:{
            //加载收到的图片并显示。。。
            onReceiveFileOver.start();
        }
    }
    Timer{
        id:onReceiveFileOver
        interval: 1000;
        repeat: false;
        running: false;
        onTriggered: {
            if(ismassage){
                faceImage.source="file:////storage/sdcard0/data/detect.jpg";
                lanMangeServer.sendTcpNews(qmlShareDate.massageName,qmlShareDate.closeLight);//关灯
                openMassagepass.start();
            }
        }
    }

    Timer{
        id:openMassagepass
        interval: 500;
        running: false;
        repeat: false;
        onTriggered: {
            lanMangeServer.sendTcpNews(qmlShareDate.massageName,qmlShareDate.openMassage);//开机

            liAudio.playRepeat=true;
            liAudio.setMusicSource("assets:/massagebackmusic.mp3");
            liAudio.rootPlayerPlay();
        }
    }

    Timer{
        id:massageTime
        interval: 26*1000
        running: false;
        repeat: false;
        onTriggered: {
            threetozeroreally.start();
            treetozerotime=3;
        }
    }

    Timer{
        id:threetozeroreally
        interval: 1000
        running: false
        repeat: true
        onTriggered: {
            if(treetozerotime>0)
            {

                liAudio.setMusicSource("assets:/"+treetozerotime+".mp3")
                liAudio.rootPlayerPlay();
                --treetozerotime;
            }
            else
            {
                lanMangeServer.sendTcpNews(qmlShareDate.massageName,qmlShareDate.closeMassage);
                liAudio.playRepeat=false;
                liAudio.rootPlayerStop();
                stop();
                massageOver();
            }
        }
    }

    Timer{
        id:threetozero
        interval: 1000
        running: false
        repeat: true
        onTriggered: {
            if(treetozerotime>0)
            {

                liAudio.setMusicSource("assets:/"+treetozerotime+".mp3")
                liAudio.rootPlayerPlay();
                --treetozerotime;
            }
            else
            {
                lanMangeServer.sendTcpNews(qmlShareDate.massageName,qmlShareDate.openLight);
                lanMangeServer.sendTcpNews(qmlShareDate.faceName,qmlShareDate.sendPhoto);//lanMangeServer.sendTcpNews()**通知face开始检测
                stop();
            }
        }
    }


    Image {
        id: name
        source: "qrc:/image/source/image/massageheadhere.png";
        anchors.fill: parent
        fillMode:Image.PreserveAspectFit;
    }
    Image {
        id: faceImage
        asynchronous:true;
        cache:false;
        x:240
        y:128
        height: 208
        width: 312
        fillMode:Image.PreserveAspectFit;
    }
    Image {
//        id: name
        source: "qrc:/image/source/image/returnbutton.png"
        anchors.left: parent.left;
        anchors.top:parent.top;
        anchors.margins: 20;
        MouseArea{
            anchors.fill: parent;
            onClicked: {
                midCloss();
            }
        }
    }
}
