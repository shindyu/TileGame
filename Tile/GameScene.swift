import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let expLabel = SKLabelNode()
    let coinLabel = SKLabelNode()
    let shopLabel = SKLabelNode()
    var tileBoard: TileBoard!
    var cubicCount: Int!
    var expCount: Int = 0
    var lifeCount: Int = 10
    var coinCount: Int = 0
    var gameLevel: Int = 1
    var messageLabel = SKLabelNode()
    var tileSize: CGSize!
    var turnCount: Int = 1
    var isGameOver: Bool = false
    var player: Player!

    // MARK: - methods
    override func didMove(to view: SKView) {
        self.backgroundColor = .black
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsWorld.contactDelegate = self
        setupSwipeControls()

        expLabel.text = "⚔️\(expCount)"
        expLabel.name = "expLabel"
        expLabel.fontName = "Helvetica"
        expLabel.fontColor = UIColor().flatBlue
        expLabel.position = CGPoint(x: self.frame.midX / 2, y: self.frame.maxY - 100)
        self.addChild(expLabel)

        coinLabel.text = "💰\(coinCount)"
        coinLabel.name = "coinLabel"
        coinLabel.fontName = "Helvetica"
        coinLabel.fontColor = UIColor().flatYellow
        coinLabel.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 100)
        self.addChild(coinLabel)

        shopLabel.text = "⛺️shop"
        shopLabel.name = "shop"
        shopLabel.fontName = "Helvetica"
        shopLabel.fontColor = .gray
        shopLabel.position = CGPoint(x: self.frame.midX * 3 / 2, y: self.frame.maxY - 100)
        self.addChild(shopLabel)

        messageLabel.text = ""
        messageLabel.fontColor = UIColor().flatBlue
        messageLabel.position = CGPoint(x: self.frame.midX, y: 100)
        self.addChild(messageLabel)

        self.cubicCount = 4

        let nodeWidth = (self.frame.width - 40) / CGFloat(cubicCount)
        tileSize = CGSize(width: nodeWidth, height: nodeWidth)


        tileBoard = TileBoard(cubicCount: cubicCount, length: self.frame.width - 40)
        let board = tileBoard.board
        board.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(board)

        player = Player(rectOf: tileSize, cornerRadius: 10.0)
        tileBoard.setNode(column: 1, row: 1, node: player)

        insertTile()
    }

    func setupSwipeControls() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedUp(_:)))
        upSwipe.numberOfTouchesRequired = 1
        upSwipe.direction = UISwipeGestureRecognizerDirection.up
        self.view?.addGestureRecognizer(upSwipe)

        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedDown(_:)))
        downSwipe.numberOfTouchesRequired = 1
        downSwipe.direction = UISwipeGestureRecognizerDirection.down
        self.view?.addGestureRecognizer(downSwipe)

        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedLeft(_:)))
        leftSwipe.numberOfTouchesRequired = 1
        leftSwipe.direction = UISwipeGestureRecognizerDirection.left
        self.view?.addGestureRecognizer(leftSwipe)

        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedRight(_:)))
        rightSwipe.numberOfTouchesRequired = 1
        rightSwipe.direction = UISwipeGestureRecognizerDirection.right
        self.view?.addGestureRecognizer(rightSwipe)
    }

    func swipedUp(_ r: UIGestureRecognizer!) {
        let action = SKAction.run {
            self.moveNodesUp()
        }
        self.run(action, completion: {
            self.insertTile()
            self.updateGameScore()
        })
    }

    func swipedDown(_ r: UIGestureRecognizer!) {
        let action = SKAction.run {
            self.moveNodesDown()
        }
        self.run(action, completion: {
            self.insertTile()
            self.updateGameScore()
        })
    }

    func swipedLeft(_ r: UIGestureRecognizer!) {
        let action = SKAction.run {
            self.moveNodesLeft()
        }
        self.run(action, completion: {
            self.insertTile()
            self.updateGameScore()
        })
    }

    func swipedRight(_ r: UIGestureRecognizer!) {
        let action = SKAction.run {
            self.moveNodesRight()
        }
        self.run(action, completion: {
            self.insertTile()
            self.updateGameScore()
        })
    }

    func moveNodesUp() {
        for j in 2..<cubicCount+1 {
            for i in 0..<cubicCount {
                moving(key: "\(i),\(cubicCount - j)", direction: .up)
            }
        }
    }

    func moveNodesDown() {
        for j in 1..<cubicCount {
            for i in 0..<cubicCount {
                moving(key: "\(i),\(j)", direction: .down)
            }
        }
    }

    func moveNodesLeft() {
        for i in 1..<cubicCount {
            for j in 0..<cubicCount {
                moving(key: "\(i),\(j)", direction: .left)
            }
        }
    }


    func moveNodesRight() {
        for i in 2..<cubicCount+1 {
            for j in 0..<cubicCount {
                moving(key: "\(cubicCount - i),\(j)", direction: .right)
            }
        }
    }

    func moving(key: String, direction: MoveDirection) {
        // nodeの存在確認
        guard let node = tileBoard.nodeArray[key] else { return }
        // 移動先がboardの領域内に存在することを確認
        let nextKey = direction.nextKey(key: key)
        guard let nextTile = tileBoard.baseTileArray[nextKey] else { return }
        // 移動先にnodeが存在しないとき
        guard let existingNode = tileBoard.nodeArray[nextKey] else {
            let moveAction = SKAction.move(to: nextTile.position, duration: 0.2)
            node.run(moveAction)
            tileBoard.nodeArray.removeValue(forKey: key)
            tileBoard.nodeArray.updateValue(node, forKey: nextKey)

            moving(key: nextKey, direction: direction)

            return
        }
        // 移動先のnodeが同じ種類のnodeのとき
        if type(of: existingNode) == type(of: node) {
            if type(of: node) == Potion.self {
                return
            }

            node.run(SKAction.sequence([
                SKAction.move(to: nextTile.position, duration: 0.2),
                SKAction.scale(by: 1.25, duration: 0.1),
                SKAction.scale(by: 0.8, duration: 0.2)
                ]))

            existingNode.removeFromParent()
            tileBoard.nodeArray.removeValue(forKey: key)
            if let enemy = node as? Enemy, let exEnemy = existingNode as? Enemy {
                if enemy.level == exEnemy.level {
                    enemy.setStatus(level: enemy.level + exEnemy.level)
                    tileBoard.nodeArray.updateValue(enemy, forKey: nextKey)
                }
            }
            if let coin = node as? Coin, let exCoin = existingNode as? Coin {
                coin.update(level: coin.level + exCoin.level)
                tileBoard.nodeArray.updateValue(coin, forKey: nextKey)
            }

            return
        }
        if let player = node as? Player {
            messageLabel.text = ("player action")
            if let enemy = existingNode as? Enemy {
                messageLabel.text = ("hit enemy")
                let prevTitle = tileBoard.baseTileArray[key]
                self.run(SKAction.sequence([
                    SKAction.run {
                        player.run(SKAction.move(to: nextTile.position, duration: 0.1))
                    },
                    SKAction.run {
                        enemy.fillColor = UIColor().flatPurple
                    },
                    SKAction.run {
                        player.run(SKAction.move(to: (prevTitle?.position)!, duration: 0.1))
                    },
                    SKAction.wait(forDuration: 0.1),
                    SKAction.run {
                        enemy.fillColor = .clear
                        enemy.damage(point: player.attack)
                        self.tileBoard.nodeArray.updateValue(enemy, forKey: nextKey)

                        if enemy.life <= 0 {
                            self.expCount += 1
                            //self.expLabel.text = "⚔️\(self.expCount)"
                            enemy.removeFromParent()
                            self.tileBoard.nodeArray.removeValue(forKey: nextKey)
                        }
                    },
                    ]))
                return
            }
            if let potion = existingNode as? Potion {
                messageLabel.text = ("get potion")
                player.update(life: potion.level)

                let moveAction = SKAction.move(to: nextTile.position, duration: 0.2)
                node.run(moveAction)
                potion.removeFromParent()
                tileBoard.nodeArray.removeValue(forKey: key)
                tileBoard.nodeArray.updateValue(node, forKey: nextKey)

                node.run(SKAction.sequence([
                    SKAction.scale(by: 1.25, duration: 0.1),
                    SKAction.scale(by: 0.8, duration: 0.2)
                    ]))
                return
            }
            if let coin = existingNode as? Coin {
                messageLabel.text = ("get coin")

                coinCount += coin.level
                //coinLabel.text = "💰\(coinCount)"

                let moveAction = SKAction.move(to: nextTile.position, duration: 0.2)
                node.run(moveAction)
                coin.removeFromParent()
                tileBoard.nodeArray.removeValue(forKey: key)
                tileBoard.nodeArray.updateValue(node, forKey: nextKey)

                node.run(SKAction.sequence([
                    SKAction.scale(by: 1.25, duration: 0.1),
                    SKAction.scale(by: 0.8, duration: 0.2)
                    ]))
                return
            }
        }
        if let enemy = node as? Enemy {
            if let player = existingNode as? Player {
                messageLabel.text = ("damage")

                player.update(life: -enemy.attack)
                let prevTitle = tileBoard.baseTileArray[key]
                self.run(SKAction.sequence([
                    SKAction.run {
                        enemy.run(SKAction.move(to: nextTile.position, duration: 0.1))
                    },
                    SKAction.run {
                        player.fillColor = UIColor().flatRed
                    },
                    SKAction.run {
                        enemy.run(SKAction.move(to: (prevTitle?.position)!, duration: 0.1))
                    },
                    SKAction.wait(forDuration: 0.1),
                    SKAction.run {
                        player.fillColor = .clear
                    },
                    ]))

                if player.life <= 0 {
                    let fade =
                        SKAction.sequence([
                            SKAction.hide(),
                            SKAction.wait(forDuration: 0.3),
                            SKAction.unhide(),
                            SKAction.wait(forDuration: 0.3),
                            SKAction.hide(),
                            SKAction.wait(forDuration: 0.3),
                            SKAction.unhide(),
                            SKAction.wait(forDuration: 0.3),
                            SKAction.hide(),
                            SKAction.wait(forDuration: 0.3),
                            SKAction.unhide(),
                            SKAction.wait(forDuration: 0.3),
                            SKAction.hide(),
                            ])
                    
                    player.run(fade)
                    endGame()
                }
            }
            return
        }
    }

    func insertTile() {
        let tileType = (Int)(arc4random_uniform(UInt32(10)))
        while(tileBoard.nodeArray.count != tileBoard.baseTileArray.count) {
            let columnNumber = (Int)(arc4random_uniform(UInt32(4)))
            let rowNumber = (Int)(arc4random_uniform(UInt32(4)))
            let key = "\(columnNumber),\(rowNumber)"

            guard let _ = tileBoard.nodeArray[key] else {
                switch tileType {
                case 0...5:
                    let enemy = Enemy(rectOf: tileSize, cornerRadius: 10.0)
                    enemy.setStatus(level: gameLevel)
                    tileBoard.setNode(column: columnNumber, row: rowNumber, node: enemy)
                case 6...8:
                    let coin = Coin(rectOf: tileSize, cornerRadius: 10.0)
                    tileBoard.setNode(column: columnNumber, row: rowNumber, node: coin)
                case 9:
                    let potionLevel = (Int)(arc4random_uniform(UInt32(10)))
                    let potion = Potion(rectOf: tileSize, cornerRadius: 10.0)
                    switch potionLevel {
                    case 0:
                        potion.update(level: 3)
                        tileBoard.setNode(column: columnNumber, row: rowNumber, node: potion)
                    default:
                        break
                    }
                default:
                    break
                }
                return
            }
        }
    }

    func updateGameScore() {
        turnCount += 1
        gameLevel = (expCount / 10) + 1
        if coinCount > 10 {
            shopLabel.fontColor = .white
        } else {
            shopLabel.fontColor = .gray
        }
        coinLabel.text = "💰\(coinCount)"
        expLabel.text = "⚔️\(self.expCount)"
    }

    func endGame() {
        let label = UILabel()
        label.backgroundColor = .white
        label.alpha = 0.8
        label.text =
            "game over\n" +
            "Turn : \(turnCount)\n" +
            "Kills : \(expCount)\n" +
            "Coins : \(coinCount)\n" +
            "Total : \(turnCount+expCount+coinCount)"
        label.layer.zPosition = 10
        label.layer.position = (scene?.view!.center)!
        self.view?.addSubview(label)
        messageLabel.text = "game over:\(turnCount)+\(expCount)+\(coinCount)"
        self.isGameOver = true
    }

    func printArrays() {
        var nameString = ""
        for i in 0..<cubicCount {
            for j in 0..<cubicCount {
                if let node = tileBoard.nodeArray["\(i),\(j)"],
                    let name = node.name {
                    nameString += "\(name):"
                }
            }
            nameString += "\n"
        }
        messageLabel.text = nameString
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }

    func touchDown(atPoint pos : CGPoint) {
        let touchedNode = scene?.atPoint(pos)
        if (touchedNode?.name == "shop") {
            if coinCount > 10 {
                player.update(attack: +1)
                messageLabel.text = "power up"
                coinCount -= 10
                updateGameScore()
            }
        }
        if self.isGameOver {
            let scene = GameScene(size: self.size)
            scene.scaleMode = .aspectFill
            self.view!.presentScene(scene)
        }
    }

}
