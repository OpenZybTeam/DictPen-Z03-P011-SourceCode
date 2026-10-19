import QtQuick 2.0
import QtQuick.Controls 2.3
import "../ZybControls/"
import "../Funcs/UILogics.js" as UILogic
import "../Style"

Item {
    id:root
    signal toNext();
    signal toPre();

    state: "tip"
    states: [
        State {
            name: "wifi1"
            StateChangeScript {
                script: {
//                    mtimer.running = true;
                }
            }
        },

        State {
            name: "login"
            StateChangeScript {
                script: {
//                    mtimer.running = false;
                }
            }

        },
        State {
            name: "guide"
            StateChangeScript {
                script: {
//                    mtimer.running = false;
                }
            }

        }
    ]

}
