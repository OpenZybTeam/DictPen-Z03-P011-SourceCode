import QtQuick 2.0


MouseArea {
    property point origin
    property bool ready: false
    property int threshold: 20
    property bool drayXandY : true
    signal move(int x, int y)
    signal xmove(int x)
    signal ymove(int x, int y)
    signal upmove();
    signal downmove();
    signal swipe(string direction)
    signal mousePresed();
    property int curVal : 0


    onPressed: {
        //drag.axis = drayXandY ? Drag.XAndYAxis :Drag.XAxis
        drag.axis = Drag.XAndYAxis
        origin = Qt.point(mouse.x, mouse.y)
        curVal = mouse.y
        //console.log("MouseArea", origin, curVal);
        mousePresed();
    }

//    onClicked:
//    {
//        curVal = mouse.y
//    }

    onPositionChanged: {
        switch (drag.axis) {
        case Drag.XAndYAxis:
            if (Math.abs(mouse.x - origin.x) > threshold ) {
                drag.axis = Drag.XAxis
            }
            else if (Math.abs(mouse.y - origin.y) > threshold) {
                drag.axis = Drag.YAxis
            }
            break
        case Drag.XAxis:
            xmove(mouse.x - origin.x)
            break
        case Drag.YAxis:
            if(mouse.y > curVal )
            {
                downmove();
            }
            else
            {
                upmove();
            }

            curVal = mouse.y

//            if(mouse.y - origin.y > 0)
//            {
//                downmove();
//            }
//            else
//            {
//                upmove();
//            }

            //ymove(0, mouse.y - origin.y)
            break
        }

    }

//    onReleased: {
//        switch (drag.axis) {
//        case Drag.XAndYAxis:
//            canceled(mouse)
//            break
//        case Drag.XAxis:
//            swipe(mouse.x - origin.x < 0 ? "left" : "right")
//            break
//        case Drag.YAxis:
//            swipe(mouse.y - origin.y < 0 ? "up" : "down")
//            break
//        }
//    }
}
