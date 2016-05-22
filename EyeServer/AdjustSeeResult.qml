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
//    Image {
//        source: "qrc:/image/source/image/statistics.png";
//        anchors.right: parent.right;
//        anchors.top:parent.top;
//        anchors.margins: 20;
//        MouseArea{
//            anchors.fill: parent;
//            onClicked: {
//                toChart();
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
                text: "配镜指南:
根据眼镜的用途，如果是用于开车和相对需要看远距离的话，
那么矫正视力起码要配到0.9-1.0；如果仅在家中看电视和电脑用，
即中距离，则选择0.8。最好不要低于0.8的矫正视力，
因为如果配的过浅，长时间视物不清，会导致眼睛疲劳，同时加重度数。"//liStringFile.returnTextAllStr("assets:/advise.txt");
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

