//
//  user.swift
//  EnduroApp
//
//  Created by Роман on 09.07.2023.
//

import Foundation
import RealmSwift

final class User: Object {
    @Persisted var userName = ""
    @Persisted var userPassword = ""
    @Persisted var userData = List<UserData>()
}
final class UserData: Object {
    @Persisted var name = ""
    @Persisted var surName = ""
    @Persisted var brand = ""
    @Persisted var model = ""
    @Persisted var engineСapacity = ""
    @Persisted var taskOfMoto = List<TaskOfMoto>()
    
}

final class TaskOfMoto: Object {
    @Persisted var taskTitle = ""
    @Persisted var engineHours = ""
    @Persisted var date = Date()
    @Persisted var isComplete = false
}
