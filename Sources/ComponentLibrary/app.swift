import JavaScriptKit

class App: NavigationUpdateListener, StoryUpdateListener {
    var navigation: Navigation = Navigation(items:["Button", "Input Field", "Menu Item", "Carousel", "Search Field", "Filter"])
    var currentStory: Story?
    
    init() {
        self.navigationUpdated(item:"Button")
        self.navigation.register(listener:self)
    }
    
    func navigationUpdated(item: String) {
        // https://stackoverflow.com/questions/3141064/how-to-stop-all-timeouts-and-intervals-using-javascript
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
        case "Input Field":
            let inputField = InputField(label:.string("Email address"), id:.string("email"), type:.standard)
            newStory = InputFieldStory(name:"Input Field", component:inputField)
        case "Menu Item":
            let menuItem = MenuItem(title:"Veggie tomato mix", price:"€ 2,50", imgSrc:"veggietomatomix.jpeg", imgAlt:"Picture of veggie tomato mix")
            newStory = MenuItemStory(name: "Menu Item", component:menuItem)
        case "Carousel":
            let menuItemOne = MenuItem(title:"Veggie tomato mix", price:"€ 2,50", imgSrc:"veggietomatomix.jpeg", imgAlt:"Picture of veggie tomato mix")
            let menuItemTwo = MenuItem(title:"French fries", price:"€ 1,50", imgSrc:"https://images.bruzzket.be/2018-12/frietjes_c_photonews.jpg?auto=format&crop=edges%252C%2520entropy&fit=crop&ixlib=php-1.1.0&q=95&w=260&s=979337250e2a1d6422f2be6d361098e2", imgAlt:"Picture of french fries")
            let menuItemThree = MenuItem(title:"Spaghetti", price:"€ 2,00", imgSrc:"spaghetti.jpeg", imgAlt:"Picture of spaghetti")
            
            let carousel = Carousel(items:[menuItemOne, menuItemTwo, menuItemThree])
            newStory = CarouselStory(name:"Carousel", component:carousel)
        case "Search Field":
            let searchField = SearchField(searchLabel:"Menu Item Name", buttonLabel:"Start search")
            newStory = SearchFieldStory(name: "Search Field", component: searchField)
        case "Filter":
            let filter = Filter(items:["John", "Amanda", "Sam", "Justin"], filterLabel:"Name")
            newStory = FilterStory(name:"Filter", component: filter)
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
        var outputContainer = JSObject.global.document.getElementById("outputs")
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
