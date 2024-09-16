//
//  AboutViewController.swift
//  CatchTheCat
//
//  Created by Almir Khialov on 13.09.2024.
//

import UIKit

extension Notification.Name {
    static let languageChanged = Notification.Name("LanguageChanged")
}

class AboutViewController: UIViewController {
    
    // UI elements
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var aboutLabel: UILabel!
    private var rulesLabel: UILabel!
    private var developerLabel: UILabel!
    private var socialMediaLabel: UILabel!
    private var backButton: UIButton!
    
    private enum UIConstants {
        static let padding: CGFloat = 20
        static let buttonHeight: CGFloat = 50
        static let labelFontSize: CGFloat = 16
        static let titleFontSize: CGFloat = 24
        static let buttonCornerRadius: CGFloat = 10
        static let buttonFontSize: CGFloat = 18
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Initialize and configure UI elements
        setupScrollView()
        setupContentView()
        setupLabels()
        setupBackButton()
        
        // Set up constraints
        setupConstraints()
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
    }
    
    private func setupContentView() {
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func createLabel(text: String, fontSize: CGFloat, isBold: Bool, alignment: NSTextAlignment) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = isBold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
        label.textAlignment = alignment
        label.numberOfLines = 0
        label.textColor = .darkGray
        return label
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUI() // Обновляем UI после того, как экран полностью появился
    }
    
    private func setupLabels() {
        aboutLabel = createLabel(
            text: NSLocalizedString("About the App", comment: "Title for the About section"),
            fontSize: UIConstants.titleFontSize,
            isBold: true,
            alignment: .center
        )
        contentView.addSubview(aboutLabel)
        
        rulesLabel = createLabel(
            text: NSLocalizedString("""
                This captivating game is inspired by two adorable cats — Riki and Martin, who have not only become the main characters of the game but also its primary testers. The player’s task is to catch kittens, earn points, and progress through levels while avoiding obstacles.
                
                The goal of the game is to catch as many kittens as possible, earning points and moving to new levels. For each caught kitten, you gain +1 point, and for each missed one, you lose -1 point. But that’s not all: bonus kittens and bombs appear in the game, which can significantly affect your score:
                
                1. Game Rules:
                • A caught kitten gives +1 point.
                • A missed kitten deducts -1 point.
                • Bonus kittens increase your score by 50%.
                • Bombs reduce your score by 50%.
                • The game continues until all points are lost or enough kittens are caught to move to the next level.
                • To advance to the next level, you need to catch 100 kittens for the first level, 150 for the second, and so on.
                
                2. Objective of the Game:
                Catch as many kittens as possible, avoid bombs and bonuses to increase your score and progress through levels. Each new level becomes more challenging, as the speed of the kittens increases, but the reward grows as well.
                
                3. Levels and Difficulty:
                • As you progress to the next level, you’ll need to catch more and more kittens.
                • The difficulty increases with the speed of the kittens and the addition of new elements on the screen.
                
                4. Inspiration and Design:
                The game was created in honor of the developer’s real cats — Riki and Martin, who inspired this project. They are also the main testers of the game, helping to perfect every detail. The game features a simple and cute design, where kittens appear on the screen, and the player must catch them to earn points and advance to new levels.
                
                Game Development:
                The game was developed using SpriteKit, allowing for dynamic scenes and animations. The main mechanics are based on the movement of the kittens and interaction with them through screen taps. The simple interface and engaging gameplay make the game suitable for all ages.
            """, comment: "Description of the game and its features"),
            fontSize: UIConstants.labelFontSize,
            isBold: false,
            alignment: .left
        )
        contentView.addSubview(rulesLabel)
        
        developerLabel = createLabel(
            text: NSLocalizedString("Developer: Almir Khialov", comment: "Developer's name"),
            fontSize: UIConstants.labelFontSize,
            isBold: false,
            alignment: .left
        )
        contentView.addSubview(developerLabel)
        
        socialMediaLabel = createLabel(
            text: NSLocalizedString("""
                Twitter: @almirkhialov
                Instagram: @almir328
                Telegram: @almir328
            """, comment: "Social media handles"),
            fontSize: UIConstants.labelFontSize,
            isBold: false,
            alignment: .left
        )
        contentView.addSubview(socialMediaLabel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: .languageChanged, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .languageChanged, object: nil)
    }
    
    private func setupBackButton() {
        backButton = UIButton(type: .system)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setTitle("Back", for: .normal)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        view.addSubview(backButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Set up constraints for scrollView and contentView
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Set up constraints for labels and button
            aboutLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.padding),
            aboutLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIConstants.padding),
            aboutLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UIConstants.padding),
            
            rulesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.padding),
            rulesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIConstants.padding),
            rulesLabel.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: UIConstants.padding),
            
            developerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.padding),
            developerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIConstants.padding),
            developerLabel.topAnchor.constraint(equalTo: rulesLabel.bottomAnchor, constant: UIConstants.padding),
            socialMediaLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.padding),
            socialMediaLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIConstants.padding),
            socialMediaLabel.topAnchor.constraint(equalTo: developerLabel.bottomAnchor, constant: UIConstants.padding),
            
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.padding),
            backButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIConstants.padding),
            backButton.topAnchor.constraint(equalTo: socialMediaLabel.bottomAnchor, constant: UIConstants.padding),
            backButton.heightAnchor.constraint(equalToConstant: UIConstants.buttonHeight),
            backButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UIConstants.padding)
        ])
    }
    
    @objc private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func updateUI() {
        aboutLabel.text = NSLocalizedString("About the App", comment: "Title for the About section")
        rulesLabel.text = NSLocalizedString("""
            This captivating game is inspired by two adorable cats — Riki and Martin, who have not only become the main characters of the game but also its primary testers. The player’s task is to catch kittens, earn points, and progress through levels while avoiding obstacles.
            
            The goal of the game is to catch as many kittens as possible, earning points and moving to new levels. For each caught kitten, you gain +1 point, and for each missed one, you lose -1 point. But that’s not all: bonus kittens and bombs appear in the game, which can significantly affect your score:
            
            1. Game Rules:
            • A caught kitten gives +1 point.
            • A missed kitten deducts -1 point.
            • Bonus kittens increase your score by 50%.
            • Bombs reduce your score by 50%.
            • The game continues until all points are lost or enough kittens are caught to move to the next level.
            • To advance to the next level, you need to catch 100 kittens for the first level, 150 for the second, and so on.
            
            2. Objective of the Game:
            Catch as many kittens as possible, avoid bombs and bonuses to increase your score and progress through levels. Each new level becomes more challenging, as the speed of the kittens increases, but the reward grows as well.
            
            3. Levels and Difficulty:
            • As you progress to the next level, you’ll need to catch more and more kittens.
            • The difficulty increases with the speed of the kittens and the addition of new elements on the screen.
            
            4. Inspiration and Design:
            The game was created in honor of the developer’s real cats — Riki and Martin, who inspired this project. They are also the main testers of the game, helping to perfect every detail. The game features a simple and cute design, where kittens appear on the screen, and the player must catch them to earn points and advance to new levels.
            
            Game Development:
            The game was developed using SpriteKit, allowing for dynamic scenes and animations. The main mechanics are based on the movement of the kittens and interaction with them through screen taps. The simple interface and engaging gameplay make the game suitable for all ages.
        """, comment: "Description of the game and its features")
        developerLabel.text = NSLocalizedString("Developer: Almir Khialov", comment: "Developer's name")
        socialMediaLabel.text = NSLocalizedString("""
            Twitter: @almirkhialov
            Instagram: @almir328
            Telegram: @almir328
        """, comment: "Social media handles")
    }
}
