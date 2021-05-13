import JavaScriptKit

class SearchFieldStory: Story, InputChangeListener, SearchChangedListener {
    let document = JSObject.global.document
    var searchField: SearchField {
        get {
            return component as! SearchField
        }
    }
    
    override func initializeComponent() {
        self.searchField.register(listener:self)
    }

    override func initializeInputs() {
        var searchLabel = document.createElement("input")
        searchLabel.value = .string("Menu item name")
        searchLabel.id = .string("searchLabel")
        searchLabel.type = "input"
        
        var searchLabelLabel = document.createElement("label")
        searchLabelLabel.innerText = "Search label"
        searchLabelLabel.setAttribute("for", "searchLabel")
        
        var inputElement: Input = Input(element: searchLabel, label:"Menu item name", type:.input, id:"searchLabel", name:nil, for:nil, checked:nil, labelElement: searchLabelLabel)
        self.inputs.append(inputElement)
        
        var buttonLabel = document.createElement("input")
        buttonLabel.value = .string("Start search")
        buttonLabel.id = .string("buttonLabel")
        buttonLabel.type = "input"
        
        var buttonLabelLabel = document.createElement("label")
        buttonLabelLabel.innerText = "Button label"
        buttonLabelLabel.setAttribute("for", "buttonLabel")
        
        inputElement = Input(element: buttonLabel, label:"Start search", type:.input, id:"buttonLabel", name:nil, for:nil, checked:nil, labelElement: buttonLabelLabel)
        self.inputs.append(inputElement)
        
        self.inputs.forEach{ input in
            input.register(listener:self)
        }
    }
    
    func searchChanged(value:String) {
        var outputContainer = JSObject.global.document.getElementById("outputs")
        var index = Int(outputContainer.children.length.number! + 1)
        var element = JSObject.global.document.createElement("div")
        element.innerText = .string("\(index). Started search for \(self.searchField.searchLabel) by clicking button \(self.searchField.buttonLabel), searching for '\(value)'")
        
        outputContainer.prepend(element)
    }
    
    func inputChanged(value: [JSValue], type: InputType) {
        switch type {
        case .input:
            var id = value[0].target.id.string!
            switch (id) {
            case "searchLabel":
                self.searchField.updateSearchLabel(value:value[0].target.value)
            case "buttonLabel":
                self.searchField.updateButtonLabel(value:value[0].target.value)
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
