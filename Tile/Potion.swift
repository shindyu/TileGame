import SpriteKit

class Potion: SKShapeNode {
    override init() {
        super.init()
        self.name = "potion"
        self.fillColor = UIColor().flatGreen

        let label = SKLabelNode(text: self.name)
        label.fontName = "Helvetica"
        label.fontColor = .white
        self.addChild(label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
