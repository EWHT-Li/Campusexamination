import QtQuick 2.0

Item {

    signal select(int index);
    Image {
        source: "qrc:/image/source/Image/Cpbackground.png";
        fillMode: Image.PreserveAspectCrop;
    }
//    Row{
//        spacing: parent.width/5;
//        x:parent.width/5;
//        y:parent.height*2/7

        Image {
            source: "qrc:/image/source/Image/Facemassage.png";
            x:252;
            y:203;
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    select(1);
                    console.log("1");
                }
            }
        }

        Image {
            source: "qrc:/image/source/Image/Facesauna.png";
            x:189;
            y:88
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    select(2);
                    console.log("2");
                }
            }
        }
//    }

    Image {
        source: "qrc:/image/source/Image/Facecheck.png";
//        anchors.horizontalCenter: parent.horizontalCenter;
//        y:parent.height*4/7;
        x:528;
        y:157;
        MouseArea{
            anchors.fill: parent
            onClicked: {
                select(3);
                console.log("3");
            }
        }
    }

}
