import JavaScriptKit

protocol SearchChangedListener {
    func searchChanged(value:String)
}

class SearchField: Component, ButtonClickListener {
    // inputs
    var searchLabel: JSValue
    var buttonLabel: JSValue
    
    // other properties
    let document = JSObject.global.document
    var listeners: [SearchChangedListener] = []
    var input: InputField
    var button: Button
    
    init(searchLabel: JSValue, buttonLabel: JSValue) {
        self.searchLabel = searchLabel
        self.buttonLabel = buttonLabel
        
        self.input = InputField(label:self.searchLabel, id:self.searchLabel, type:.standard)
        self.button = Button(label:self.buttonLabel, type:.primary)
        button.register(listener:self)
    }
    
    func asHTML() -> JSValue {
        var div = document.createElement("div")
        div.classList.add("searchContainer")
        
        div.appendChild(self.input.asHTML())
        div.appendChild(self.button.asHTML())
        
        return div
    }
    
    func register(listener: SearchChangedListener) {
        self.listeners.append(listener)
    }
    
    func buttonClicked() {
        self.listeners.forEach { listener in
            listener.searchChanged(value:self.input.getValue().string!)
        }
    }
    
    func updateSearchLabel(value:JSValue) {
        self.searchLabel = value
        self.input.label = value
    }
    
    func updateButtonLabel(value:JSValue) {
        self.buttonLabel = value
        self.button.label = value
    }
}
