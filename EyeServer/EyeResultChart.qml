import QtQuick 2.3
import QtQuick.Window 2.2

Item {
    signal chartOver();
    Image {
        source: "qrc:/image/source/image/controlbackground.png"
    }
    Chart{
        id:seeChart
        width: 700
        height: 332;
        anchors.centerIn: parent;
        onPainted: {
//            root.color="white";
        }
    }
    Item {
//        id: name
        width: parent.width/7;
        height: parent.height/12;
        anchors.bottom: parent.bottom;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.margins: 10;
        clip: true;
        Image {
//            id: name
            source: "qrc:/image/source/image/returnbutton.png"
            anchors.centerIn: parent;
            fillMode: Image.PreserveAspectFit;
        }
        MouseArea{
            anchors.fill: parent;
            onClicked: {
                chartOver();
            }
        }
    }

    function paintChart(){
        var rootObj=JSON.parse(seeValueJSON.returnJSONStr());
        var Time=rootObj.Time;
        var Left=rootObj.Left;
        var Right=rootObj.Right;
//        console.log(Time[0]);
        seeChart.line({
                      labels : Time,
                      datasets : [
                          {
                              fillColor : "rgba(250,1,194,0.5)",
                              strokeColor : "rgba(250,1,194,1)",
                              pointColor : "rgba(250,1,194,1)",
                              pointStrokeColor : "#fff",
                              data : Left
                          },
                          {
                              fillColor : "rgba(0,255,12,0.5)",
                              strokeColor : "rgba(0,255,12,1)",
                              pointColor : "rgba(0,255,12,1)",
                              pointStrokeColor : "#fff",
                              data : Right
                          }
                      ]
                  });
        seeChart.requestPaint();
    }
}
