import JavaScriptKit

class FilterStory: Story, InputChangeListener, FilterChangedListener {
    let document = JSObject.global.document
    var filter: Filter {
        get {
            return component as! Filter
        }
    }
    
    override func initializeComponent() {
        self.filter.register(listener:self)
        // TODO: Refactor: move logic
        self.hasOutputs = false
    }
    
    override func initializeInputs() {
        var inputField = document.createElement("input")
        // TODO: Refactor, label is used as value
        inputField.value = .string("Name")
        inputField.id = .string("label")
        inputField.type = "input"
        
        var inputFieldLabel = document.createElement("label")
        inputFieldLabel.innerText = "Filter label"
        inputFieldLabel.setAttribute("for", "label")
        
        var inputElement: Input = Input(element: inputField, label:"Login", type:.input, id:"label", name:nil, for:nil, checked:nil, labelElement: inputFieldLabel)
        self.inputs.append(inputElement)
        
        self.inputs.forEach{ input in
            input.register(listener:self)
        }
    }
    
    func inputChanged(value: [JSValue], type: InputType) {
        switch type {
        case .input:
            self.filter.filterLabel = value[0].target.value.string!
        default:
            JSObject.global.console.log("Unknown input change")
        }
        
        self.listeners.forEach { item in
            item.storyUpdated()
        }
    }
    
    func filterChanged() {
        self.listeners.forEach { item in
            item.storyUpdated()
        }
    }
}
