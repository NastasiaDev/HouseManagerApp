//
//  UserDefaultsService.swift
//  HouseManagerApp
//
//  Created by Anastasia Larina on 06.02.2025.
//

import Foundation

final class UserDefaultsService {
    private let defaults = UserDefaults.standard

    private enum Keys {
        static let name = "userName"
        static let surname = "userSurname"
        static let patronymic = "userPatronymic"
        static let phone = "userPhone"
    }

    func saveUser(_ user: User) {
        self.defaults.set(user.name, forKey: Keys.name)
        self.defaults.set(user.surname, forKey: Keys.surname)
        self.defaults.set(user.patronymic, forKey: Keys.patronymic)
        self.defaults.set(user.phone, forKey: Keys.phone)
    }

    func loadUser() -> User? {
        guard let name = defaults.string(forKey: Keys.name),
              let surname = defaults.string(forKey: Keys.surname),
              let patronymic = defaults.string(forKey: Keys.patronymic),
              let phone = defaults.string(forKey: Keys.phone)
        else {
            return nil
        }
        return User(name: name, surname: surname, patronymic: patronymic, phone: phone)
    }
}
