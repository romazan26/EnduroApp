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
    @Persisted var motos = List<Moto>()
    
}

final class Moto: Object {
    @Persisted var brand = ""
    @Persisted var model = ""
    @Persisted var engineСapacity = ""
}
