//
//  StorageManager.swift
//  EnduroApp
//
//  Created by Роман on 09.07.2023.
//

import Foundation
import RealmSwift

final class StorageManager {
    static let shared = StorageManager()
    
    let realm: Realm
    private init (){
        do {
            realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }
// MARK: - User
    func save(_ user: [User]) {
        write {
            realm.add(user)
        }
    }
    
    func save(_ user: String, withPass password: String, completion: (User) -> Void) {
        write {
            let user = User(value: [user, password])
            realm.add(user)
            completion(user)
        }
    }
    
    func delete(_ user: User) {
        write {
            realm.delete(user.userData)
            realm.delete(user)
        }
    }
    
    func edit(_ user: User, newValue: String) {
        write {
            user.userName = newValue
        }
    }
    private func write(completion: () -> Void) {
        do {
            try realm.write {
                completion()
            }
        } catch {
            print(error)
        }
    }
// MARK: - Tasks
    func save(_ task: String, withEngineHours engineHours: String, to userData: UserData, completion: (TaskOfMoto) -> Void) {
        write {
            let task = TaskOfMoto(value: ["taskTitle": task, "engineHours": engineHours])
            userData.taskOfMoto.append(task)
            completion(task)
        }
    }
    func edit(_ moto: TaskOfMoto, newValue: String, newEngineHours: String) {
        write {
            moto.taskTitle = newValue
            moto.engineHours = newEngineHours
        }
    }
    func delete(_ moto: TaskOfMoto) {
        write {
            realm.delete(moto)
        }
    }
    func done(_ moto: TaskOfMoto) {
        write {
            moto.setValue(true, forKey: "isComplete")
        }
    }

}
