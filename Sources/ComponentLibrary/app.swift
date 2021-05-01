import JavaScriptKit

class App: NavigationUpdateListener, StoryUpdateListener {
    var navigation: Navigation = Navigation(items:["Button", "Link", "Input Field", "Menu Item", "Carousel", "Search Field"])
    var currentStory: Story?
    
    init() {
        self.navigationUpdated(item:"Button")
        self.navigation.register(listener:self)
    }
    
    func navigationUpdated(item: String) {
        // Clear all intervals
        // Set a fake timeout to get the highest timeout id
        var highestId = JSObject.global.window.setInterval(";").number!;
        var i = 0.0
        
        while (i < highestId) {
            JSObject.global.window.clearInterval(i);
            i += 1
        }
        
        var newStory: Story?
        
        switch (item) {
        case "Button":
            let button = Button(label:.string("Login"), type:.primary)
            newStory = ButtonStory(name: "Button", component:button)
        case "Link":
            let link = Link(label:.string("Go to Google"), url:.string("https://www.google.com"), tooltip:.string("Click me to navigate"))
            newStory = LinkStory(name: "Link", component: link)
        case "Input Field":
            let inputField = InputField(label:.string("Email address"), id:.string("email"), type:.standard)
            newStory = InputFieldStory(name:"Input Field", component:inputField)
        case "Menu Item":
            let menuItem = MenuItem(title:"Veggie tomato mix", price:"€ 2,50", imgSrc:"https://i2.wp.com/wallflowerkitchen.com/wp-content/uploads/2017/08/TomatoRisotto1.jpg?w=800&ssl=1", imgAlt:"Picture of veggie tomato mix")
            newStory = MenuItemStory(name: "Menu Item", component:menuItem)
        case "Carousel":
            let menuItemOne = MenuItem(title:"Veggie tomato mix", price:"€ 2,50", imgSrc:"https://i2.wp.com/wallflowerkitchen.com/wp-content/uploads/2017/08/TomatoRisotto1.jpg?w=800&ssl=1", imgAlt:"Picture of veggie tomato mix")
            let menuItemTwo = MenuItem(title:"French fries", price:"€ 1,50", imgSrc:"https://images.bruzzket.be/2018-12/frietjes_c_photonews.jpg?auto=format&crop=edges%252C%2520entropy&fit=crop&ixlib=php-1.1.0&q=95&w=260&s=979337250e2a1d6422f2be6d361098e2", imgAlt:"Picture of french fries")
            let menuItemThree = MenuItem(title:"Pizza Margherita", price:"€ 2,00", imgSrc:"https://assets.tmecosys.com/image/upload/t_web767x639/img/recipe/ras/Assets/5802fab5-fdce-468a-a830-43e8001f5a72/Derivates/c00dc34a-e73d-42f0-a86e-e2fd967d33fe.jpg", imgAlt:"Picture of pizza margherita")
            
            let carousel = Carousel(items:[menuItemOne, menuItemTwo, menuItemThree])
            newStory = CarouselStory(name:"Carousel", component:carousel)
        case "Search Field":
            let searchField = SearchField(searchLabel:"Menu Item Name", buttonLabel:"Start search")
            newStory = SearchFieldStory(name: "Search Field", component: searchField)
        default:
            JSObject.global.console.log("Unknown navigation item clicked")
        }
        
        if let story = newStory {
            story.initializeComponent()
            story.initializeInputs()
            
            currentStory = story
            currentStory!.register(listener:self)
            self.updateComponentContainer()
            self.updateInputContainer()
            self.updateOutputContainer()
        }
    }
    
    func storyUpdated() {
        updateComponentContainer()
    }
    
    func updateComponentContainer() {
        if let currentStory = currentStory {
            var componentContainer = JSObject.global.document.getElementById("componentContainer")
            componentContainer.innerHTML = nil
            componentContainer.appendChild(currentStory.componentAsHTML())
        }
    }
    
    func updateInputContainer() {
        if let currentStory = currentStory {
            var inputContainer = JSObject.global.document.getElementById("inputContainer")
            inputContainer.innerHTML = nil
            
            var title = JSObject.global.document.createElement("h2")
            title.innerText = "Inputs"
            
            inputContainer.appendChild(title)
            inputContainer.appendChild(currentStory.inputsAsHTML())
        }
    }
    
    func updateOutputContainer() {
        var outputContainer = JSObject.global.document.getElementById("outputContainer")
        outputContainer.innerHTML = nil
        
        if let currentStory = currentStory {
            if (!currentStory.hasOutputs) {
                var noOutputs = JSObject.global.document.createElement("div")
                noOutputs.innerText = "No possible outputs"
                outputContainer.appendChild(noOutputs)
            }
        }
    }
}
