/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import QtMultimedia 5.0
import QtQuick.Layouts 1.3
import "../ZybControls"
import "../Style"

Item {
    id:root
    property alias source : preview.source
    property string imagePath:""
    property bool commiting : false

    signal returnToParent();
    signal commited
    function controlClose()
    {
        shot_area.close()
        contorlLayout.visible = false
        commiting = false;
    }

    function controlOpen()
    {
        shot_area.pop()
        contorlLayout.visible = true
    }

    function enableShotArea(b)
    {
        shot_area.enabled = b;
    }

    Timer {
        id:timer
        interval: 10; running: false; repeat: false
        onTriggered:
        {
            console.log("shot_area.requestshot")
            shot_area.requestshot();
        }
    }

    RowLayout {
        id: contorlLayout
        spacing: 24
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: (parent.width -width)/2
        z:29

        Image {
            id: refresh
            source: "/images/refresh56.png"
            width: 56
            height: 56
            z:29
            MouseArea {
                anchors.fill: parent
                anchors.margins: -32
                onClicked: {
                    returnToParent();
                }
            }
        }

        ZybText {
            id:tip
            text: qsTr("每次只选一道题")
        }

        Image {
            id: commit
            source: "/images/commit56.png"
            width: 56
            height: 56
            z:29
            MouseArea {
                anchors.fill: parent
                anchors.margins: -32
                onClicked: {

                    if(dataManager.getLive() === false)
                    {
                        netDig.open();
                        return;
                    }

                    if(commiting === false)
                    {
                        commiting = true
                        console.log("commit clicked")
                        commited();
                        timer.start();
                        //shot_area.requestshot(imagePath);
                    }
                }
            }
        }
    }

    Image {
        id: preview
        anchors.fill : parent
        fillMode: Image.PreserveAspectFit
        smooth: true
        rotation:  devManager.isLeftHand?180:0
    }

    //对Item截图
    CustomItemShot{
        id: shot_area
        shotTarget: preview //要抓取的Item
        anchors.fill: preview //范围

        onVisibleChanged:
        {
            if(shot_area.visible)
            {
                shot_area.shotArea.y = 0;
                shot_area.shotArea.height = Style.gHeight;
                shot_area.dragChanged = false;
            }
        }
    }


}

