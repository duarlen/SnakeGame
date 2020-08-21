//
//  GameView.swift
//  SnakeGame
//
//  Created by top on 2020/8/21.
//  Copyright © 2020 top. All rights reserved.
//

import UIKit

enum Direction {
    case left
    case right
    case top
    case bottom
}

enum GameResult {
    case success
    case failed
}

class Node: UIView { }

@objc protocol GameViewDelegate {
    
    /// 评分更改回调
    func gameView(_ gameView: GameView, score: Int)
    
    /// 游戏结束回调
    func gameOver(_ gameView: GameView)
}

class GameView: UIView {
    
    /// 列数
    private let columnCount = 30
    
    /// 行数
    private let rowCount = 30
    
    /// 列间距
    private var columnInterval: CGFloat = 1
    
    /// 行间距
    private var rowInterval: CGFloat = 1
    
    /// 以经纬度存放每个中心
    private var coordinates: [CGPoint] = []
    
    /// 移动方向
    private var direction = Direction.right
    
    /// 贪吃蛇
    private var snakeNodes: [Node] = []
    
    /// 食物
    private var food: Node?
    
    /// 计时器
    private var timer: DispatchSourceTimer?
    
    /// 速度
    private var speed: TimeInterval = 0.1
    
    /// 评分
    private(set) var score: Int = 0 { didSet { updateScore() } }
    
    /// 代理
    weak var delegate: GameViewDelegate?
    
    /// 是否正在游戏中
    var isGaming: Bool {
        return timer != nil
    }
}

private extension GameView {

    /// 创建所有的经纬度点
    func createCoordinates() {
        coordinates.removeAll()
        columnInterval = bounds.width / CGFloat(columnCount)
        rowInterval = bounds.height / CGFloat(rowCount)
        for i in 0 ..< rowCount {
            for j in 0 ..< columnCount {
                let coordinateX = (CGFloat(j) + 0.5) * columnInterval
                let coordinateY = (CGFloat(i) + 0.5) * rowInterval
                coordinates.append(CGPoint(x: coordinateX, y: coordinateY))
            }
        }
    }
    
    /// 创建节点
    func createNode(coordinate: CGPoint) -> Node {
        let node = Node()
        node.center = coordinate
        node.bounds = CGRect(x: 0, y: 0, width: columnInterval, height: rowInterval)
        node.backgroundColor = .black
        addSubview(node)
        return node
    }
    
    /// 创建蛇
    func createSnake() {
        snakeNodes.append(createNode(coordinate: coordinates[3]))
        snakeNodes.append(createNode(coordinate: coordinates[2]))
        snakeNodes.append(createNode(coordinate: coordinates[1]))
        snakeNodes.append(createNode(coordinate: coordinates[0]))
    }
    
    /// 移除蛇
    func removeSnake() {
        snakeNodes.forEach{ $0.removeFromSuperview() }
        snakeNodes.removeAll()
    }
    
    /// 创建食物
    func createFood() {
        let otherCoordinates = coordinates.filter{ !snakeNodes.map{ $0.center }.contains($0) }
        if otherCoordinates.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(otherCoordinates.count - 1) ))
            let coordinate = otherCoordinates[randomIndex]
            self.food = createNode(coordinate: coordinate)
        } else {
            stopTimer()
            delegate?.gameOver(self)
        }
    }

    /// 移除食物
    func removeFood() {
        self.food?.removeFromSuperview()
        self.food = nil
    }
    
    /// 移动蛇
    func moveSnake() {
        guard let firstNode = snakeNodes.first, let lastNode = snakeNodes.last else { return }
        var coordinate = firstNode.center
        switch direction {
        case .left:
            coordinate.x -= columnInterval
        case .right:
            coordinate.x += columnInterval
        case .top:
            coordinate.y -= rowInterval
        case .bottom:
            coordinate.y += rowInterval
        }
        lastNode.center = coordinate
        snakeNodes.removeLast()
        snakeNodes.insert(lastNode, at: 0)
    }
    
    /// 更新评分
    func updateScore() {
        self.delegate?.gameView(self, score: score)
    }

    /// 是否能够吃食物
    func isEnableEatFood(food: Node) -> Bool {
        for node in snakeNodes where node.frame.contains(food.center) {
            return true
        }
        return false
    }
    
    /// 吃食物
    func eatFood() {
        guard let food = food, isEnableEatFood(food: food) else { return }
        snakeNodes.append(food)
        createFood()
        score += 1
    }
    
    /// 游戏结束
    func gameOver() {
        guard let node = snakeNodes.first, !bounds.contains(node.center) else { return  }
        stopTimer()
        delegate?.gameOver(self)
    }
    
    /// 开始计时器
    func startTimer() {
        if timer != nil { return }
        timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
        timer?.schedule(wallDeadline: .now(), repeating: speed)
        timer?.setEventHandler(handler: {
            self.moveSnake()
            self.eatFood()
            self.gameOver()
        })
        timer?.resume()
    }
    
    /// 结束计时器
    func stopTimer() {
        if timer == nil { return }
        timer?.cancel()
        timer = nil
    }
}

extension GameView {
    
    /// 初始化
    func reset() {
        stopTimer()
        removeSnake()
        removeFood()
        createCoordinates()
        createSnake()
        createFood()
        
        score = 0
        updateScore()
    }
    
    /// 开始游戏
    func startGame() {
        startTimer()
    }
    
    /// 暂停游戏
    func pauseGame() {
        stopTimer()
    }
    
    /// 设置方向
    func set(direction: Direction) {
        if !isGaming { return }
        if (self.direction == .left || self.direction == .right) && (direction == .left || direction == .right) { return }
        if (self.direction == .top || self.direction == .bottom) && (direction == .top || direction == .bottom) { return }
        self.direction = direction
    }
}
