import JavaScriptKit

class InputFieldStory: Story, InputFieldChangeListener, InputChangeListener {
    let document = JSObject.global.document
    var inputField: InputField {
        get {
            return component as! InputField
        }
    }
    
    override func initializeInputs() {
        var inputField = document.createElement("input")
        // TODO: Refactor, label is used as value
        inputField.value = .string("Email address")
        inputField.id = .string("label")
        inputField.type = "input"
        
        var inputFieldLabel = document.createElement("label")
        inputFieldLabel.innerText = "Label"
        inputFieldLabel.setAttribute("for", "label")
        
        var inputElement: Input = Input(element: inputField, label:"Email address", type:.input, id:"email", name:nil, for:nil, checked:nil, labelElement: inputFieldLabel)
        self.inputs.append(inputElement)
        
        var radio = document.createElement("input")
        radio.type = "radio"
        radio.id = .string("standard")
        radio.checked = .boolean(true)
        radio.name = .string("inputFieldType")
        
        var radioLabel = document.createElement("label")
        radioLabel.innerText = .string("Standard")
        radioLabel.setAttribute("for", "standard")
        
        inputElement = Input(element: radio, label:"Standard", type:.radio, id:"standard", name:"inputFieldType", for:"standard", checked:true, labelElement:radioLabel)
        self.inputs.append(inputElement)
        
        var radioPass = document.createElement("input")
        radioPass.type = "radio"
        radioPass.id = .string("password")
        radioPass.name = .string("inputFieldType")
        
        var radioLabelPass = document.createElement("label")
        radioLabelPass.innerText = .string("Password")
        radioLabelPass.setAttribute("for", "password")
        
        inputElement = Input(element: radioPass, label:"Password", type:.radio, id:"password", name:"inputFieldType", for:"password", checked:false, labelElement:radioLabelPass)
        self.inputs.append(inputElement)
        
        self.inputs.forEach{ input in
            input.register(listener:self)
        }
    }
    
    override func initializeComponent() {
        self.inputField.register(listener:self)
    }
    
    func inputFieldChanged(value:String) {
        let outputContainer = JSObject.global.document.getElementById("outputContainer")
        let index = Int(outputContainer.children.length.number! + 1)
        var element = JSObject.global.document.createElement("div")
        
        let hidden = self.inputField.type == .standard ? "not hidden" : "hidden"
        
        element.innerText = .string("\(index). Input field changed to \(value) (\(hidden))")
        
        outputContainer.prepend(element)
    }
    
    func inputChanged(value: [JSValue], type: InputType) {
        switch type {
        case .input:
            self.inputField.label = value[0].target.value
        case .radio:
            if (value[0].target.name == .string("inputFieldType")) {
                if (value[0].target.id == .string("standard")) {
                    self.inputField.type = .standard
                } else {
                    self.inputField.type = .password
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
