import SpriteKit

class Coin: SKShapeNode {
    override init() {
        super.init()
        self.name = "coin"
        self.fillColor = UIColor().flatYellow

        let label = SKLabelNode(text: self.name)
        label.fontName = "Helvetica"
        label.fontColor = .white
        self.addChild(label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
