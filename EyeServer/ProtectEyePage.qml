import QtQuick 2.0
import QtQuick.Window 2.2
import QtMultimedia 5.6

Item {
    width: Screen.desktopAvailableWidth;
    height: Screen.desktopAvailableHeight;
    signal videoPlayOver();
    property alias playersingprotect : player;
    Image {
//        id: name
        source: "qrc:/image/source/image/eyebackground.jpg";
        fillMode: Image.PreserveAspectCrop;
        anchors.fill: parent
    }
    Item {
//        id: name
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        clip: true;
        MediaPlayer {
            id: player
            source: "assets:/yanbaojianchao.mp4";
            autoPlay:false
            onStopped: {
                videoPlayOver();
            }
        }

        VideoOutput {
            id: videoOutput
            source: player
            anchors.fill: parent
            fillMode : VideoOutput.PreserveAspectCrop;
            autoOrientation :true;
            orientation : 180
        }
    }
    Rectangle{
        height: parent.height/5;
        width: height
        radius: width/2;
        focus: parent.focus
        anchors.right: parent.right
        anchors.top:parent.top;
//        anchors.margins: 10;
        anchors.rightMargin: 70;
        color: "gold";
        Text {
            text:"退出";
            font.pointSize: 20;
            anchors.centerIn: parent
            color: "white";
        }
        MouseArea{
            anchors.fill: parent
            focus: parent.focus
            onClicked: {
                player.stop();
            }
        }
    }
}
