import SpriteKit

enum MovingDirection {
    case up
    case down
    case left
    case right

    func nextKey(key: String) -> String {
        let keyArray = key.components(separatedBy: ",")
        let i: Int = Int(keyArray.first!)!
        let j: Int = Int(keyArray.last!)!
        switch self {
        case .up:
            return "\(i),\(j + 1)"
        case .down:
            return "\(i),\(j - 1)"
        case .left:
            return "\(i - 1),\(j)"
        case .right:
            return "\(i + 1),\(j)"
        }
    }
}

class TileBoard: SKNode {
    var board: SKSpriteNode
    var baseTileArray: [String:SKShapeNode]
    var nodeArray: [String:SKShapeNode]
    var cubicCount: Int

    init(cubicCount: Int, length: CGFloat) {
        self.cubicCount = cubicCount
        let nodeWidth = length / CGFloat(cubicCount)
        self.board = SKSpriteNode(color: UIColor().flatGray, size: CGSize(width: length, height: length))
        self.baseTileArray = [:]
        self.nodeArray = [:]

        super.init()

        for i in 0..<cubicCount {
            for j in 0..<cubicCount {
                let node = SKShapeNode(rectOf: CGSize(width: nodeWidth, height: nodeWidth), cornerRadius: 1.0)
                node.name = "\(i),\(j)"
                node.strokeColor = .gray
                node.lineWidth = 5.0
                node.position = CGPoint(
                    x: CGFloat(i) * nodeWidth + nodeWidth/2 - length/2,
                    y: CGFloat(j) * nodeWidth + nodeWidth/2 - length/2
                )

                let label = SKLabelNode(text: "\(i),\(j)")
                label.fontColor = .gray
                node.addChild(label)
                board.addChild(node)

                baseTileArray.updateValue(node, forKey: node.name!)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setNode(column: Int, row: Int, node: SKShapeNode) {
        if let tile = baseTileArray["\(column),\(row)"] {
            node.position = tile.position
            node.name = tile.name
            node.run(SKAction.scale(by: 0.1, duration: 0))
            board.addChild(node)
            nodeArray.updateValue(node, forKey: node.name!)
            let action = SKAction.sequence([
                SKAction.wait(forDuration: 0.3),
                SKAction.scale(by: 10.0, duration: 0.2)
                ])
            node.run(action)
        }
    }


    func getTile(column: Int, row: Int) -> SKSpriteNode? {
        return nil
    }
}
