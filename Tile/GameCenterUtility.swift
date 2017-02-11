import Foundation
import GameKit

struct GameCenterUtility {
    static let leaderboardID = "XXXX"

    static func login(target: UIViewController){
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if let viewController = viewController {
                print("LoginCheck: Failed - LoginPageOpen")
                target.present(viewController, animated: true, completion: nil);
            } else {
                if error == nil {
                    print("LoginAuthentication: Success")
                } else {
                    print("LoginAuthentication: Failed")
                }
            }
        }
    }

    static func report(score: Int){
        let sScore = GKScore(leaderboardIdentifier: self.leaderboardID)
        sScore.value = Int64(score)

        GKScore.report([sScore], withCompletionHandler: { (error: Error?) -> Void in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Score submitted")
            }
        })
    }

    static func showLeaderboard(rootViewController: UIViewController) {
        let viewController: GKGameCenterViewController = GKGameCenterViewController()
        if let delegate = rootViewController as? GKGameCenterControllerDelegate {
            viewController.gameCenterDelegate = delegate
            viewController.viewState = GKGameCenterViewControllerState.leaderboards
            viewController.leaderboardIdentifier = self.leaderboardID
            rootViewController.present(viewController, animated: true, completion: nil)
        }
    }
}
