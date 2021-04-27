import JavaScriptKit

protocol NavigationUpdateListener {
    func navigationUpdated(item:String)
}

class Navigation {
    var navItems: [String]
    var listeners: [NavigationUpdateListener] = []
    
    var navigate: JSClosure?
        
    init(items: [String]) {
        let document = JSObject.global.document
        let navigationList = document.getElementById("sidebarNavUl")
        
        self.navItems = items
        
        self.navigate = JSClosure { item in
            self.onNavigate(item:item)
        }
        
        self.navItems.forEach{ navItem in
            var element = document.createElement("li")
            element.innerText = .string(navItem)
            element.onclick = .object(navigate!)
            
            navigationList.appendChild(element)
        }
    }
    
    func register(listener: NavigationUpdateListener) {
        self.listeners.append(listener)
    }
    
    func onNavigate(item: [JSValue]) {
        self.listeners.forEach { listener in
            if let item = item[0].target.innerText.string {
                listener.navigationUpdated(item:item)
            }
        }
    }
}
