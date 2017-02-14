import SpriteKit

class Player: SKShapeNode {
    override init() {
        super.init()
        self.name = "player"
        self.fillColor = UIColor().flatBlue

        let label = SKLabelNode(text: self.name)
        label.fontName = "Helvetica"
        label.fontColor = .white
        self.addChild(label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
