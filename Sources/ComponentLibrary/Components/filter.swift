import JavaScriptKit

protocol FilterChangedListener {
    func filterChanged()
}

class Filter: Component, SearchChangedListener {
    // inputs
    var items: [String]
    var filteredItems: [String]
    var searchField: SearchField
    private var _filterLabel: String = ""
    var filterLabel: String {
        set {
            self._filterLabel = newValue
            self.searchField.updateSearchLabel(value:.string(newValue))
        }
        
        get {
            return self._filterLabel
        }
    }
    
    // other properties
    let document = JSObject.global.document
    var listeners: [FilterChangedListener] = []
    
    init(items: [String], filterLabel: String) {
        self.items = items
        self.filteredItems = items
        self.searchField = SearchField(searchLabel: .string(filterLabel), buttonLabel:"Filter")
        self.searchField.register(listener:self)
        self.filterLabel = filterLabel
    }
    
    func asHTML() -> JSValue {
        let div = document.createElement("div")
        div.appendChild(self.searchField.asHTML())
        
        self.filteredItems.forEach { item in
            var text = document.createElement("p")
            text.innerText = .string(item)
            div.appendChild(text)
        }
        
        return div
    }
    
    func register(listener: FilterChangedListener) {
        self.listeners.append(listener)
    }
    
    func searchChanged(value:String) {
        self.filteredItems = self.items.filter { item in
            return item.starts(with:value)
        }
        
        self.listeners.forEach { listener in
            listener.filterChanged()
        }
    }
}
