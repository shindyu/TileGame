import SpriteKit
import GameplayKit

class TitleScene: SKScene, SKPhysicsContactDelegate {
    // MARK: - properties
    let titleLabel = SKLabelNode()
    let startButton = SKLabelNode()
    let rankingButton = SKLabelNode()

    // MARK: - methods
    override func didMove(to view: SKView) {
        self.backgroundColor = .black
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsWorld.contactDelegate = self


        initTitleLabel()
        initStartButton()
        //initRankingButton()
        addChildren()

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }

    func touchDown(atPoint pos : CGPoint) {
        let touchedNode = scene?.atPoint(pos)
        if (touchedNode?.name == "start") {
            self.removeAllChildren()
            let scene = GameScene(size: self.size)
            scene.scaleMode = .aspectFill
            self.view!.presentScene(scene)
        } else if (touchedNode?.name == "ranking") {
            if let rootViewController = self.view?.window?.rootViewController {
                GameCenterUtility.showLeaderboard(rootViewController: rootViewController)
            }
        }
    }

    // MARK: - private
    func addChildren() {
        self.addChild(titleLabel)
        self.addChild(startButton)
        self.addChild(rankingButton)
    }

    func initTitleLabel() {
        titleLabel.text = "Tiles"
        titleLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        titleLabel.zPosition = 100
        titleLabel.fontSize = 100
        titleLabel.fontName = "Helvetica"
        titleLabel.fontColor = .gray
    }

    func initStartButton() {
        startButton.name = "start"
        startButton.text = "start"
        startButton.fontSize = 50
        startButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 150)
        startButton.zPosition = 100
        startButton.fontColor = .gray
    }

    func initRankingButton() {
        rankingButton.name = "ranking"
        rankingButton.text = "ranking"
        rankingButton.fontSize = 50
        rankingButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 230)
        rankingButton.zPosition = 100
        rankingButton.fontColor = .gray
    }
}
