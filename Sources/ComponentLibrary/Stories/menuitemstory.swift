import JavaScriptKit

class MenuItemStory: Story, InputChangeListener {
    let document = JSObject.global.document
    var menuItem: MenuItem {
        get {
            return component as! MenuItem
        }
    }
    
    override func initializeComponent() {
        // TODO: Refactor: move logic
        self.hasOutputs = false
    }
    
    override func initializeInputs() {
        var inputFieldTitle = document.createElement("input")
        // TODO: Refactor, label is used as value
        inputFieldTitle.value = .string("Veggie tomato mix")
        inputFieldTitle.id = .string("title")
        inputFieldTitle.type = "input"
        
        var inputFieldTitleLabel = document.createElement("label")
        inputFieldTitleLabel.innerText = "Title"
        inputFieldTitleLabel.setAttribute("for", "title")
        
        var inputElement: Input = Input(element: inputFieldTitle, label:"Veggie tomato mix", type:.input, id:"title", name:nil, for:nil, checked:nil, labelElement: inputFieldTitleLabel)
        self.inputs.append(inputElement)
        
        var inputFieldPrice = document.createElement("input")
        // TODO: Refactor, label is used as value
        inputFieldPrice.value = .string("€ 2,50")
        inputFieldPrice.id = .string("price")
        inputFieldPrice.type = "input"
        
        var inputFieldPriceLabel = document.createElement("label")
        inputFieldPriceLabel.innerText = "Price"
        inputFieldPriceLabel.setAttribute("for", "price")
        
        inputElement = Input(element: inputFieldPrice, label:"€ 2,50", type:.input, id:"price", name:nil, for:nil, checked:nil, labelElement: inputFieldPriceLabel)
        self.inputs.append(inputElement)
        
        var inputFieldImg = document.createElement("input")
        // TODO: Refactor, label is used as value
        inputFieldImg.value = .string("https://i2.wp.com/wallflowerkitchen.com/wp-content/uploads/2017/08/TomatoRisotto1.jpg?w=800&ssl=1")
        inputFieldImg.id = .string("imgSrc")
        inputFieldImg.type = "input"
        
        var inputFieldImgLabel = document.createElement("label")
        inputFieldImgLabel.innerText = "Image source"
        inputFieldImgLabel.setAttribute("for", "imgSrc")
        
        inputElement = Input(element: inputFieldImg, label:"https://i2.wp.com/wallflowerkitchen.com/wp-content/uploads/2017/08/TomatoRisotto1.jpg?w=800&ssl=1", type:.input, id:"imgSrc", name:nil, for:nil, checked:nil, labelElement: inputFieldImgLabel)
        self.inputs.append(inputElement)
        
        self.inputs.forEach{ input in
            input.register(listener:self)
        }
    }
    
    func inputChanged(value: [JSValue], type: InputType) {
        switch type {
        case .input:
            var id = value[0].target.id.string!
            switch (id) {
            case "title":
                self.menuItem.title = value[0].target.value.string!
            case "price":
                self.menuItem.price = value[0].target.value.string!
            case "imgSrc":
                self.menuItem.imgSrc = value[0].target.value.string!
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
