//
//  LocalizationManager.swift
//  CatchTheCat
//
//  Created by Almir Khialov on 14.09.2024.
//
import Foundation

class LocalizationManager {
    static let shared = LocalizationManager()
    private init() {}
    
    func getCurrentLanguage() -> String {
        return UserDefaults.standard.string(forKey: "language") ?? "en"
    }

    func setCurrentLanguage(_ language: String) {
        UserDefaults.standard.set(language, forKey: "language")
    }

    func localizedString(for key: String) -> String {
        let language = getCurrentLanguage()
        let path = Bundle.main.path(forResource: language, ofType: "lproj") ?? ""
        let bundle = Bundle(path: path)
        return NSLocalizedString(key, bundle: bundle ?? Bundle.main, comment: "")
    }
    
    func getLanguageButtonImageName() -> String {
        let currentLanguage = getCurrentLanguage()
        return currentLanguage == "en" ? "englishFlag" : "russianFlag"
    }
}
