//
//  MainMenuScrene.swift
//  CatchTheCat
//
//  Created by Almir Khialov on 09.09.2024.
//

import SpriteKit
import AVFoundation

class MainMenuScene: SKScene {
    var startButton: SKSpriteNode!
    var settingsButton: SKSpriteNode!
    var aboutButton: SKSpriteNode!
    var videoNode: SKVideoNode!
    var avPlayer: AVPlayer!

    override func didMove(to view: SKView) {
        setupVideoBackground()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(updateLocalization), name: Notification.Name("LanguageChanged"), object: nil)
        updateLocalization()
    }

    @objc func updateLocalization() {
        // Update button images if necessary
        startButton.texture = SKTexture(imageNamed: "startButton")
        settingsButton.texture = SKTexture(imageNamed: "settingsButton")
        aboutButton.texture = SKTexture(imageNamed: "aboutButton")
        
        // Update labels
        for node in children {
            if let label = node as? SKLabelNode {
                label.text = LocalizationManager.shared.localizedString(for: label.text ?? "")
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("LanguageChanged"), object: nil)
    }

    func setupVideoBackground() {
        // Load the video file
        guard let videoURL = Bundle.main.url(forResource: "backgroundVideo", withExtension: "mp4") else {
            print("Failed to find video file.")
            return
        }

        // Create an AVPlayer with the video URL
        avPlayer = AVPlayer(url: videoURL)
        avPlayer.actionAtItemEnd = .none
        
        // Create an SKVideoNode with the AVPlayer
        videoNode = SKVideoNode(avPlayer: avPlayer)
        videoNode.size = size
        videoNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        videoNode.zPosition = -1  // Place video behind other elements
        videoNode.play()
        
        // Add video node as a child
        addChild(videoNode)

        // Observe end of video and restart playback
        NotificationCenter.default.addObserver(self, selector: #selector(restartVideo), name: .AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
    }

    @objc func restartVideo() {
        avPlayer.seek(to: .zero)
        avPlayer.play()
    }

    func setupUI() {
        setupButtonsAndLabels()
    }

    func setupButtonsAndLabels() {
        let buttonSpacing: CGFloat = 100
        let buttonYPosition: CGFloat = size.height / 2
        let labelSpacing: CGFloat = 10

        // Create Start Button
        startButton = SKSpriteNode(imageNamed: "startButton")
        startButton.position = CGPoint(x: size.width / 2, y: buttonYPosition + buttonSpacing / 1)
        startButton.name = "startButton"
        addChild(startButton)

        // Create Settings Button
        settingsButton = SKSpriteNode(imageNamed: "settingsButton")
        settingsButton.position = CGPoint(x: size.width / 2, y: buttonYPosition - buttonSpacing / 2)
        settingsButton.name = "settingsButton"
        addChild(settingsButton)

        // Create About Button
        aboutButton = SKSpriteNode(imageNamed: "aboutButton")
        aboutButton.position = CGPoint(x: size.width / 2, y: 100) // Adjust position for bottom of the screen
        aboutButton.name = "aboutButton"
        addChild(aboutButton)

        // Add Labels
        addChild(createLabel(text: LocalizationManager.shared.localizedString(for: "Start Game"), position: CGPoint(x: size.width / 2, y: buttonYPosition + buttonSpacing / 2 - 40 - labelSpacing), fontSize: 24))
        addChild(createLabel(text: LocalizationManager.shared.localizedString(for: "Settings"), position: CGPoint(x: size.width / 2, y: buttonYPosition - buttonSpacing / 2 - 40 - labelSpacing), fontSize: 24))
        addChild(createLabel(text: LocalizationManager.shared.localizedString(for: "About the App"), position: CGPoint(x: size.width / 2, y: 60), fontSize: 24)) // Label for About the App button
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        if startButton.contains(location) {
            if let view = self.view {
                let gameScene = GameScene(size: view.bounds.size)
                gameScene.scaleMode = .aspectFill
                view.presentScene(gameScene, transition: SKTransition.flipHorizontal(withDuration: 1.0))
            }
        } else if settingsButton.contains(location) {
            if let view = self.view {
                let settingsScene = SettingsScene(size: view.bounds.size)
                settingsScene.scaleMode = .aspectFill
                view.presentScene(settingsScene, transition: SKTransition.flipHorizontal(withDuration: 1.0))
            }
        } else if aboutButton.contains(location) {
            presentAboutViewController()
        }
    }

    func presentAboutViewController() {
        if let viewController = self.view?.window?.rootViewController {
            let aboutVC = AboutViewController()
            aboutVC.modalPresentationStyle = .fullScreen
            viewController.present(aboutVC, animated: true, completion: nil)
        }
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
}
