import Foundation

class LevelManager {
    
    static let shared = LevelManager()
    
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
    
    init() { }
}
