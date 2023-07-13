//
//  LoginViewController.swift
//  EnduroApp
//
//  Created by Роман on 09.07.2023.
//

import UIKit
import RealmSwift

class LoginViewController: UIViewController {

    var users: Results<User>!
    var chooseUser: User!
    private let storagemanager = StorageManager.shared
    
    @IBOutlet var userNameTF: UITextField!
    @IBOutlet var userPaswordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        users = StorageManager.shared.realm.objects(User.self)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let tabBarVC = segue.destination as? TabBarViewController else {return}
        tabBarVC.user = chooseUser
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        for user in users {
            guard userNameTF.text == user.userName,
                  userPaswordTF.text == user.userPassword
                    
            else {
                userNameTF.text = ""
                userPaswordTF.text = ""
                return
            }

            chooseUser = user
            performSegue(withIdentifier: "showTabBarController", sender: nil)
        }
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
