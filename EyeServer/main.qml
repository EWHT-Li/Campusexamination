import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4

Item{
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
//    property alias stackView1: stackView1

    function allfocusfalse()
    {
        welcomePageRoot.focus=false;
        controlPageRoot.focus=false;
        eworldPageRoot.focus=false;
        protectEyePageRoot.focus=false;
        massagePageRoot.focus=false;
    }

    StackView{
        id: stackView
        anchors.fill: parent
        focus: true;
        initialItem: welcomePageRoot;
        delegate: StackViewDelegate {
                    function transitionFinished(properties)
                    {
                        properties.exitItem.opacity = 1
                    }

                    pushTransition: StackViewTransition {

                        PropertyAnimation {
                            target: enterItem;
                            property: "width";
                            from: 0;
                            to: enterItem.width;
                            duration: 1000;
                            easing.type: Easing.InQuad
                        }
                        PropertyAnimation {
                            target: enterItem;
                            property: "height";
                            from: 0;
                            to: enterItem.height;
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
            visible: false;
            Connections{
                target: welcomePageRoot
                onInitializeOver:{
                    stackView.push(controlPageRoot);
                }
            }
        }

        ControlPage{
            id:controlPageRoot
            visible: false;
            Connections{
                target: controlPageRoot
                onSelection:{//(int index)
                    switch(index)
                    {
                    case 1:
                        stackView.push(massagePageRoot);
                        massagePageRoot.ismassage=true;
                        massagePageRoot.visible=true;
                        massagePageRoot.restart();
                        console.log("page1");
                        break;
                    case 2:
                        stackView.push(eworldPageRoot);
                        eworldPageRoot.adjustState=false;
                        eworldPageRoot.stateNewsSend();
                        console.log("page2");
                        break;
                    case 3:
                        stackView.push(protectEyePageRoot);
                        protectEyePageRoot.playersingprotect.play();
                        console.log("page3");
                        break;
                    case 4:
                        stackView.push(eworldPageRoot);
                        eworldPageRoot.adjustState=true;
                        eworldPageRoot.stateNewsSend();
                        break;
                    default:
                        break;
                    }
                }
            }
        }

        Eworld{
            id:eworldPageRoot
            visible: false;
            Connections{
                target: eworldPageRoot;
                onCheckAllOver:{
                    stackView.pop(controlPageRoot);
                    console.log("你关不关")
                    lanMangeServer.sendTcpNews(qmlShareDate.massageName,qmlShareDate.closeLaser);//关激光
                    liAudio.rootPlayerStop();
                }
                onCheckTempOver:{
                    eyeResultChartRoot.paintChart();
                }
                onToChart2:{
                    stackView.push(eyeResultChartRoot);
                }
            }
        }

        ProtectEyePage{
            id:protectEyePageRoot
            visible: false;
            Connections{
                target: protectEyePageRoot
                onVideoPlayOver:{
                    stackView.pop(controlPageRoot);
                }
            }
        }

        MassagePage{
            id:massagePageRoot
            visible: false
            onMassageOver: {
                stackView.pop(controlPageRoot);
                ismassage=false;
            }
        }
        EyeResultChart{
            id:eyeResultChartRoot
            visible: false
            onChartOver: {
                stackView.pop(controlPageRoot);
                lanMangeServer.sendTcpNews(qmlShareDate.massageName,qmlShareDate.closeLaser);//关激光
                liAudio.rootPlayerStop();
            }
        }
    }
}
