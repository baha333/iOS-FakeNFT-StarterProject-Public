import Foundation

struct BasketSortStorage {
    
    private let userDefaults = UserDefaults.standard
    private let key = "BasketSortType"
   
    var basketSortType: BasketSortType {
        get {
            guard let typeRawValue = userDefaults.string(forKey: key),
                  let type = BasketSortType(rawValue: typeRawValue)
            else { return .name }
            return type
        }
        set {
            userDefaults.setValue(newValue.rawValue, forKey: key)
        }
    }
}
