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
    let customCSS: String = """
      .customButtonPrimary {
        cursor: pointer;
        color: white;
        background-color: #FA4A0C;
        border-radius: 30px;
        border: none;
        font-size: 17px;
        padding: 10px 20px;
      }
      .customButtonPrimary:focus {
        outline: 0;
      }
      .customButtonSecondary {
        cursor: pointer;
        background-color: white;
        color: #FA4A0C;
        border-radius: 30px;
        border: 1px solid #FA4A0C;
        font-size: 17px;
        padding: 10px 20px;
      }
      .customButtonSecondary:focus {
        outline: 0;
      }
    """
    
    
    init(label: JSValue, type: ButtonType) {
        var buttonStyle = document.getElementById("buttonStyle")
        
        if buttonStyle != nil {
            buttonStyle.innerText = .string(customCSS)
        } else {
            var style = document.createElement("style")
            style.id = "buttonStyle"
            style.innerText = .string(customCSS)
            document.head.appendChild(style)
        }
        
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
