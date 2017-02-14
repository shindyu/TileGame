import SpriteKit

class Player: SKShapeNode {
    var nameLabel: SKLabelNode!
    var statusLabel: SKLabelNode!
    var level: Int = 0
    var life: Int = 10

    override init() {
        super.init()
        self.name = "😎"
        nameLabel = SKLabelNode(text: name)
        addChild(nameLabel)
        statusLabel = SKLabelNode(text: "HP:\(life)")
        statusLabel.fontName = "Helvetica"
        statusLabel.fontColor = .white
        statusLabel.alpha = 0.7
        statusLabel.position = CGPoint(x: 0, y: -30)
        addChild(statusLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateStatus(life: Int) {
        self.life = life
        updateLabel()
    }

    func updateLabel() {
        statusLabel.text = "HP:\(life)"
    }
}
