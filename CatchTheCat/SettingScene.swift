//
//  SettingScene.swift
//  CatchTheCat
//
//  Created by Almir Khialov on 09.09.2024.
//
import SpriteKit

class SettingsScene: SKScene {
    var languageButton: SKSpriteNode!

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "settingsBackground")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = size
        addChild(background)
        
        setupButtons()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLocalization), name: Notification.Name("LanguageChanged"), object: nil)
        updateLocalization()  // Убедитесь, что UI обновляется при первом отображении
    }

    func setupButtons() {
        let buttonSpacing: CGFloat = 120
        let initialYPosition: CGFloat = size.height - 150
        
        // Back Button
        let backButton = createButton(imageName: "backButton", position: CGPoint(x: size.width / 2, y: initialYPosition), name: "backButton")
        addChild(backButton)
        addChild(createLabel(text: LocalizationManager.shared.localizedString(for: "Back Button"), position: CGPoint(x: size.width / 2, y: initialYPosition - 60), fontSize: 20))
        
        // Sound Switch
        let soundSwitch = createButton(imageName: UserDefaults.standard.bool(forKey: "soundOn") ? "soundOn" : "soundOff", position: CGPoint(x: size.width / 2, y: initialYPosition - buttonSpacing), name: "soundSwitch")
        addChild(soundSwitch)
        addChild(createLabel(text: LocalizationManager.shared.localizedString(for: "Sound Switch"), position: CGPoint(x: size.width / 2, y: initialYPosition - buttonSpacing - 60), fontSize: 20))
        
        // Music Switch
        let musicSwitch = createButton(imageName: UserDefaults.standard.bool(forKey: "musicOn") ? "musicOn" : "musicOff", position: CGPoint(x: size.width / 2, y: initialYPosition - 2 * buttonSpacing), name: "musicSwitch")
        addChild(musicSwitch)
        addChild(createLabel(text: LocalizationManager.shared.localizedString(for: "Music Switch"), position: CGPoint(x: size.width / 2, y: initialYPosition - 2 * buttonSpacing - 60), fontSize: 20))
        
        // Reset Button
        let resetButton = createButton(imageName: "resetButton", position: CGPoint(x: size.width / 2, y: initialYPosition - 3 * buttonSpacing), name: "resetButton")
        addChild(resetButton)
        addChild(createLabel(text: LocalizationManager.shared.localizedString(for: "Reset High Score"), position: CGPoint(x: size.width / 2, y: initialYPosition - 3 * buttonSpacing - 60), fontSize: 20))
        
        // Language Switch Button
        languageButton = createButton(imageName: getLanguageButtonImageName(), position: CGPoint(x: size.width / 2, y: initialYPosition - 4 * buttonSpacing), name: "languageSwitch")
        addChild(languageButton)
        addChild(createLabel(text: LocalizationManager.shared.localizedString(for: "Language"), position: CGPoint(x: size.width / 2, y: initialYPosition - 4 * buttonSpacing - 60), fontSize: 20))
    }
    
    func createButton(imageName: String, position: CGPoint, name: String) -> SKSpriteNode {
        let button = SKSpriteNode(imageNamed: imageName)
        button.position = position
        button.name = name
        button.zPosition = 1
        return button
    }
    
    func createLabel(text: String, position: CGPoint, fontSize: CGFloat) -> SKLabelNode {
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = text
        label.fontSize = fontSize
        label.fontColor = .white
        label.position = position
        label.zPosition = 1
        return label
    }
    
    func getLanguageButtonImageName() -> String {
        let currentLanguage = LocalizationManager.shared.getCurrentLanguage()
        return currentLanguage == "en" ? "englishFlag" : "russianFlag"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if let node = atPoint(location) as? SKSpriteNode {
            switch node.name {
            case "backButton":
                goToMainMenu()
                print("Button 'Back' clicked: Navigates to the main menu")
                
            case "soundSwitch":
                toggleSound()
                print("Button 'Sound Switch' clicked: Toggles sound effects on or off")
                
            case "musicSwitch":
                toggleMusic()
                print("Button 'Music Switch' clicked: Toggles background music on or off")
                
            case "resetButton":
                resetHighScore()
                print("Button 'Reset High Score' clicked: Resets the high score to zero")
                
            case "languageSwitch":
                toggleLanguage()
                print("Button 'Language' clicked: Toggles between English and Russian")
                
            default:
                break
            }
        }
    }
    
    func goToMainMenu() {
        let menuScene = MainMenuScene(size: size)
        let transition = SKTransition.flipHorizontal(withDuration: 1.0)
        if let view = self.view {
            view.presentScene(menuScene, transition: transition)
        }
    }
    
    func toggleSound() {
        let currentSetting = UserDefaults.standard.bool(forKey: "soundOn")
        UserDefaults.standard.set(!currentSetting, forKey: "soundOn")
        if let soundSwitch = childNode(withName: "soundSwitch") as? SKSpriteNode {
            soundSwitch.texture = SKTexture(imageNamed: UserDefaults.standard.bool(forKey: "soundOn") ? "soundOn" : "soundOff")
        }
    }
    
    func toggleMusic() {
        let currentSetting = UserDefaults.standard.bool(forKey: "musicOn")
        UserDefaults.standard.set(!currentSetting, forKey: "musicOn")
        if let musicSwitch = childNode(withName: "musicSwitch") as? SKSpriteNode {
            musicSwitch.texture = SKTexture(imageNamed: UserDefaults.standard.bool(forKey: "musicOn") ? "musicOn" : "musicOff")
        }
        NotificationCenter.default.post(name: Notification.Name("MusicSettingChanged"), object: nil)
    }
    
    func resetHighScore() {
        UserDefaults.standard.set(0, forKey: "highScore")
    }
    
    func toggleLanguage() {
        let currentLanguage = LocalizationManager.shared.getCurrentLanguage()
        let newLanguage = currentLanguage == "en" ? "ru" : "en"
        
        LocalizationManager.shared.setCurrentLanguage(newLanguage)
        
        NotificationCenter.default.post(name: Notification.Name("LanguageChanged"), object: nil)
        
        // Обновление текущей сцены
        updateLocalization()
    }
    
    @objc func updateLocalization() {
        print("Updating localization...")
        for node in children {
            if let label = node as? SKLabelNode {
                label.text = LocalizationManager.shared.localizedString(for: label.text ?? "")
            }
        }
        
        if let languageSwitch = childNode(withName: "languageSwitch") as? SKSpriteNode {
            languageSwitch.texture = SKTexture(imageNamed: getLanguageButtonImageName())
        }
    }
}
