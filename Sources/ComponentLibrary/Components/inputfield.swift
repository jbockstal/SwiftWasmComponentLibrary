import JavaScriptKit

enum InputFieldType: String {
    case standard = "text"
    case password = "password"
}

protocol InputFieldChangeListener {
    func inputFieldChanged(value:String)
}

class InputField: Component {
    // inputs
    var label: JSValue
    var id: JSValue
    private var _type: InputFieldType = .standard
    var type: InputFieldType {
        set {
            _type = newValue
            self.updateInputFieldType()
        }
        get {
            return _type
        }
    }
    
    // outputs
    var inputFieldChange: JSClosure?
    
    // other properties
    let document = JSObject.global.document
    var input: JSValue
    var listeners: [InputFieldChangeListener] = []
    
    
    init(label: JSValue, id: JSValue, type: InputFieldType) {
        self.label = label
        self.id = id
        
        self.input = document.createElement("input")
        self.input.id = self.id
        self.input.type = .string(self.type.rawValue)
        
        self.type = type
        
        self.inputFieldChange = JSClosure { value in
            self.onInputFieldChange(value:value)
        }
    }
    
    func asHTML() -> JSValue {
        let div = document.createElement("div")
        
        var label = document.createElement("label")
        label.innerHTML = self.label
        label.setAttribute("for", self.id)
        
        
        
        if let onChange = self.inputFieldChange {
            self.input.oninput = .object(onChange)
        }
        
        div.appendChild(label)
        div.appendChild(document.createElement("br"))
        div.appendChild(self.input)
        
        return div
    }
    
    func register(listener: InputFieldChangeListener) {
        self.listeners.append(listener)
    }
    
    func onInputFieldChange(value: [JSValue]) {
        self.listeners.forEach { listener in
            listener.inputFieldChanged(value: value[0].target.value.string!)
        }
    }
    
    func updateInputFieldType() {
        self.input.type = .string(self.type.rawValue)
    }
}
