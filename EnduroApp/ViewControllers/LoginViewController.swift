//
//  LoginViewController.swift
//  EnduroApp
//
//  Created by Роман on 09.07.2023.
//

import UIKit
import RealmSwift

class LoginViewController: UIViewController {

    var user: Results<User>!
    private let storagemanager = StorageManager.shared
    
    @IBOutlet var userNameTF: UITextField!
    @IBOutlet var userPaswordTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        user = StorageManager.shared.realm.objects(User.self)
    }
    

    @IBAction func loginButton(_ sender: UIButton) {
    print(user)
    }
    
    @IBAction func createNewUserButton(_ sender: UIButton) {
        showAlert()
    }
    private func save(user: String, password: String) {
            let newUser = User()
            newUser.userName = user
        newUser.userPassword = password
                storagemanager.save([newUser])
                
        }
        
    }

extension LoginViewController {
    private func showAlert(with user: User? = nil, completion: (() -> Void)? = nil) {
          let alertBuilder = AlertControllerBuilder(
              title: "New user",
              message: "Please set name for new user"
          )
          
          alertBuilder
            .setTextFields(user: user?.userName, password: user?.userPassword)
              .addAction(title: "Save new User", style: .default) { [weak self] newValue, password in
                  
                  self?.save(user: newValue, password: password)
              }
              .addAction(title: "Cancel", style: .destructive)
          
          let alertController = alertBuilder.build()
          present(alertController, animated: true)
      }
}
