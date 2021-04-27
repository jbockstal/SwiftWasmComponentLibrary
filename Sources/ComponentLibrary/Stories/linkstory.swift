import JavaScriptKit

class LinkStory: Story, LinkClickListener, InputChangeListener {
    let document = JSObject.global.document
    var link: Link {
        get {
            return component as! Link
        }
    }
    
    override func initializeComponent() {
        self.link.register(listener:self)
    }
    
    override func initializeInputs() {
        var inputFieldLabel = document.createElement("input")
        // TODO: Refactor, label is used as value
        inputFieldLabel.value = .string("Go to Google")
        inputFieldLabel.id = .string("label")
        inputFieldLabel.type = "input"
        
        var inputFieldLabelLabel = document.createElement("label")
        inputFieldLabelLabel.innerText = "Label"
        inputFieldLabelLabel.setAttribute("for", "label")
        
        var inputElement: Input = Input(element: inputFieldLabel, label:"Login", type:.input, id:"label", name:nil, for:nil, checked:nil, labelElement: inputFieldLabelLabel)
        self.inputs.append(inputElement)
        
        var inputFieldUrl = document.createElement("input")
        // TODO: Refactor, label is used as value
        inputFieldUrl.value = .string("https://www.google.com")
        inputFieldUrl.id = .string("url")
        inputFieldUrl.type = "input"
        
        var inputFieldUrlLabel = document.createElement("label")
        inputFieldUrlLabel.innerText = "Url"
        inputFieldUrlLabel.setAttribute("for", "url")
        
        inputElement = Input(element: inputFieldUrl, label:"Login", type:.input, id:"label", name:nil, for:nil, checked:nil, labelElement: inputFieldUrlLabel)
        self.inputs.append(inputElement)
        
        var inputFieldTooltip = document.createElement("input")
        // TODO: Refactor, label is used as value
        inputFieldTooltip.value = .string("Click me to navigate")
        inputFieldTooltip.id = .string("tooltip")
        inputFieldTooltip.type = "input"
        
        var inputFieldTooltipLabel = document.createElement("label")
        inputFieldTooltipLabel.innerText = "Tooltip"
        inputFieldTooltipLabel.setAttribute("for", "tooltip")
        
        inputElement = Input(element: inputFieldTooltip, label:"Login", type:.input, id:"label", name:nil, for:nil, checked:nil, labelElement: inputFieldTooltipLabel)
        self.inputs.append(inputElement)
        
        self.inputs.forEach{ input in
            input.register(listener:self)
        }
    }
    
    func linkClicked() {
        var outputContainer = JSObject.global.document.getElementById("outputContainer")
        var index = Int(outputContainer.children.length.number! + 1)
        var element = JSObject.global.document.createElement("div")
        element.innerText = .string("\(index). Clicked link '\(self.link.label)' to navigate to '\(self.link.url)'")
        
        outputContainer.prepend(element)
    }
    
    func inputChanged(value: [JSValue], type: InputType) {
        switch type {
        case .input:
            var id = value[0].target.id.string!
            switch (id) {
            case "label":
                self.link.label = value[0].target.value
            case "url":
                self.link.url = value[0].target.value
            case "tooltip":
                self.link.tooltip = value[0].target.value
            default:
                JSObject.global.console.log("Unknown input field change")
            }
        default:
            JSObject.global.console.log("Unknown input change")
        }
        
        self.listeners.forEach { item in
            item.storyUpdated()
        }
    }
}
