import QtQuick
import QtQuick.Controls

Rectangle {
    id: userListRoot
    width: 200
    height: 300
    color: "transparent"
    
    property string selectedUsername: ""
    signal userSelected(string username)
    
    // Debug: Log everything about the sddm object
    function debugSddmObject() {
        console.log("\n========== SDDM OBJECT DEBUG ==========")
        
        if (typeof sddm === 'undefined') {
            console.log("✗ ERROR: sddm is UNDEFINED!")
            console.log("==========================================")
            return
        }
        
        console.log("✓ sddm exists")
        console.log("sddm type:", typeof sddm)
        
        // List all properties of sddm
        console.log("\n--- All properties of sddm object ---")
        var propertyCount = 0
        for (var prop in sddm) {
            propertyCount++
            var value = sddm[prop]
            var valueType = typeof value
            
            // Don't log functions as full strings
            if (valueType === 'function') {
                console.log("  " + prop + "(): [function]")
            } else if (valueType === 'object') {
                if (value && value.count !== undefined) {
                    console.log("  " + prop + ": [object with count=" + value.count + "]")
                } else {
                    console.log("  " + prop + ": [object]")
                }
            } else {
                console.log("  " + prop + ":", value, "(" + valueType + ")")
            }
        }
        
        if (propertyCount === 0) {
            console.log("  (No enumerable properties found)")
        }
        
        // Specifically check for users property
        console.log("\n--- Checking specific properties ---")
        console.log("sddm.users:", sddm.users)
        console.log("userModel (global):", userModel)
        if (userModel) console.log("userModel.count:", userModel.count)
        console.log("sddm.userModel:", sddm.userModel)
        console.log("sddm.model:", sddm.model)
        console.log("sddm.usersList:", sddm.usersList)
        
        // Check if there's a this or data property
        console.log("sddm['data']:", sddm['data'])
        console.log("sddm['model']:", sddm['model'])
        
        // Try to see what's available in the prototype
        console.log("\n--- Prototype chain ---")
        var proto = Object.getPrototypeOf(sddm)
        if (proto) {
            console.log("Prototype properties:")
            for (var prop in proto) {
                console.log("  " + prop)
            }
        }
        
        console.log("\n==========================================")
    }
    
     // Debug text to show what's available
     Text {
         id: debugText
         text: {
             if (typeof userModel !== 'undefined' && userModel && userModel.count > 0) return "userModel.count: " + userModel.count
             if (typeof sddm === 'undefined') return "SDDM: UNDEFINED"
             return "No users in model"
         }
         color: "red"
         z: 10
         anchors.top: parent.top
         anchors.horizontalCenter: parent.horizontalCenter
         font.pixelSize: 12
     }
    
    // Run debug when component loads
    Component.onCompleted: {
        debugSddmObject()
        
        // Also try after a delay
        var timer = Qt.createQmlObject('import QtQuick 2.0; Timer { interval: 500; running: true; repeat: false }', parent)
        timer.triggered.connect(function() {
            console.log("\n*** After 500ms delay ***")
            debugSddmObject()
        })
    }
    
    // Try both possible model names
    ListView {
        id: listView
        anchors.fill: parent
        spacing: 10
        
        // Try both possible model names
        model: userModel || sddm.userModel || sddm.users || sddm.model || ["No users found", "Check console for debug"]
        
        delegate: Rectangle {
            width: parent.width
            height: 45
            color: mouseArea.containsMouse ? "#2a2a2a" : "#1e1e1e"
            radius: 5
            border.color: "#3a3a3a"
            border.width: 1
            
            // Debug each delegate
            Component.onCompleted: {
                console.log("\n[Delegate] Index:", index)
                console.log("  model type:", typeof model)
                console.log("  model value:", model)
                if (typeof model === 'object' && model !== null) {
                    console.log("  model properties:")
                    for (var prop in model) {
                        console.log("    " + prop + ":", model[prop])
                    }
                }
            }
            
            Text {
                text: {
                    if (typeof model === 'string') return model
                    if (model && model.name) return model.name
                    if (model && model.userName) return model.userName
                    if (typeof model === 'object') return JSON.stringify(model)
                    return "User " + index
                }
                anchors.centerIn: parent
                color: "white"
                font.pixelSize: 12
                horizontalAlignment: Text.AlignHCenter
                width: parent.width - 10
                wrapMode: Text.WordWrap
            }
            
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    var username = (typeof model === 'string') ? model : 
                                  (model && model.name) ? model.name : 
                                  "user" + index
                    userListRoot.selectedUsername = username
                    userListRoot.userSelected(username)
                    console.log("Clicked:", username)
                }
            }
        }
        
        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
        }
    }
}