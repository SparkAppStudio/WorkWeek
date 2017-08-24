//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import UIKit

protocol UserGettable {
    var navigationController: UINavigationController { get }
    func getUserFromRealm() -> User?
    func showErrorAlert()
}

extension UserGettable {
    func getUserFromRealm() -> User? {
        RealmManager.shared.saveInitialUser()
        return RealmManager.shared.queryAllObjects(ofType: User.self).first
    }

    func showErrorAlert() {
        let alert = UIAlertController(title: "🤔Error🤔",
                                      message: "Looks like something has gone wrong with our database. Press \"OK\" to restart",
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
            fatalError()
        }

        alert.addAction(ok)
        navigationController.present(alert, animated: true, completion: nil)
    }
}
