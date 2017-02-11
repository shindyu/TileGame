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

class TileBoard {
    var board: SKSpriteNode
    var baseTileArray: [String:SKShapeNode]
    var nodeArray: [String:SKShapeNode]
    var cubicCount: Int

    init(cubicCount: Int, length: CGFloat) {
        self.cubicCount = cubicCount
        let nodeWidth = length / CGFloat(cubicCount)
        self.board = SKSpriteNode(color: .clear, size: CGSize(width: length, height: length))
        self.baseTileArray = [:]
        self.nodeArray = [:]
        for i in 0..<cubicCount {
            for j in 0..<cubicCount {
                let node = SKShapeNode(rectOf: CGSize(width: nodeWidth, height: nodeWidth), cornerRadius: 10.0)
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

    func setNode(column: Int, row: Int, node: SKShapeNode) {
        if let tile = baseTileArray["\(column),\(row)"] {
            node.position = tile.position
            node.name = tile.name
            board.addChild(node)
            nodeArray.updateValue(node, forKey: node.name!)
            let action = SKAction.sequence([
                SKAction.scale(by: 0.5, duration: 0),
                SKAction.scale(by: 2.0, duration: 0.2)
                ])
            node.run(action)
        }
    }


    func getTile(column: Int, row: Int) -> SKSpriteNode? {
        return nil
    }

    func moveNodesUp() {
        for j in 1..<cubicCount+1 {
            for i in 0..<cubicCount {
                moving(key: "\(i),\(cubicCount - j)", direction: .up)
            }
        }
    }

    func moveNodesDown() {
        for j in 0..<cubicCount {
            for i in 0..<cubicCount {
                moving(key: "\(i),\(j)", direction: .down)
            }
        }
    }

    func moveNodesLeft() {
        for i in 0..<cubicCount {
            for j in 0..<cubicCount {
                moving(key: "\(i),\(j)", direction: .left)
            }
        }
    }


    func moveNodesRight() {
        for i in 1..<cubicCount+1 {
            for j in 0..<cubicCount {
                moving(key: "\(cubicCount - i),\(j)", direction: .right)
            }
        }
    }

    func moving(key: String, direction: MovingDirection) {
        // nodeの存在確認
        guard let node = nodeArray[key] else { return }
        // 移動先がboardの領域内に存在することを確認
        let nextKey = direction.nextKey(key: key)
        guard let nextTile = baseTileArray[nextKey] else { return }
        // 移動先にnodeが存在しないとき
        guard let existingNode = nodeArray[nextKey] else {
            let moveAction = SKAction.move(to: nextTile.position, duration: 0.1)
            node.run(moveAction)
            nodeArray.updateValue(node, forKey: nextKey)
            nodeArray.removeValue(forKey: key)

            moving(key: nextKey, direction: direction)

            return
        }
        // 移動先のnodeが同じ種類のnodeのとき
        if existingNode.fillColor == node.fillColor {
            let moveAction = SKAction.move(to: nextTile.position, duration: 0.1)
            node.run(moveAction)
            nodeArray.removeValue(forKey: key)
            node.removeFromParent()
        }
    }
}
