//
//  TabBarViewController.swift
//  EnduroApp
//
//  Created by Роман on 10.07.2023.
//

import UIKit
import RealmSwift

class TabBarViewController: UITabBarController {

    var user: User!
    override func viewDidLoad() {
        super.viewDidLoad()
        transferData()
    }

    private func transferData() {
            guard let viewControllers else { return }
            
            viewControllers.forEach {
                if let startVC = $0 as? StartViewController {
                    startVC.user = user
                } else if let navigationVC = $0 as? UINavigationController {
                    let taskMotoVC = navigationVC.topViewController
                    guard let taskMotoVC = taskMotoVC as? TaskMotoTableViewController else {
                        return
                    }
                    taskMotoVC.user = user
                }
            }
        }
}
