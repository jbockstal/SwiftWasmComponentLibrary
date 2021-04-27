import JavaScriptKit

class MenuItem: Component {
    // inputs
    var title: String
    var price: String
    var imgSrc: String
    var imgAlt: String
    
    // outputs
    
    // other properties
    let document = JSObject.global.document
    let customCSS: String = """
        .menuItemContainer {
            text-align: center;
        }
        .menuItemImage {
            border-radius: 50%;
            width: 100px;
            height: 100px;
            position: relative;
            top: -250px;
        }
        .menuItemInfo {
            background-color: lightgrey;
            width: 125px;
            height: 120px;
            margin: 0 auto;
            border-radius: 15%;
            padding: 50px 25px 25px 25px;
            margin-top: 75px;
        }
        .menuItemTitle {
            font-weight: 700;
            font-size: 20px;
        }
        .menuItemPrice {
            font-size: 16px;
        }
    """
    
    
    init(title: String, price: String, imgSrc: String, imgAlt: String) {
        var menuItemStyle = document.getElementById("menuItemStyle")
        
        if menuItemStyle != nil {
            menuItemStyle.innerText = .string(customCSS)
        } else {
            var style = document.createElement("style")
            style.id = "menuItemStyle"
            style.innerText = .string(customCSS)
            document.head.appendChild(style)
        }
        
        self.title = title
        self.price = price
        self.imgSrc = imgSrc
        self.imgAlt = imgAlt
    }
    
    func asHTML() -> JSValue {
        let div = document.createElement("div")
        div.classList.add("menuItemContainer")
        
        var img = document.createElement("img")
        img.src = .string(self.imgSrc)
        img.alt = .string(self.imgAlt)
        img.classList.add("menuItemImage")
        
        let infoDiv = document.createElement("div")
        infoDiv.classList.add("menuItemInfo")
        
        var title = document.createElement("p")
        title.classList.add("menuItemTitle")
        title.innerText = .string(self.title)
        
        var price = document.createElement("p")
        price.classList.add("menuItemPrice")
        price.innerText = .string(self.price)
        
        infoDiv.appendChild(title)
        infoDiv.appendChild(price)
        div.appendChild(infoDiv)
        div.appendChild(img)
        
        return div
    }
}
