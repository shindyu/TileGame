import SpriteKit

class Potion: SKShapeNode {
    var nameLabel: SKLabelNode!
    var statusLabel: SKLabelNode!
    var level: Int = 1
    
    override init() {
        super.init()
        self.name = "🍏"

        nameLabel = SKLabelNode(text: name)
        addChild(nameLabel)
        statusLabel = SKLabelNode(text: "x\(level)")
        statusLabel.fontName = "Helvetica"
        statusLabel.fontColor = .white
        statusLabel.alpha = 0.7
        statusLabel.position = CGPoint(x: 0, y: -30)
        addChild(statusLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateStatus(level: Int) {
        self.level = level
        updateLabel()
    }

    func updateLabel() {
        statusLabel.text = "x\(level)"
    }
}
