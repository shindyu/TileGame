import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let startButton = SKLabelNode()
    let rankingButton = SKLabelNode()
    var nodeArray: [SKSpriteNode] = []
    var tileBoard: TileBoard!
    var cubicCount: Int!

    // MARK: - methods
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.white
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsWorld.contactDelegate = self
        setupSwipeControls()

        self.cubicCount = 4

        let nodeWidth = (self.frame.width - 40) / CGFloat(cubicCount)

        tileBoard = TileBoard(cubicCount: cubicCount, length: self.frame.width - 40)
        let board = tileBoard.board
        board.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(board)

        let node = SKShapeNode(rectOf: CGSize(width: nodeWidth, height: nodeWidth), cornerRadius: 10.0)
        //node.lineWidth = 20.0
        node.strokeColor = .clear
        node.fillColor = UIColor().flatRed
        tileBoard.setNode(column: 1, row: 1, node: node.copy() as! SKShapeNode)
        node.fillColor = UIColor().flatGreen
        tileBoard.setNode(column: 2, row: 3, node: node.copy() as! SKShapeNode)
        node.fillColor = UIColor().flatBlue
        tileBoard.setNode(column: 2, row: 0, node: node.copy() as! SKShapeNode)
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
        tileBoard.moveNodesUp()
        setNodeRandom()
    }

    func swipedDown(_ r: UIGestureRecognizer!) {
        tileBoard.moveNodesDown()
        setNodeRandom()
    }

    func swipedLeft(_ r: UIGestureRecognizer!) {
        tileBoard.moveNodesLeft()
        setNodeRandom()
    }

    func swipedRight(_ r: UIGestureRecognizer!) {
        tileBoard.moveNodesRight()
        setNodeRandom()
    }

    func setNodeRandom() {
        let colorNumber = (Int)(arc4random_uniform(UInt32(4)))
        for i in 0..<cubicCount*cubicCount {
            let columnNumber = (Int)(arc4random_uniform(UInt32(4)))
            let rowNumber = (Int)(arc4random_uniform(UInt32(4)))
            let key = "\(columnNumber),\(rowNumber)"
            guard let _ = tileBoard.nodeArray[key] else {
                let nodeWidth = (self.frame.width - 40) / CGFloat(cubicCount)
                let node = SKShapeNode(rectOf: CGSize(width: nodeWidth, height: nodeWidth), cornerRadius: 10.0)
                node.lineWidth = 20.0
                node.strokeColor = .clear
                node.fillColor = UIColor().flatRed
                if colorNumber == 0 { node.fillColor = UIColor().flatRed }
                else if colorNumber == 1 { node.fillColor = UIColor().flatGreen }
                else if colorNumber == 2 { node.fillColor = UIColor().flatBlue }

                tileBoard.setNode(column: columnNumber, row: rowNumber, node: node)
                return
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }

    func touchDown(atPoint pos : CGPoint) {

    }

}
