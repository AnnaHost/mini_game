//
//  ViewController.swift
//  mini_Game
//
//  Created by Анна Гареева on 16.05.2020.
//  Copyright © 2020 Anna Gareeva. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var GameFieldView: gameFieldView!
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var buttonLabel: UIButton!
    @IBOutlet weak var counter: UILabel!
    
    private var isGameActive = false
    private var gameInterval: TimeInterval = 0
    private var gameTimer: Timer?
    private var figureTimer: Timer?
    private let duration: TimeInterval = 2
    private var score = 0

    func objectTapped() {
        guard isGameActive else { return }
        score+=1
        repositionFigure()
    }
    
    @IBAction func valueChanged(_ sender: UIStepper) {
        updateUI()
    }
    @IBAction func buttonTapped(_ sender: UIButton) {
        if isGameActive {
            endGame()
        }    else {
            startGame()
        }
    }
    
    private func startGame() {
        score = 0
        repositionFigure()
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(gameTimerTick),
            userInfo: nil,
            repeats: true)
        gameInterval = stepper.value
        isGameActive = true
        updateUI()
    }
    private func repositionFigure() {
        figureTimer?.invalidate()
        figureTimer = Timer.scheduledTimer(
            timeInterval: 2,
            target: self,
            selector: #selector(figureTimerTick),
            userInfo: nil,
            repeats: true)
        figureTimer?.fire()
    }
    
    private func endGame() {
        isGameActive = false
        updateUI()
        gameTimer?.invalidate()
        figureTimer?.invalidate()
        //counter.text = "Последний счет: \(score)"
    }
    
    private func updateUI() {
        GameFieldView.isShapeHidden = !isGameActive
        stepper.isEnabled = !isGameActive
        if isGameActive {
            counter.text = "Счёт: \(score) "
            timer.text = "Осталось: \(Int(gameInterval)) сек"
            buttonLabel.setTitle("Остановить", for: .normal)
        } else {
            counter.text = "Последний счёт: \(score)"
            timer.text = "Время: \(Int(stepper.value)) сек"
            buttonLabel.setTitle("Начать", for: .normal)
        }
    }
    
    @objc private func gameTimerTick(){
            gameInterval-=1
        if gameInterval <= 0 {
            endGame()
        } else {
             updateUI()
        }
    }
    
    @objc private func  figureTimerTick() {
        GameFieldView.randomizeShapes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stepper.value = 30
        stepper.stepValue = 5
        GameFieldView.layer.borderWidth = 1
        GameFieldView.layer.borderColor = UIColor.gray.cgColor
        GameFieldView.layer.cornerRadius = 5
        updateUI()
        GameFieldView.shapeHitHandler = { [weak self] in
        self?.objectTapped()
        }
    }
}

