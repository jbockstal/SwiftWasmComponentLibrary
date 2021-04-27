import JavaScriptKit

protocol InputChangeListener {
    func inputChanged(value: [JSValue], type:InputType)
}

enum InputType {
    case input
    case radio
    case checkbox
}

class Input {
    var element: JSValue
    var label: String
    var type: InputType
    var id: String
    var name: String?
    var `for`: String?
    var checked: Bool?
    var labelElement: JSValue?
    
    var listeners: [InputChangeListener] = []
    var inputChange: JSClosure?
    
    init(element: JSValue, label: String, type: InputType, id: String, name: String?, for: String?, checked: Bool?, labelElement: JSValue) {
        self.element = element
        self.labelElement = labelElement
        self.label = label
        self.type = type
        self.id = id
        self.name = name
        self.for = `for`
        self.checked = checked
        
        self.inputChange = JSClosure { value in
            self.onInputChanged(value:value)
        }
        
        switch self.type {
        case .input:
            self.element.oninput = .object(inputChange!)
        case .radio:
            self.element.onchange = .object(inputChange!)
        case .checkbox:
            self.element.onchange = .object(inputChange!)
        }
        
    }
    
    func register(listener: InputChangeListener) {
        self.listeners.append(listener)
    }
    
    func onInputChanged(value: [JSValue]) {
        self.listeners.forEach { listener in
            listener.inputChanged(value:value, type:self.type)
        }
    }
}
