//
//  cat.swift
//  CatchTheCat
//
//  Created by Almir Khialov on 13.09.2024.
//

import UIKit

class AvatarCatViewController: UIViewController {
    
    // UIImageView для кота
    var catImageView: UIImageView!
    
    // Анимации кота
    var wavingAnimation: [UIImage] = []
    var jumpingAnimation: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Настройка интерфейса
        setupUI()
        
        // Настройка анимаций кота
        setupCatAnimations()
    }
    
    // Настройка интерфейса
    func setupUI() {
        view.backgroundColor = .white
        
        // Картинка кота
        catImageView = UIImageView(image: UIImage(named: "cat_standing")) // Начальное изображение кота
        catImageView.frame = CGRect(x: view.frame.width / 2 - 75, y: 200, width: 150, height: 150)
        catImageView.contentMode = .scaleAspectFit
        view.addSubview(catImageView)
        
        // Добавление жестов для кота
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(catTapped))
        catImageView.isUserInteractionEnabled = true
        catImageView.addGestureRecognizer(tapGesture)
        
        // Кнопка для начала махания лапой
        let waveButton = UIButton(frame: CGRect(x: 50, y: view.frame.height - 150, width: view.frame.width - 100, height: 50))
        waveButton.setTitle("Махать лапой", for: .normal)
        waveButton.backgroundColor = .systemBlue
        waveButton.addTarget(self, action: #selector(startWaving), for: .touchUpInside)
        view.addSubview(waveButton)
        
        // Кнопка для прыжка
        let jumpButton = UIButton(frame: CGRect(x: 50, y: view.frame.height - 80, width: view.frame.width - 100, height: 50))
        jumpButton.setTitle("Прыжок", for: .normal)
        jumpButton.backgroundColor = .systemGreen
        jumpButton.addTarget(self, action: #selector(startJumping), for: .touchUpInside)
        view.addSubview(jumpButton)
    }
    
    // Настройка анимаций кота
    func setupCatAnimations() {
        // Анимация махания лапой (добавить последовательность изображений)
        for i in 1...10 {
            if let image = UIImage(named: "cat_wave_\(i)") { // Имена изображений должны быть последовательными
                wavingAnimation.append(image)
            }
        }
        
        // Анимация прыжка (добавить последовательность изображений)
        for i in 1...8 {
            if let image = UIImage(named: "cat_jump_\(i)") {
                jumpingAnimation.append(image)
            }
        }
    }
    
    // Действие при касании кота
    @objc func catTapped() {
        // Простая реакция на касание
        let alert = UIAlertController(title: "Мяу!", message: "Котик рад!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Окей", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // Анимация махания лапой
    @objc func startWaving() {
        catImageView.animationImages = wavingAnimation
        catImageView.animationDuration = 1.0
        catImageView.animationRepeatCount = 3
        catImageView.startAnimating()
    }
    
    // Анимация прыжка
    @objc func startJumping() {
        catImageView.animationImages = jumpingAnimation
        catImageView.animationDuration = 1.2
        catImageView.animationRepeatCount = 1
        catImageView.startAnimating()
        
        // Анимация движения прыжка
        UIView.animate(withDuration: 1.2, animations: {
            self.catImageView.frame.origin.y -= 100
        }) { _ in
            UIView.animate(withDuration: 1.0) {
                self.catImageView.frame.origin.y += 100
            }
        }
    }
}
