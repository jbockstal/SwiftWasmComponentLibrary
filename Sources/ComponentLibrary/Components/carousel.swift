import JavaScriptKit

class Carousel: Component {
    // inputs
    var items: [Component]
    private var _interval: Int = 3000
    var interval: Int {
        set {
            if (newValue >= 500) {
                _interval = newValue
                self.updateInterval()
            }
        }
        
        get {
            return _interval
        }
    }
        
    // other properties
    let document = JSObject.global.document
    var currentItemIndex: Int?
    var slide: JSClosure?
    let customCSS: String = """
        .carouselDot {
          height: 15px;
          width: 15px;
          margin: 0 2px;
          background-color: #bbb;
          border-radius: 50%;
          display: inline-block;
          transition: background-color 0.6s ease;
        }
        .active {
          background-color: #717171;
        }
        #carouselItemContainer {
            height: fit-content
        }
        #dotsDiv {
            position: relative;
            top: -100px;
        }
    """
        
    
    init(items: [Component]) {
        var carouselStyle = document.getElementById("carouselStyle")
        
        if carouselStyle != nil {
            carouselStyle.innerText = .string(customCSS)
        } else {
            var style = document.createElement("style")
            style.id = "carouselStyle"
            style.innerText = .string(customCSS)
            document.head.appendChild(style)
        }
        
        self.items = items
        
        if self.items.count > 0 {
            self.currentItemIndex = 0
        }
        
        self.slide = JSClosure { _ in
            self.onSlide()
        }
    }
        
    func asHTML() -> JSValue {
        let div = document.createElement("div")
        
        if let currentItemIndex = self.currentItemIndex {
            var innerDiv = document.createElement("div")
            innerDiv.id = "carouselItemContainer"
            innerDiv.innerHTML = nil
            innerDiv.appendChild(self.items[currentItemIndex].asHTML())
            
            var dotsDiv = document.createElement("div")
            dotsDiv.id = "dotsDiv"
            dotsDiv.innerHTML = nil
            
            self.items.enumerated().forEach { (index, item) in
                let span = document.createElement("span")
                span.classList.add("carouselDot")
                
                if (currentItemIndex == index) {
                    span.classList.add("active")
                } else {
                    span.classList.remove("active")
                }
                
                dotsDiv.appendChild(span)
            }
            
            div.appendChild(innerDiv)
            div.appendChild(dotsDiv)
        }
        
        if let slide = self.slide {
            let window = JSObject.global.window
            window.setInterval(slide, self.interval)
        }
        
        return div
    }
    
    func onSlide() {        
        if var currentItemIndex = self.currentItemIndex {
            if (currentItemIndex < self.items.count - 1) {
                self.currentItemIndex = currentItemIndex + 1
            } else {
                self.currentItemIndex = 0
            }
        }
        
        if let currentItemIndex = self.currentItemIndex {
            var div = document.getElementById("carouselItemContainer")
            div.innerHTML = nil
            div.appendChild(self.items[currentItemIndex].asHTML())
            
            var dotsDiv = document.getElementById("dotsDiv")
            dotsDiv.innerHTML = nil
            
            self.items.enumerated().forEach { (index, item) in
                let span = document.createElement("span")
                span.classList.add("carouselDot")
                
                if (self.currentItemIndex == index) {
                    span.classList.add("active")
                } else {
                    span.classList.remove("active")
                }
                
                dotsDiv.appendChild(span)
            }
        }
    }
    
    func updateInterval() {
        if let slide = self.slide {            
            let window = JSObject.global.window
            var highestId = window.setInterval(";").number!;
            var i = 0.0
            
            while (i < highestId) {
                window.clearInterval(i);
                i += 1
            }
        }
    }
}
