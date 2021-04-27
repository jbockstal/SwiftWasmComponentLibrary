import JavaScriptKit

protocol LinkClickListener {
    func linkClicked()
}

class Link: Component {
    // inputs
    var label: JSValue
    var tooltip: JSValue?
    var url: JSValue
    
    // outputs
    var clickLink: JSClosure?
    
    // other properties
    let document = JSObject.global.document
    var listeners: [LinkClickListener] = []
    let customCSS: String = """
        .linkContainer {
          cursor: pointer;
          color: #FA4A0C;
        }
        .linkContainer .linkTooltip {
          visibility: hidden;
          background-color: white;
          color: black;
          text-align: center;
          padding: 5px 0;
          border-radius: 6px;
          position: relative;
          z-index: 1;
          bottom: 25px;
          margin-left: -50%;
        }
        .linkContainer:hover .linkTooltip {
            visibility: visible;
        }
    """
    
    init(label: JSValue, url: JSValue, tooltip: JSValue?) {
        var linkStyle = document.getElementById("linkStyle")
        
        if linkStyle != nil {
            linkStyle.innerText = .string(customCSS)
        } else {
            var style = document.createElement("style")
            style.id = "linkStyle"
            style.innerText = .string(customCSS)
            document.head.appendChild(style)
        }
        
        self.label = label
        self.url = url
        if let tooltip = tooltip {
            self.tooltip = tooltip
        }
        
        self.clickLink = JSClosure { _ in
            self.onClickLink()
        }
    }
    
    func asHTML() -> JSValue {
        var div = document.createElement("div")
        div.classList.add("linkContainer")
        div.innerText = self.label
        
        if let clickLink = self.clickLink {
            div.onclick = .object(clickLink)
        }
        
        if let tooltip = self.tooltip {
            var span = document.createElement("span")
            span.innerText = tooltip
            span.classList.add("linkTooltip")
            
            div.appendChild(span)
        }
        
        return div
    }
    
    func register(listener: LinkClickListener) {
        self.listeners.append(listener)
    }
    
    func onClickLink() {
        self.listeners.forEach { listener in
            listener.linkClicked()
        }
    }
    
}
