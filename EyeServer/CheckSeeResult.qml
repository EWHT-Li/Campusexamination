import QtQuick 2.5
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.4


Item {
    width: Screen.desktopAvailableWidth;
    height: Screen.desktopAvailableHeight;
    signal toControlPage;
    signal toChart;
//    signal toCheckTwo;
    property string leftseevalue: "0";
    property string rightseevalue: "0";
    property string seeClass:"";
    Image {
        anchors.fill: parent;
        clip: true;
        id: backgrount;
        fillMode:Image.Stretch;
        source: "qrc:/image/source/image/background.jpg"
    }
    Button{
        id:back;
        width: (45/400)*parent.width;
        height: (25/300)*parent.height;
           anchors.top:parent.top;
           anchors.topMargin:parent.height/205;
           anchors.left:parent.left;
           anchors.leftMargin:parent.width/29;
           opacity: 0
           onClicked: {
              toControlPage();
        }
    }
    Image {
//        id: name
        source: "qrc:/image/source/image/statistics.png";
        anchors.right: parent.right;
        anchors.top:parent.top;
        anchors.margins: 20;
        MouseArea{
            anchors.fill: parent;
            onClicked: {
                toChart();
            }
        }
    }
//    Image {
////        id: name
//        source: "qrc:/image/source/image/adjustSeeValue.png"

//        anchors.left: parent.left;
//        anchors.bottom: parent.bottom;
//        anchors.margins: 20;
//        MouseArea{
//            anchors.fill: parent;
//            onClicked: {
//                toCheckTwo();
//            }
//        }
//    }
    Column{
        anchors.left: parent.left;
        anchors.leftMargin:(9/20)*parent.width;
        anchors.top: parent.top;
        id:column
        anchors.topMargin: parent.height/4-5;
        spacing: (1/45)*parent.height;
        Text {
            id: left
            text:leftseevalue;
            color: "white"
            font.pointSize: 22
            font.bold: true;
        }
        Text {
            id: right
            color: "white"
            text:rightseevalue;
            font.bold: true;
            font.pointSize: 22
        }
        Text {
            id: lei_xing
            color: "white"
            text: seeClass;
            font.bold: true;
            font.pointSize: 20
        }
    }
    Rectangle {
        width: (1/2)*parent.width;
        height:(1/4)*parent.height;
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: (1/4)*parent.width-6;
        anchors.bottomMargin: (1/25)*parent.width;
        color: "#5e9263";
        clip:true;
        Flickable {
            id: flickable
            width: parent.width;
            height:parent.height;
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
                color: "white";
                wrapMode:Text.Wrap
                width: parent.width
                text: "日常用眼应注意：
第一：看书时，光线要充足舒适，书距眼睛以30公分为准，桌椅高度与体格相配。
第三：无论做功课或看电视，时间不可太长，每三十分钟应休息片刻。
第四：坐姿要端正，越靠近或趴着作业易造成睫状肌紧张过度，造成近视。
第五：看电视时保持与电视画面对角线六至八倍距离，每30分钟应休息片刻。
第六：作息要有规律，睡眠不足身体容易疲劳,易造成假性近视。
第七：多做户外运动，经常眺望远外放松眼肌，预防近视。
第八：进食要均衡，特别注意维生素B类(胚芽米、麦片酵母)之类摄取。"//liStringFile.returnTextAllStr("assets:/advise.txt");
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

}

