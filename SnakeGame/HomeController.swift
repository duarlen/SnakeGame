//
//  HomeController.swift
//  SnakeGame
//
//  Created by top on 2020/8/21.
//  Copyright © 2020 top. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    let gameView = GameView()
    let scoreLable = UILabel()
    let btnStart = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = view.bounds.width - 40
        gameView.frame = CGRect(x: 20, y: 60, width: width, height: width)
        gameView.backgroundColor = .gray
        gameView.delegate = self
        view.addSubview(gameView)
        gameView.reset()
        
        btnStart.backgroundColor = .lightGray
        btnStart.setTitle("开始", for: .normal)
        btnStart.setTitle("暂停", for: .selected)
        btnStart.addTarget(self, action: #selector(startGame(button:)), for: .touchUpInside)
        btnStart.bounds = CGRect(x: 0, y: 0, width: 60, height: 30)
        btnStart.center = CGPoint(x: view.bounds.width / 2, y: gameView.frame.maxY + 100)
        view.addSubview(btnStart)
        
        let btnReset = UIButton()
        btnReset.backgroundColor = .lightGray
        btnReset.setTitle("重置", for: .normal)
        btnReset.addTarget(self, action: #selector(reset), for: .touchUpInside)
        btnReset.frame = CGRect(x: 20, y: gameView.frame.maxY + 20, width: 80, height: 40)
        view.addSubview(btnReset)
        
        scoreLable.backgroundColor = .lightGray
        scoreLable.textColor = .white
        scoreLable.textAlignment = .center
        scoreLable.text = "0分"
        scoreLable.frame = CGRect(x: view.bounds.width - 100, y: gameView.frame.maxY + 20, width: 80, height: 40)
        view.addSubview(scoreLable)
        
        let btnLeft = UIButton()
        btnLeft.backgroundColor = .lightGray
        btnLeft.setTitle("左", for: .normal)
        btnLeft.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        btnLeft.center = CGPoint(x: btnStart.frame.minX - 60, y: btnStart.center.y)
        btnLeft.tag = 0
        btnLeft.addTarget(self, action: #selector(changeDirectionr(button:)), for: .touchUpInside)
        view.addSubview(btnLeft)
        
        let btnRight = UIButton()
        btnRight.backgroundColor = .lightGray
        btnRight.setTitle("右", for: .normal)
        btnRight.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        btnRight.center = CGPoint(x: btnStart.frame.maxX + 60, y: btnStart.center.y)
        btnRight.tag = 1
        btnRight.addTarget(self, action: #selector(changeDirectionr(button:)), for: .touchUpInside)
        view.addSubview(btnRight)
        
        let btnTop = UIButton()
        btnTop.backgroundColor = .lightGray
        btnTop.setTitle("上", for: .normal)
        btnTop.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        btnTop.center = CGPoint(x: btnStart.center.x, y: btnStart.frame.minY - 40)
        btnTop.tag = 2
        btnTop.addTarget(self, action: #selector(changeDirectionr(button:)), for: .touchUpInside)
        view.addSubview(btnTop)
        
        let btnBottom = UIButton()
        btnBottom.backgroundColor = .lightGray
        btnBottom.setTitle("下", for: .normal)
        btnBottom.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        btnBottom.center = CGPoint(x: btnStart.center.x, y: btnStart.frame.maxY + 40)
        btnBottom.tag = 3
        btnBottom.addTarget(self, action: #selector(changeDirectionr(button:)), for: .touchUpInside)
        view.addSubview(btnBottom)
    }
    
    @objc func reset() {
        gameView.reset()
    }
    
    @objc func startGame(button: UIButton) {
        if gameView.isGaming {
            gameView.pauseGame()
            button.isSelected = false
        } else {
            gameView.startGame()
            button.isSelected = true
        }
    }
    
    @objc func changeDirectionr(button: UIButton) {
        switch button.tag {
            case 0: gameView.set(direction: .left)
            case 1: gameView.set(direction: .right)
            case 2: gameView.set(direction: .top)
            case 3: gameView.set(direction: .bottom)
            default: break
        }
    }
}

extension HomeController: GameViewDelegate {
    
    func gameView(_ gameView: GameView, score: Int) {
        scoreLable.text = "\(score) 分"
    }
    
    func gameOver(_ gameView: GameView) {
        gameView.reset()
        btnStart.isSelected = false
        scoreLable.text = "游戏结束"
    }
}
