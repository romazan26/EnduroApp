//
//  ViewController.swift
//  EnduroApp
//
//  Created by Роман on 08.07.2023.
//

import UIKit
import RealmSwift

class StartViewController: UIViewController {
    var user: User!
    
    @IBOutlet var LabelInfo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startSetting()
    }


}
extension StartViewController{
    private func startSetting(){
        var description: String {
            """
            Name: \(user.userData[0].name)
            SurName: \(user.userData[0].surName)
            moto: \(user.userData[0].brand)
            model: \(user.userData[0].model)
            """
        }
        LabelInfo.text = description
    }
}

