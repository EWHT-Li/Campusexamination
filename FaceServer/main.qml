import QtQuick 2.5
import QtQuick.Window 2.2
//import Qt.labs.controls 1.0
import QtQuick.Controls 1.4
import QtQml 2.2

Window {
    visible: true
    width: Screen.desktopAvailableWidth;
    height: Screen.desktopAvailableHeight;
    property int pageIndex: 0;

    Connections{
        target: lanMangeServer;
        onFromMassage:{
            console.log("massage:"+massageStr);
            switch(pageIndex)
            {
            case 0:
                if(massageStr==="#stm32_init_complete!")
                {
                    welcomePageRoot.massageConnect=true;
                    welcomePageRoot.initializeOverCheck();
                }
                break;
            case 1:
                if(massageStr==="#massage_left_ready_complete!")//massage2
                {
                    massagePageRoot.solidInit=true;
                    if(massagePageRoot.pageIndex===4)
                    {
                        massagePageRoot.toHeadhere();
                    }
                }else if(massageStr==="#massage_people_arrive!")//massage3
                {
                    if(massagePageRoot.pageIndex===5)
                    {
                         lanMangeServer.sendTcpNewstoFace(qmlShareDate.massageName,"#massage_left_start!");
                        massagePageRoot.leftTime.start();
                        liAudio.setMusicSource("assets:/leftmassageopen.mp3");
                        liAudio.rootPlayerPlay();
                        massagePageRoot.allVisible(2);
                    }
                }else if(massageStr==="#arm_arrive_right_int!")//massage6
                {
                    lanMangeServer.sendTcpNewstoFace(qmlShareDate.massageName,"#massage_right_start!");//massage7
                    liAudio.setMusicSource("assets:/rightmassageopen.mp3");
                    liAudio.rootPlayerPlay();
                    massagePageRoot.rightTime.start();
                }else if(massageStr==="#arm_back_origin!")
                {
                    massagePageRoot.massageOver();
                }else if(massageStr==="#massage_people_leave!")
                {
//                    massagePageRoot.rightTime.stop();
                    massagePageRoot.aResidueTimePage.residueClose();
                    liAudio.setMusicSource("assets:/peopleleave.mp3");
                    liAudio.rootPlayerPlay();
//                    massagePageRoot.massageOver();
                    massagePageRoot.willOver2();
//                    lanMangeServer.sendTcpNewstoFace(qmlShareDate.massageName,"#mode1_massage_over!");//emassage2
                }
                break;
            case 2:
                if(massageStr==="#vapour_ready_complete!")
                {
                    saunaPageRoot.solidInit=true;
                    if(saunaPageRoot.pageIndex===4)
                    {
                        saunaPageRoot.toHeadhere();
                    }
                }else if(massageStr==="#massage_people_arrive!")
                {
                    if(saunaPageRoot.pageIndex===5)
                    {
                        lanMangeServer.sendTcpNewstoFace(qmlShareDate.massageName,"#vapour_star!");
                        liAudio.setMusicSource("assets:/saunaopen.mp3");
                        liAudio.rootPlayerPlay();
                        saunaPageRoot.allVisible(2);
                        saunaPageRoot.residuetime.start();
                    }
                }else if(massageStr==="#arm_back_origin!")
                {
                    saunaPageRoot.saunaPageOver();
                }else if(massageStr==="#massage_people_leave!")
                {
                    console.log("断时间2");
                   saunaPageRoot.residuetime.stop();
                    liAudio.setMusicSource("assets:/peopleleave.mp3");
                    liAudio.rootPlayerPlay();
//                    saunaPageRoot.saunaPageOver();
//                    lanMangeServer.sendTcpNews(qmlShareDate.massageName,"#vapour_over!");
                    saunaPageRoot.willOver();
                }
                break;
            case 3:
                if(massageStr==="#photo_ready_complete!")
                {
                    if(checkBlackPageRoot.pageIndex===3)
                    checkBlackPageRoot.toHeadhere();
                }else if(massageStr==="#massage_people_arrive!")
                {
                    lanMangeServer.sendTcpNewstoFace(qmlShareDate.massageName,"#photo_light_open!");
                    lanMangeServer.sendTcpNews(qmlShareDate.faceName,qmlShareDate.sendPhoto);
                    checkBlackPageRoot.allVisible(4);
                }else if(massageStr==="#arm_back_origin!")
                {
                    checkBlackPageRoot.checkBlackOver();
                }else if(massageStr==="#massage_people_leave!")
                {
//                    liAudio.setMusicSource("assets:/peopleleave.mp3");
//                    liAudio.rootPlayerPlay();
//                    checkBlackPageRoot.willOver();
//                    lanMangeServer.sendTcpNews(qmlShareDate.faceName,"massage_close _send_photo#!");
                }

                break;
            default:
                break;
            }
        }
        onFromFace:{
            console.log("face:"+faceStr);
            switch(pageIndex)
            {
            case 0:
                if(faceStr==="face_init_success#!")
                {
                    welcomePageRoot.faceConnect=true;
                    welcomePageRoot.initializeOverCheck();
                }
                break;
            case 1:
                break;
            case 2:
                break;
            case 3:
                break;
            default:
                break;
            }
        }

//        onReceiveFileOver:{

//            lanMangeServer.sendTcpNews(qmlShareDate.massageName,"#photo_light_close!");
//        }

    }


    StackView{
        id: stackView
        anchors.fill: parent
        focus: true;
        initialItem: welcomePageRoot;
        delegate: StackViewDelegate {

            pushTransition: StackViewTransition {

                PropertyAnimation {
                    target: enterItem;
                    property: "opacity";
                    from: 0;
                    to: 1;
                    duration: 1000;
                    easing.type: Easing.InQuad
                }
                PropertyAnimation {
                    target: exitItem;
                    property: "opacity";
                    from: 1;
                    to: 0;
                    duration: 1000;
                }
            }
        }
        WelcomePage{
            id:welcomePageRoot
            width: parent.width;
            height: parent.height;
            visible: false;
            onInitOver: {
                stackView.push(controlPageRoot);
            }
        }


        ControlPage{
            id:controlPageRoot
            width: parent.width;
            height: parent.height;
            visible: false;
            onSelect: {
                switch(index)
                {
                case 1:
                    pageIndex=1;
                    stackView.push(massagePageRoot);
                    massagePageRoot.allVisible(1);
                    massagePageRoot.restart();
                    lanMangeServer.sendTcpNewstoFace(qmlShareDate.massageName,qmlShareDate.prepareMassage);//massage1
                    break;
                case 2:
                    pageIndex=2;
                    stackView.push(saunaPageRoot);
                    saunaPageRoot.allVisible(1);
                    saunaPageRoot.restart();
                    lanMangeServer.sendTcpNewstoFace(qmlShareDate.massageName,"#mode2_vapour_ready!");//vapour1;
                    break;
                case 3:
                    pageIndex=3;
                    stackView.push(checkBlackPageRoot);
                    checkBlackPageRoot.restart();
//                    lanMangeServer.sendTcpNews(qmlShareDate.massageName,"#mode3_photo_ready!");
                    break;
                default:
                    break;
                }
            }
        }

        MassagePage{
            id:massagePageRoot
            width: parent.width
            height: parent.height;
            visible: false;
            onMassageOver: {
                stackView.pop(controlPageRoot);
                pageIndex=0;
            }
        }

        SaunaPage{
            id:saunaPageRoot
            width: parent.width;
            height: parent.height;
            visible: false;
            onSaunaPageOver: {
                stackView.pop(controlPageRoot);
                pageIndex=0;
            }
        }

        CheckBlackCycle{
            id:checkBlackPageRoot;
            width: parent.width;
            height: parent.height;
            visible: false;
            onCheckBlackOver: {
                stackView.pop(controlPageRoot);
                pageIndex=0;
            }
        }
    }
    Component.onCompleted: {
    }
}
