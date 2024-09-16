//
//  GameOverScene.swift
//  CatchTheCat
//
//  Created by Almir Khialov on 10.09.2024.
//

import SpriteKit

class GameOverScene: SKScene {
    var finalScoreLabel: SKLabelNode!
    var restartButton: SKSpriteNode!

    override func didMove(to view: SKView) {
        setupBackground()
        setupGameOverUI()
    }

    func setupBackground() {
        let background = SKSpriteNode(imageNamed: "backgroundImageGameOver")
        background.size = size
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1
        addChild(background)
    }

    func setupGameOverUI() {
        updateGameOverUI()
    }
    
    func updateGameOverUI() {
        finalScoreLabel?.removeFromParent()
        restartButton?.removeFromParent()
        
        finalScoreLabel = SKLabelNode(text: NSLocalizedString("Game Over", comment: "Game over label"))
        finalScoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + 150)
        finalScoreLabel.fontSize = 50
        finalScoreLabel.fontColor = SKColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1.0)
        finalScoreLabel.fontName = "Chalkduster"
        finalScoreLabel.zPosition = 1
        addChild(finalScoreLabel)
        
        let scoreLabel = SKLabelNode(text: "")
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        scoreLabel.fontSize = 40
        scoreLabel.fontColor = .white
        scoreLabel.fontName = "Chalkduster"
        scoreLabel.zPosition = 1
        if let score = UserDefaults.standard.value(forKey: "lastScore") as? Int {
            scoreLabel.text = String(format: NSLocalizedString("Score: %d", comment: "Score label"), score)
        }
        addChild(scoreLabel)
        
        let buttonTexture = SKTexture(imageNamed: "restartButtonImageGameOver")
        let buttonWidth: CGFloat = 150
        let buttonHeight: CGFloat = 75

        restartButton = SKSpriteNode(texture: buttonTexture)
        restartButton.size = CGSize(width: buttonWidth, height: buttonHeight)
        restartButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - 100)
        restartButton.name = "restartButton"
        restartButton.zPosition = 1
        addChild(restartButton)

        let restartLabel = SKLabelNode(text: NSLocalizedString("Restart Game", comment: "Restart game label"))
        restartLabel.fontName = "Chalkduster"
        restartLabel.fontSize = 24
        restartLabel.fontColor = .white
        restartLabel.position = CGPoint(x: size.width / 2, y: restartButton.position.y - buttonHeight / 2 - 20)
        restartLabel.zPosition = 1

        let shadow = SKLabelNode(text: NSLocalizedString("Restart Game", comment: "Shadow for restart game label"))
        shadow.fontName = "Chalkduster"
        shadow.fontSize = 24
        shadow.fontColor = .black
        shadow.position = CGPoint(x: size.width / 2 + 2, y: restartButton.position.y - buttonHeight / 2 - 22)
        shadow.zPosition = 0.5
        shadow.alpha = 0.5
        addChild(shadow)

        addChild(restartLabel)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        if let node = atPoint(location) as? SKSpriteNode {
            if node.name == "restartButton" {
                restartGame()
            }
        }
    }

    func restartGame() {
        let newGameScene = GameScene(size: size)
        newGameScene.scaleMode = .aspectFill
        if let view = self.view {
            view.presentScene(newGameScene, transition: SKTransition.flipHorizontal(withDuration: 1.0))
        }
    }
}
