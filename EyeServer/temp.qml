import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2


Rectangle {
//    title: qsTr("Hello World")
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    visible: true

    Connections{
        target: lanMangeServer;
        onFromKinect:{
            console.log("Kinect"+kinectStr);
        }
    }
    function refreshTcpSocketList()
    {
        console.log("开始清空ServerList:");
        tcpsocketlist.clear();
        for(var i=0;i<lanMangeServer.returnTcpSocketRegisteryCount();i++)
        {
            tcpsocketlist.append({
                                     "Descript":lanMangeServer.returnTcpSocketRegisteryKey(i),
                                 })
            console.log("有多少个:"+i);
        }
    }

    Connections{
        target: lanMangeServer;
        onDebug:{
            tcpnews.append(str);
        }
        onUpdateTcpSocketRegistery:{
            refreshTcpSocketList();
        }
    }

//    Connections{
//        target: testFace
//        onTestEyeOk:{
//            tcpnews.append("识别结束");
//        }
//    }

    ListModel{
        id:tcpsocketlist
    }

    TextEdit{
        id:tcpnews
        width: parent.width
        height: parent.height/3
        anchors.top:parent.top
        anchors.left: parent.left;
        anchors.topMargin: 10;
        color: "black"
        font.pointSize: 15;
    }

    ListView{
        id:tcpsocketListView
        anchors.top: tcpnews.bottom
        anchors.left: parent.left
        anchors.topMargin: 10
        width: parent.width
        height: parent.height/4.5
        model:tcpsocketlist
        delegate:Component{
            Item {
                id:tcpsocketListView_item
                width: tcpsocketListView.width
                height: tcpsocketListView.height/2
                TextInput{
                    id:sendtcpNew
                    width: parent.width*9/10;
                    height: parent.height
                    font.pointSize: 15;
                    anchors.left: parent.left
                    anchors.top:parent.top
                }
                Rectangle{
                    width: parent.width/10
                    height: parent.height
                    color: "black"
                    anchors.right: parent.right
                    anchors.top:parent.top;
                    Text{
                        font.pointSize: 15
                        color: "white"
                        text: Descript
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            lanMangeServer.sendTcpNews(Descript,sendtcpNew.text);
//                            lanMangeServer.sendTcpFile("D:/Qt/Opencv/photos/detect.jpg",Descript)
                        }
                    }
                }
            }
        }
    }

    Rectangle{
        color: "black";
        width: parent.width/10;
        height: width;
        anchors.bottom: parent.bottom;
        anchors.left: parent.left;
        anchors.bottomMargin: 20;
        Text {
//            id: name
            text: qsTr("识别")
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
//                testFace.startTestBegin();
            }
        }
    }
}
