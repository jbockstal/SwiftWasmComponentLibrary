import JavaScriptKit

class CarouselStory: Story, InputChangeListener {
    let document = JSObject.global.document
    var carousel: Carousel {
        get {
            return component as! Carousel
        }
    }
    
    override func initializeComponent() {
        self.hasOutputs = false
    }
    
    override func initializeInputs() {
        var inputField = document.createElement("input")
        inputField.value = .string("3000")
        inputField.id = .string("label")
        inputField.type = "input"
        
        var inputFieldLabel = document.createElement("label")
        inputFieldLabel.innerText = "Interval in ms (min 500)"
        inputFieldLabel.setAttribute("for", "label")
        
        var inputElement: Input = Input(element: inputField, label:"Interval in ms (min 500)", type:.input, id:"label", name:nil, for:nil, checked:nil, labelElement: inputFieldLabel)
        self.inputs.append(inputElement)
        
        self.inputs.forEach{ input in
            input.register(listener:self)
        }
    }
    
    func inputChanged(value: [JSValue], type: InputType) {
        switch type {
        case .input:
            if let time = Int(value[0].target.value.string!) {
                self.carousel.interval = time
            }
        default:
            JSObject.global.console.log("Unknown input change")
        }
        
        self.listeners.forEach { item in
            item.storyUpdated()
        }
    }
}
