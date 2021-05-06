import JavaScriptKit

enum ButtonType {
    case primary
    case secondary
}

protocol ButtonClickListener {
    func buttonClicked()
}

class Button: Component {
    // inputs
    var label: JSValue
    private var _type: ButtonType = .primary
    var type: ButtonType {
        set {
            _type = newValue
            self.updateClassList()
        }
        get {
            return _type
        }
    }
    
    // outputs
    var clickButton: JSClosure?
    
    // other properties
    let document = JSObject.global.document
    var listeners: [ButtonClickListener] = []
    var button: JSValue
    
    
    init(label: JSValue, type: ButtonType) {        
        self.button = JSObject.global.document.createElement("button")
        self.label = label
        self.type = type
        
        self.clickButton = JSClosure { _ in
            self.onClickButton()
        }
    }
            
    func asHTML() -> JSValue {
        self.button.id = "buttonComponent"
        self.button.innerHTML = label
        
        if let click = self.clickButton {
            self.button.onclick = .object(click)
        }
        
        return self.button
    }
    
    func register(listener: ButtonClickListener) {
        self.listeners.append(listener)
    }
    
    private func onClickButton() {
        self.listeners.forEach { listener in
            listener.buttonClicked()
        }
    }
    
    private func updateClassList() {
        switch (self.type) {
        case .primary:
            self.button.classList.remove("customButtonSecondary")
            self.button.classList.add("customButtonPrimary")
        case .secondary:
            self.button.classList.remove("customButtonPrimary")
            self.button.classList.add("customButtonSecondary")
        }
    }
}
