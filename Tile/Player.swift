import SpriteKit

class Player: SKShapeNode {
    var nameLabel: SKLabelNode!
    var lifeLabel: SKLabelNode!
    var attackLabel: SKLabelNode!
    var charactorNode: SKSpriteNode!
    var level: Int = 0
    var life: Int = 50
    var attack: Int = 1

    override init() {
        super.init()
        self.name = "😎"
//        nameLabel = SKLabelNode(text: name)
//        addChild(nameLabel)
        lifeLabel = SKLabelNode(text: "\(life)")
        lifeLabel.fontName = "Helvetica"
        lifeLabel.fontColor = .white
        lifeLabel.alpha = 0.7
        lifeLabel.position = CGPoint(x: -30, y: -30)
        addChild(lifeLabel)
        attackLabel = SKLabelNode(text: "\(attack)")
        attackLabel.fontName = "Helvetica"
        attackLabel.fontColor = .red
        attackLabel.alpha = 0.7
        attackLabel.position = CGPoint(x: 30, y: -30)
        addChild(attackLabel)

        addCharactor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addCharactor() {
        let size = 32
        let atlas = SKTextureAtlas(named: "Sprites")
        let nyanImage = atlas.textureNamed("Nyan")
        var textures:[SKTexture] = []
        let i:Int = 3
        for j in 0..<3 {
            let x = (CGFloat(j) * CGFloat(size)) / CGFloat(nyanImage.size().width)
            let y = (CGFloat(i) * CGFloat(size)) / CGFloat(nyanImage.size().height)
            let w = CGFloat(size) / CGFloat(nyanImage.size().width)
            let h = CGFloat(size) / CGFloat(nyanImage.size().height)
            //指定したサイズをtextureとして切り取る
            let texture = SKTexture.init(rect: CGRect(x:x, y:y, width:w, height:h), in: nyanImage)
            //配列に入れる
            textures.append(texture)
        }
        //最初の画像を設定(今回は配列の一番最初の画像)
        let nyan = SKSpriteNode(texture: textures.first, size: CGSize(width: 50, height: 50))
        let walk = SKAction.animate(with: textures, timePerFrame: 0.2)
        let forever = SKAction.repeatForever(walk)
        nyan.run(forever)
        self.addChild(nyan)
    }

    func update(life: Int = 0, attack: Int = 0) {
        self.life += life
        self.attack += attack
        updateLabel()
    }

    func damage(point: Int) {
        self.life -= point
        updateLabel()
    }

    func updateLabel() {
        lifeLabel.text = "\(life)"
        attackLabel.text = "\(attack)"
    }
}
