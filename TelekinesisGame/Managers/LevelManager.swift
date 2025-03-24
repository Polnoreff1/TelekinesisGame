import Foundation

class LevelManager {
    
    static let shared = LevelManager()
    var nowPlaying = 0
    
    var isTutorialShowed: Bool {
        get{
            return UserDefaults.standard.bool(forKey: "isTutorialShowed")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isTutorialShowed")
        }
    }
    
    var ammo: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ammo")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ammo")
        }
    }
    
    var playerSitkaCount: Int {
        get {
            return UserDefaults.standard.integer(forKey: "playerSitkaCount")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "playerSitkaCount")
        }
    }
    
    var isAquariumTutorialShowed: Bool {
        get{
            return UserDefaults.standard.bool(forKey: "isAquariumTutorialShowed")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isAquariumTutorialShowed")
        }
    }
    
    var isFishingTutorialShowed: Bool {
        get{
            return UserDefaults.standard.bool(forKey: "isFishingTutorialShowed")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isFishingTutorialShowed")
        }
    }
    
    var selectedShellName: String {
        get{
            return UserDefaults.standard.string(forKey: "selectedShellName") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "selectedShellName")
        }
    }
    
    var selectedCoralsName: String {
        get{
            return UserDefaults.standard.string(forKey: "selectedCoralsName") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "selectedCoralsName")
        }
    }
    
    var selectedPlantsName: String {
        get{
            return UserDefaults.standard.string(forKey: "selectedPlantsName") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "selectedPlantsName")
        }
    }
    
    
    
    var isDailyBonusCollected: Bool {
        get{
            return UserDefaults.standard.bool(forKey: "DailyBonusCollected")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "DailyBonusCollected")
        }
    }
    
    var money: Int {
        get {
            return UserDefaults.standard.integer(forKey: "money")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "money")
        }
    }
    
    var isFirstStartCompleted: Bool {
        get{
            return UserDefaults.standard.bool(forKey: "IsFirstStartCompleted")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "IsFirstStartCompleted")
        }
    }
    
    let dishStorage: [Dish] = [
        Dish(name: "Steak with Vegetables", imageName: "steakWithVegetablesImage", ingredients: [Ingredient(name: "Beef", imageName: "beefImage"), Ingredient(name: "Carrot", imageName: "carrotImage"), Ingredient(name: "Potato", imageName: "potatoImage")]),
        Dish(name: "Mushroom Salad", imageName: "mushroomSaladImage", ingredients: [Ingredient(name: "Cheese", imageName: "cheeseImage"), Ingredient(name: "Mushroom", imageName: "mushroomImage"), Ingredient(name: "Tomato", imageName: "tomatoImage")]),
        Dish(name: "Fish Soup", imageName: "fishSoupImage", ingredients: [Ingredient(name: "Fish", imageName: "fishImage"), Ingredient(name: "Onion", imageName: "onionImage"), Ingredient(name: "Potato", imageName: "potatoImage")])
    ]
    
    init() { loadSkins() }
    
    private let skinsKey = "skinsKey"
    
    var skins: [SwordSkin] = []
    
    func loadSkins() {
        if let data = UserDefaults.standard.data(forKey: skinsKey) {
            let decoder = JSONDecoder()
            if let loadedSkins = try? decoder.decode([SwordSkin].self, from: data) {
                self.skins = loadedSkins
            }
        } else {
            self.skins = [
                SwordSkin(name: "defaultSword", isPurchased: true, price: 0, isSelected: true, gameName: "defaultSword", shopName: "defaultSwordShop"),
                SwordSkin(name: "blueSword", isPurchased: false, price: 1000, isSelected: false, gameName: "blueSword", shopName: "blueSwordShop"),
                SwordSkin(name: "pinkSword", isPurchased: false, price: 1000, isSelected: false, gameName: "pinkSword", shopName: "pinkSwordShop"),
                SwordSkin(name: "blackSword", isPurchased: false, price: 1000, isSelected: false, gameName: "blackSword", shopName: "blackSwordShop")
            ]
        }
    }
    
    func saveSkins() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(skins) {
            UserDefaults.standard.set(encoded, forKey: skinsKey)
        }
    }
    
    func buySkin(_ skin: SwordSkin) {
        if let index = skins.firstIndex(where: { $0.name == skin.name }) {
            if !skins[index].isPurchased {
                skins[index].isPurchased = true
                saveSkins()
            }
        }
    }
    
    func selectSkin(_ skin: SwordSkin) {
        for index in skins.indices {
            skins[index].isSelected = false
        }
        
        if let index = skins.firstIndex(where: { $0.name == skin.name }) {
            skins[index].isSelected = true
            saveSkins()
        }
    }
    
    var selectedSkin: SwordSkin? {
        return skins.first(where: { $0.isSelected })
    }
}


struct SavedFish: Codable {
    var id = UUID()
    var name: String
    var textureName: String
    var weight: Double
}

struct FishFromStorage: Codable {
    var name: String
    var textureName: String
    var weight: Double
}

struct SwordSkin: Codable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var isPurchased: Bool
    var price: Int
    var isSelected: Bool
    var gameName: String
    var shopName: String
}

struct Dish: Codable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var imageName: String
    var ingredients: [Ingredient]
}

struct Ingredient: Codable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var imageName: String
}

let inAppFontName = "Gummy Bear"
