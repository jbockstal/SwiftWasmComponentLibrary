import JavaScriptKit

protocol StoryUpdateListener {
    func storyUpdated()
}

class Story {
    var name: String
    var component: Component
    var inputs: [Input] = []
    var listeners: [StoryUpdateListener] = []
    var hasOutputs = true
    
    init (name: String, component: Component) {
        self.name = name
        self.component = component
    }
    
    func inputsAsHTML() -> JSValue {
        var div = JSObject.global.document.createElement("div")
        
        if (self.inputs.count == 0) {
            div.innerText = "No available inputs"
        } else {
            self.inputs.forEach { input in
                if (!input.labelElement!.isNull) {
                    if (input.type == .input) {
                        div.appendChild(input.labelElement)
                        div.appendChild(JSObject.global.document.createElement("br"))
                        div.appendChild(input.element)
                    } else {
                        div.appendChild(input.element)
                        div.appendChild(input.labelElement)
                    }
                } else {
                    div.appendChild(input.element)
                }

                div.appendChild(JSObject.global.document.createElement("br"))
            }
        }
        
        return div
    }
    
    func register(listener: StoryUpdateListener) {
        self.listeners.append(listener)
    }
    
    func componentAsHTML() -> JSValue {
        let div = JSObject.global.document.createElement("div")
        var title = JSObject.global.document.createElement("h2")
        title.innerText = .string(self.name)
        
        div.appendChild(title)
        div.appendChild(self.component.asHTML())
        div.appendChild(JSObject.global.document.createElement("br"))
        div.appendChild(JSObject.global.document.createElement("br"))
        
        return div
    }
    
    func initializeComponent() {
        
    }
    
    func initializeInputs() {
        self.inputs = []
    }
}
