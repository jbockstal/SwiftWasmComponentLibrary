import JavaScriptKit

class ButtonStory: Story, ButtonClickListener, InputChangeListener {
    let document = JSObject.global.document
    var button: Button {
        get {
            return component as! Button
        }
    }
    
    override func initializeComponent() {
        self.button.register(listener:self)
    }
    
    override func initializeInputs() {
        var inputField = document.createElement("input")
        // TODO: Refactor, label is used as value
        inputField.value = .string("Login")
        inputField.id = .string("label")
        inputField.type = "input"
        
        var inputFieldLabel = document.createElement("label")
        inputFieldLabel.innerText = "Label"
        inputFieldLabel.setAttribute("for", "label")
        
        var inputElement: Input = Input(element: inputField, label:"Login", type:.input, id:"label", name:nil, for:nil, checked:nil, labelElement: inputFieldLabel)
        self.inputs.append(inputElement)
        
        var radio = document.createElement("input")
        radio.type = "radio"
        radio.id = .string("primary")
        radio.checked = .boolean(true)
        radio.name = .string("buttonType")
        
        var radioLabel = document.createElement("label")
        radioLabel.innerText = .string("Primary")
        radioLabel.setAttribute("for", "primary")
        
        inputElement = Input(element: radio, label:"Primary", type:.radio, id:"primary", name:"buttonType", for:"primary", checked:true, labelElement:radioLabel)
        self.inputs.append(inputElement)
        
        var radioSec = document.createElement("input")
        radioSec.type = "radio"
        radioSec.id = .string("secondary")
        radioSec.name = .string("buttonType")
        
        var radioLabelSec = document.createElement("label")
        radioLabelSec.innerText = .string("Secondary")
        radioLabelSec.setAttribute("for", "secondary")
        
        inputElement = Input(element: radioSec, label:"Secondary", type:.radio, id:"secondary", name:"buttonType", for:"secondary", checked:false, labelElement:radioLabelSec)
        self.inputs.append(inputElement)
        
        self.inputs.forEach{ input in
            input.register(listener:self)
        }
    }
        
    func buttonClicked() {
        var outputContainer = JSObject.global.document.getElementById("outputs")
        var index = Int(outputContainer.children.length.number! + 1)
        var element = JSObject.global.document.createElement("div")
        element.innerText = .string("\(index). Clicked \(self.button.type) button \(self.button.label)")
        
        outputContainer.prepend(element)
    }
        
    func inputChanged(value: [JSValue], type: InputType) {
        switch type {
        case .input:
            self.button.label = value[0].target.value
        case .radio:
            if (value[0].target.name == .string("buttonType")) {
                if (value[0].target.id == .string("primary")) {
                    self.button.type = .primary
                } else {
                    self.button.type = .secondary
                }
            }
        default:
            JSObject.global.console.log("Unknown input change")
        }
        
        self.listeners.forEach { item in
            item.storyUpdated()
        }
    }
}

