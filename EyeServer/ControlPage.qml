import QtQuick 2.0
import QtQuick.Window 2.2

Item {
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    signal selection(int index);
    Image {
        anchors.fill: parent;
        fillMode: Image.PreserveAspectCrop;
        source: "qrc:/image/source/image/controlbackground.png";
        clip: true;
    }

    Item{
        id:checkButton
        width: parent.width/5
        height: parent.height/11
        anchors.bottom : parent.verticalCenter;
        anchors.horizontalCenter: parent.horizontalCenter;
        Image {
            source: "qrc:/image/source/image/testbutton.png"
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                selection(2);
            }
        }
    }

    Item{
        id:massageButton
        width: parent.width/5
        height: parent.height/11
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: parent.height/10;
        anchors.bottom: checkButton.top
        Image {
            source: "qrc:/image/source/image/massagebutton.png"
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                selection(1);
                lanMangeServer.sendTcpNews(qmlShareDate.massageName,qmlShareDate.prepareMassage);
            }
        }
    }

    Item{
        id:protectButton
        width: parent.width/5
        height: parent.height/11
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: parent.height/10;
        anchors.top: adjustButton.bottom;
        Image {
//            id: /*name*/
            source: "qrc:/image/source/image/protecteyebutton.png"
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                selection(3);
            }
        }
    }

    Item{
        id:adjustButton
        width: parent.width/5
        height: parent.height/11
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: parent.height/10;
        anchors.top: checkButton.bottom;
        Image {
//            id: /*name*/
            source: "qrc:/image/source/image/adjustCheckButton.png"
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                selection(4);
            }
        }
    }
}
