import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let lifeLabel = SKLabelNode()
    let coinLabel = SKLabelNode()
    let expLabel = SKLabelNode()
    var tileBoard: TileBoard!
    var cubicCount: Int!
    var expCount: Int = 0
    var lifeCount: Int = 10
    var coinCount: Int = 0
    var messageLabel = SKLabelNode()

    // MARK: - methods
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.white
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsWorld.contactDelegate = self
        setupSwipeControls()

        expLabel.text = "\(expCount)"
        expLabel.fontName = "Helvetica"
        expLabel.fontColor = UIColor().flatBlue
        expLabel.position = CGPoint(x: self.frame.midX / 2, y: self.frame.maxY - 100)
        self.addChild(expLabel)

        lifeLabel.text = "\(lifeCount)"
        lifeLabel.fontName = "Helvetica"
        lifeLabel.fontColor = UIColor().flatGreen
        lifeLabel.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 100)
        self.addChild(lifeLabel)

        coinLabel.text = "\(coinCount)"
        coinLabel.fontName = "Helvetica"
        coinLabel.fontColor = UIColor().flatYellow
        coinLabel.position = CGPoint(x: self.frame.midX * 3 / 2, y: self.frame.maxY - 100)
        self.addChild(coinLabel)

        messageLabel.text = ""
        //arrayLabel.fontName = "Helvetica"
        messageLabel.fontColor = UIColor().flatBlue
        messageLabel.position = CGPoint(x: self.frame.midX, y: 100)
        self.addChild(messageLabel)

        self.cubicCount = 4

        let nodeWidth = (self.frame.width - 40) / CGFloat(cubicCount)

        tileBoard = TileBoard(cubicCount: cubicCount, length: self.frame.width - 40)
        let board = tileBoard.board
        board.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(board)

        let player = Player(rectOf: CGSize(width: nodeWidth, height: nodeWidth), cornerRadius: 10.0)
        tileBoard.setNode(column: 1, row: 1, node: player)

        let enemy = Enemy(rectOf: CGSize(width: nodeWidth, height: nodeWidth), cornerRadius: 10.0)
        tileBoard.setNode(column: 2, row: 3, node: enemy)

        let coin = Coin(rectOf: CGSize(width: nodeWidth, height: nodeWidth), cornerRadius: 10.0)
        tileBoard.setNode(column: 2, row: 0, node: coin)

        printArrays()
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
            self.setNodeRandom()
        })
    }

    func swipedDown(_ r: UIGestureRecognizer!) {
        let action = SKAction.run {
            self.moveNodesDown()
        }
        self.run(action, completion: {
            self.setNodeRandom()
        })    }

    func swipedLeft(_ r: UIGestureRecognizer!) {
        let action = SKAction.run {
            self.moveNodesLeft()
        }
        self.run(action, completion: {
            self.setNodeRandom()
        })
    }

    func swipedRight(_ r: UIGestureRecognizer!) {
        let action = SKAction.run {
            self.moveNodesRight()
        }
        self.run(action, completion: {
            self.setNodeRandom()
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

    func moving(key: String, direction: MovingDirection) {
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
            let moveAction = SKAction.move(to: nextTile.position, duration: 0.2)
            node.run(moveAction)
            existingNode.removeFromParent()
            tileBoard.nodeArray.removeValue(forKey: key)
            tileBoard.nodeArray.updateValue(node, forKey: nextKey)

            node.run(SKAction.sequence([
                SKAction.scale(by: 1.25, duration: 0.1),
                SKAction.scale(by: 0.8, duration: 0.2)
                ]))
        } else {
            if type(of: node) == Player.self {
                messageLabel.text = ("player action")
                switch existingNode {
                case is Enemy:
                    messageLabel.text = ("hit enemy")
                    expCount += 1
                    expLabel.text = "\(expCount)"
                    let moveAction = SKAction.move(to: nextTile.position, duration: 0.2)
                    node.run(moveAction)
                    existingNode.removeFromParent()
                    tileBoard.nodeArray.removeValue(forKey: key)
                    tileBoard.nodeArray.updateValue(node, forKey: nextKey)

                    node.run(SKAction.sequence([
                        SKAction.scale(by: 1.25, duration: 0.1),
                        SKAction.scale(by: 0.8, duration: 0.2)
                        ]))
                    return
                case is Potion:
                    messageLabel.text = ("get potion")
                    lifeCount += 1
                    lifeLabel.text = "\(lifeCount)"
                    let moveAction = SKAction.move(to: nextTile.position, duration: 0.2)
                    node.run(moveAction)
                    existingNode.removeFromParent()
                    tileBoard.nodeArray.removeValue(forKey: key)
                    tileBoard.nodeArray.updateValue(node, forKey: nextKey)

                    node.run(SKAction.sequence([
                        SKAction.scale(by: 1.25, duration: 0.1),
                        SKAction.scale(by: 0.8, duration: 0.2)
                        ]))
                    return
                case is Coin:
                    messageLabel.text = ("get coin")
                    coinCount += 1
                    coinLabel.text = "\(coinCount)"
                    let moveAction = SKAction.move(to: nextTile.position, duration: 0.2)
                    node.run(moveAction)
                    existingNode.removeFromParent()
                    tileBoard.nodeArray.removeValue(forKey: key)
                    tileBoard.nodeArray.updateValue(node, forKey: nextKey)

                    node.run(SKAction.sequence([
                        SKAction.scale(by: 1.25, duration: 0.1),
                        SKAction.scale(by: 0.8, duration: 0.2)
                        ]))
                    return
                default:
                    return
                }
            }
            if type(of: node) == Enemy.self {
                if existingNode is Player {
                    messageLabel.text = ("damage")
                    lifeCount -= 1
                    lifeLabel.text = "\(lifeCount)"
                }
            }
        }
    }

    func setNodeRandom() {
        let tileSpecies = (Int)(arc4random_uniform(UInt32(6)))
        while(true) {
            let columnNumber = (Int)(arc4random_uniform(UInt32(3)))
            let rowNumber = (Int)(arc4random_uniform(UInt32(4)))
            let key = "\(columnNumber),\(rowNumber)"

            guard let _ = tileBoard.nodeArray[key] else {
                let nodeWidth = (self.frame.width - 40) / CGFloat(cubicCount)
                
                if tileSpecies == 0 || tileSpecies == 1 || tileSpecies == 2 {
                    let enemy = Enemy(rectOf: CGSize(width: nodeWidth, height: nodeWidth), cornerRadius: 10.0)
                    tileBoard.setNode(column: columnNumber, row: rowNumber, node: enemy)
                } else if tileSpecies == 3 {
                    let potion = Potion(rectOf: CGSize(width: nodeWidth, height: nodeWidth), cornerRadius: 10.0)
                    tileBoard.setNode(column: columnNumber, row: rowNumber, node: potion)
                } else if tileSpecies == 4 || tileSpecies == 5 {
                    let coin = Coin(rectOf: CGSize(width: nodeWidth, height: nodeWidth), cornerRadius: 10.0)
                    tileBoard.setNode(column: columnNumber, row: rowNumber, node: coin)
                }
                return
            }
        }
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

    }

}
