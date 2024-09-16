//
//  GameScene.swift
//  CatchTheCat
//
//  Created by Almir Khialov on 09.09.2024.

import SpriteKit
import AVFoundation

class GameScene: SKScene {
    var basket: SKSpriteNode!
    var kittens: [SKSpriteNode] = []
    var scoreLabel: SKLabelNode!
    var recordLabel: SKLabelNode!
    var score = 0
    var caughtKittens = 0
    var missedKittens = 0
    let maxLevel = 5
    var isTouchingBasket = false
    var catchSoundPlayer: AVAudioPlayer?
    var missSoundPlayer: AVAudioPlayer?
    var backgroundMusicPlayer: AVAudioPlayer?
    var level = 1
    var targetKittensToCatch = 100
    var kitten3BonusFrequency: TimeInterval = 30.0
    var kitten4BombaFrequency: TimeInterval = 10.0
    var kittenImages = ["kitten", "kitten1", "kitten2", "kitten3", "kitten4"]
    var kittenFallSpeedMultiplier = 1.0
    var homeButton: SKLabelNode?
    var kitten3BonusTimer: Timer?
    var kitten4BombaTimer: Timer?
    var progressBarBackground: SKSpriteNode!
    var progressBar: SKSpriteNode!
    var currentLevel = 1
    
    override func didMove(to view: SKView) {
        loadSounds()
        setupScene()
        setupBasket()
        setupScoreLabels()
        setupHomeButton()
        setupProgressBar()
        startSpawningKittens()
        startKittenBonusTimer()
        startKittenBombaTimer()
        playBackgroundMusic()
    }
   
    
    func setupScene() {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = size
        background.zPosition = -1
        addChild(background)
    }
    
    func setupBasket() {
        basket = SKSpriteNode(imageNamed: "basket")
        basket.position = CGPoint(x: size.width / 2, y: basket.size.height / 2)
        basket.name = "basket"
        addChild(basket)
    }
    
    func setupScoreLabels() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = String(format: NSLocalizedString("Score: %d", comment: ""), 0)
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 70)
        scoreLabel.zPosition = 1
        addChild(scoreLabel)
        
        recordLabel = SKLabelNode(fontNamed: "Chalkduster")
        let highScore = UserDefaults.standard.integer(forKey: "highScore")
        recordLabel.text = String(format: NSLocalizedString("New Record: %d kittens!", comment: ""), highScore)
        recordLabel.fontSize = 20
        recordLabel.fontColor = .white
        recordLabel.position = CGPoint(x: size.width / 2, y: 30)
        recordLabel.zPosition = 1
        addChild(recordLabel)
    }

    
    func setupHomeButton() {
        homeButton = SKLabelNode(text: "Home")
        homeButton?.fontName = "Chalkduster"
        homeButton?.fontSize = 36
        homeButton?.fontColor = .white
        homeButton?.position = CGPoint(x: size.width - 59, y: size.height - 50)
        homeButton?.name = "homeButton"
        homeButton?.zPosition = 1
        
        let shadow = SKLabelNode(text: "Home")
        shadow.fontName = "Chalkduster"
        shadow.fontSize = 36
        shadow.fontColor = .black
        shadow.position = CGPoint(x: size.width - 57, y: size.height - 50)
        shadow.zPosition = 0.5
        
        addChild(shadow)
        if let homeButton = homeButton {
            addChild(homeButton)
        }
    }
    
    func setupProgressBar() {
        // Создание фона прогресс-бара
        progressBarBackground = SKSpriteNode(color: .white, size: CGSize(width: size.width - 40, height: 15))
        progressBarBackground.position = CGPoint(x: size.width / 2, y: size.height - 80)
        progressBarBackground.zPosition = 1
        addChild(progressBarBackground)
        
        // Прогресс-бар оранжевого цвета
        progressBar = SKSpriteNode(color: .orange, size: CGSize(width: 0, height: 15)) // Установили оранжевый цвет
        progressBar.position = CGPoint(x: progressBarBackground.position.x - (progressBarBackground.size.width / 2), y: progressBarBackground.position.y)
        progressBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        progressBar.zPosition = 2
        addChild(progressBar)
        
        // Анимация волны (небольшое движение вверх/вниз)
        let waveUp = SKAction.moveBy(x: 0, y: 2, duration: 0.5)
        let waveDown = SKAction.moveBy(x: 0, y: -2, duration: 0.5)
        let waveAnimation = SKAction.repeatForever(SKAction.sequence([waveUp, waveDown]))
        progressBar.run(waveAnimation)
        
        updateProgressBar() // Функция для обновления прогресс-бара
    }
    
    func calculateTargetKittensForLevel(_ level: Int) -> Int {
        if level <= maxLevel {
            return 100 + (level - 1) * 50
        } else {
            return 100 + (maxLevel - 1) * 50 + (level - maxLevel) * 100
        }
    }
    
    func updateProgressBar() {
        targetKittensToCatch = calculateTargetKittensForLevel(currentLevel)
        
        
        let progress = CGFloat(caughtKittens) / CGFloat(targetKittensToCatch)
        let newWidth = (size.width - 40) * progress
        
        // Создаем действие для изменения ширины прогресс-бара
        let resizeAction = SKAction.resize(toWidth: newWidth, duration: 0.3)
        
        // Обновляем ширину прогресс-бара
        progressBar.run(resizeAction)
        
        // Отладочный вывод
        print("Caught Kittens: \(caughtKittens), Target: \(targetKittensToCatch), Progress: \(progress)")

        // Проверяем, достигли ли мы цели для текущего уровня
        if caughtKittens >= targetKittensToCatch {
            caughtKittens = 0 // Сбросить количество пойманных котиков
            currentLevel += 1 // Переход на следующий уровень
            
            // Обновляем цель для нового уровня
            targetKittensToCatch = calculateTargetKittensForLevel(currentLevel)
            
            // Обновляем прогресс-бар для следующего уровня
            progressBar.size.width = 0
            updateProgressBar() // Рекурсивный вызов для обновления прогресс-бара
        }
    }

    func kittenCaught() {
        caughtKittens += 1
        updateProgressBar()
    }

    func kittenMissed() {
        missedKittens += 1
        caughtKittens = max(0, caughtKittens - 1)
        updateProgressBar() // Обновляем прогресс-бар

        if caughtKittens <= 0 && missedKittens > 0 {
            gameOver()
        }
    }
    
    func startSpawningKittens() {
        let spawnKittensAction = SKAction.run { [weak self] in
            self?.addKitten()
        }
        let waitAction = SKAction.wait(forDuration: 1.0)
        let sequence = SKAction.sequence([spawnKittensAction, waitAction])
        let repeatForever = SKAction.repeatForever(sequence)
        run(repeatForever)
    }
    
    func startKittenBonusTimer() {
        kitten3BonusTimer = Timer.scheduledTimer(withTimeInterval: kitten3BonusFrequency, repeats: true) { [weak self] _ in
            self?.addKitten3Bonus()
        }
    }
    
    func startKittenBombaTimer() {
        kitten4BombaTimer = Timer.scheduledTimer(withTimeInterval: kitten4BombaFrequency, repeats: true) { [weak self] _ in
            self?.addKitten4Bomba()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if basket.contains(location) {
            isTouchingBasket = true
        } else if let homeButton = homeButton, homeButton.contains(location) {
            if let view = self.view {
                let mainMenuScene = MainMenuScene(size: view.bounds.size)
                mainMenuScene.scaleMode = .aspectFill
                view.presentScene(mainMenuScene, transition: SKTransition.flipHorizontal(withDuration: 1.0))
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, isTouchingBasket else { return }
        let location = touch.location(in: self)
        basket.position = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouchingBasket = false
    }
    
    override func update(_ currentTime: TimeInterval) {
        var bombCaught = false
        var bonusCaught = false
        var kittenCaught = false

        for kitten in kittens {
            if basket.frame.intersects(kitten.frame), kitten.parent != nil {
                if kitten.name == "kitten4Bomba" {
                    bombCaught = true
                    kitten.removeFromParent()
                } else if kitten.name == "kitten3Bonus" {
                    bonusCaught = true
                    kitten.removeFromParent()
                } else {
                    score += 1
                    scoreLabel.text = "Score: \(score)"
                    caughtKittens += 1
                    kittenCaught = true
                    kitten.removeFromParent()
                }
            } else if kitten.position.y < 0, kitten.parent != nil {
                score -= 1
                scoreLabel.text = "Score: \(score)"
                missedKittens += 1
                kitten.removeFromParent()
            }
        }

        if bombCaught {
            score = Int(Double(score) * 0.5)
            scoreLabel.text = "Score: \(score)"
            playSound(named: "missSound")
        }

        if bonusCaught {
            score += Int(Double(score) * 0.3)
            scoreLabel.text = "Score: \(score)"
            playSound(named: "catchSound")
        }

        updateProgressBar()

        // Условие окончания игры
        if !kittenCaught && missedKittens > 0 && score <= 0 {
            gameOver()
        }

        // Логика повышения уровня
        if caughtKittens >= targetKittensToCatch {
            level += 1
            caughtKittens = 0

            // Логика увеличения цели для котиков на уровне
            if level <= 5 {
                targetKittensToCatch += 50  // Увеличиваем цель на 50 котиков до 5 уровня
            } else {
                targetKittensToCatch += 100  // Увеличиваем цель на 100 котиков после 5 уровня
            }

            kittenFallSpeedMultiplier *= 0.9  // Ускоряем падение котиков с каждым уровнем
            showLevelUpMessage(level: level)  // Уведомление о повышении уровня
        }
    }

    
    func showLevelUpMessage(level: Int) {
        let levelUpLabel = SKLabelNode(fontNamed: "Chalkduster")
        levelUpLabel.text = "Уровень \(level) достигнут!"
        levelUpLabel.fontSize = 30
        levelUpLabel.fontColor = .green
        levelUpLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        levelUpLabel.zPosition = 3
        addChild(levelUpLabel)
        
        // Анимация исчезновения текста
        levelUpLabel.run(SKAction.sequence([
            SKAction.fadeIn(withDuration: 0.5),
            SKAction.wait(forDuration: 2.0),
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.removeFromParent()
        ]))
    }
    
    
    func loadSounds() {
        let soundOn = UserDefaults.standard.bool(forKey: "soundOn")
        if soundOn {
            if let catchSoundURL = Bundle.main.url(forResource: "catchSound", withExtension: "wav") {
                do {
                    catchSoundPlayer = try AVAudioPlayer(contentsOf: catchSoundURL)
                } catch {
                    print("Error loading catch sound")
                }
            }
            
            if let missSoundURL = Bundle.main.url(forResource: "missSound", withExtension: "wav") {
                do {
                    missSoundPlayer = try AVAudioPlayer(contentsOf: missSoundURL)
                } catch {
                    print("Error loading miss sound")
                }
            }
        }
    }
    func playSound(named soundName: String) {
        let soundOn = UserDefaults.standard.bool(forKey: "soundOn")
        if soundOn {
            switch soundName {
            case "catchSound":
                catchSoundPlayer?.play()
                print("Playing catch sound") // Подтверждение воспроизведения
            case "missSound":
                missSoundPlayer?.play()
                print("Playing miss sound")
            default:
                break
            }
        }
    }
    func playBackgroundMusic() {
        if let musicURL = Bundle.main.url(forResource: "backgroundMusic", withExtension: "mp3") {
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: musicURL)
                backgroundMusicPlayer?.numberOfLoops = -1  // Зацикливаем музыку
                backgroundMusicPlayer?.play()
            } catch {
                print("Error loading background music: \(error)")
            }
        }
    }
    
    
    func addKitten() {
        let randomKittenImage = kittenImages.randomElement() ?? "kitten"
        let kitten = SKSpriteNode(imageNamed: randomKittenImage)
        let randomX = CGFloat.random(in: 0..<size.width)
        kitten.position = CGPoint(x: randomX, y: size.height + kitten.size.height)
        kitten.name = randomKittenImage
        addChild(kitten)
        
        let fallDuration = max((4.0 / kittenFallSpeedMultiplier) - (Double(score) / 1000.0), 1.0)
        kitten.run(SKAction.sequence([
            SKAction.moveTo(y: -kitten.size.height, duration: fallDuration),
            SKAction.removeFromParent()
        ]))
        kittens.append(kitten)
    }
    
    func addKitten3Bonus() {
        let kitten3Bonus = SKSpriteNode(imageNamed: "kitten3Bonus")
        let randomX = CGFloat.random(in: 0..<size.width)
        kitten3Bonus.position = CGPoint(x: randomX, y: size.height + kitten3Bonus.size.height)
        kitten3Bonus.name = "kitten3Bonus"
        addChild(kitten3Bonus)
        
        kitten3Bonus.run(SKAction.sequence([SKAction.moveTo(y: -kitten3Bonus.size.height, duration: 2.0), SKAction.removeFromParent()]))
        kittens.append(kitten3Bonus)
    }
    
    func addKitten4Bomba() {
        let kitten4Bomba = SKSpriteNode(imageNamed: "kitten4Bomba")
        let randomX = CGFloat.random(in: 0..<size.width)
        kitten4Bomba.position = CGPoint(x: randomX, y: size.height + kitten4Bomba.size.height)
        kitten4Bomba.name = "kitten4Bomba"
        addChild(kitten4Bomba)
        
        kitten4Bomba.run(SKAction.sequence([SKAction.moveTo(y: -kitten4Bomba.size.height, duration: 3.0), SKAction.removeFromParent()]))
        kittens.append(kitten4Bomba)
    }
    
    func gameOver() {
        print("Game Over triggered")
        self.removeAllActions()
        self.isUserInteractionEnabled = false
        
        let highScore = UserDefaults.standard.integer(forKey: "highScore")
        if score > highScore {
            UserDefaults.standard.set(score, forKey: "highScore")
            recordLabel.text = "Новый рекорд: \(score) котиков!"
        }
        UserDefaults.standard.set(score, forKey: "lastScore")
        
        if let view = self.view {
            let transition = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: view.bounds.size)
            gameOverScene.scaleMode = .aspectFill
            view.presentScene(gameOverScene, transition: transition)
        } else {
            print("Error: No SKView found")
        }
    }
    func toggleLanguage() {
        let currentLanguage = LocalizationManager.shared.getCurrentLanguage()
        let newLanguage = currentLanguage == "en" ? "ru" : "en"
        
        LocalizationManager.shared.setCurrentLanguage(newLanguage)
        
        // Обновляем все сцены
        NotificationCenter.default.post(name: Notification.Name("LanguageChanged"), object: nil)
    }
}
