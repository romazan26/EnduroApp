//
//  Extension + UITableViewCell.swift
//  EnduroApp
//
//  Created by Роман on 13.07.2023.
//

import UIKit

extension UITableViewCell {
    func configure(with userData: UserData) {
        let currentTasks = userData.moto.filter("isComplete = false")
        var content = defaultContentConfiguration()
        
        content.text = userData.moto[0].taskTitle
        
        if userData.moto.isEmpty {
            content.secondaryText = "0"
            accessoryType = .none
        } else if currentTasks.isEmpty {
            content.secondaryText = nil
            accessoryType = .checkmark
        } else {
            content.secondaryText = currentTasks.count.formatted()
            accessoryType = .none
        }

        contentConfiguration = content
    }
}
