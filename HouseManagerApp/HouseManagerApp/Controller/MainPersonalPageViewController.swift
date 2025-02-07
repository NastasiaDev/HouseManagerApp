//
//  MainPersonalPageViewController.swift
//  HouseManagerApp
//
//  Created by Anastasia Larina on 06.02.2025.
//

import UIKit

final class MainPersonalPageViewController: UIViewController {
    // MARK: - Properties

    let userService = UserDefaultsService()
    private let networkService = NetworkService()

    // MARK: - Outlets

    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var cancelBtn: UIButton!

    // MARK: - Actions

    @IBAction func cancelBtn(_: UIButton) {}

    @IBAction func unwindToMainScreen(_ unwindSegue: UIStoryboardSegue) {
        if let sourceVC = unwindSegue.source as? PersonalDataViewController {
            let name = sourceVC.nameTextField.text ?? "Гость"
            let surname = sourceVC.surnameField.text ?? ""
            let patronymic = sourceVC.patronymicNameField.text ?? ""
            let phone = sourceVC.phoneTextField.text ?? ""

            self.userService.saveUser(User(name: name, surname: surname, patronymic: patronymic, phone: phone))
            self.loadUserData()
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.setupUI()
        self.loadUserData()
    }

    private func logout() {}

    // MARK: - Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = sender as? IndexPath {
            switch indexPath.row {
            case 0:
                if segue.identifier == "showObjects",
                   let _ = segue.destination as? ListOfObjectsViewController {}
            case 1:
                if segue.identifier == "showDetail",
                   let _ = segue.destination as? PersonalDataViewController {}
            case 2:
                print("Смена электронной почты")
            case 3:
                print("Электронное голосование")
            case 4:
                print("Выход из аккаунта")
            default:
                break
            }
        }
    }

    // MARK: - Helper Methods

    private func loadUserData() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }

            let user = self.userService.loadUser()

            DispatchQueue.main.async {
                if let user = user {
                    self.userNameLabel.text = "\(user.name) \(user.surname)".trimmingCharacters(in: .whitespaces)
                } else {
                    self.userNameLabel.text = "Гость"
                }
            }
        }
    }
}

// MARK: - SetupUI

private extension MainPersonalPageViewController {
    private func setupUI() {
        self.setupCancelBtn()
        self.setupBackgroundView()
    }

    private func setupBackgroundView() {
        self.backgroundView?.layer.cornerRadius = 10
        self.backgroundView?.layer.borderWidth = 1
        self.backgroundView?.layer.borderColor = UIColor.systemGray4.cgColor
        self.backgroundView?.clipsToBounds = true
        self.backgroundView?.backgroundColor = .white
        self.backgroundView?.layoutIfNeeded()
    }

    private func setupCancelBtn() {
        self.cancelBtn.layer.backgroundColor = UIColor.white.cgColor
        self.cancelBtn.layer.borderColor = UIColor.gray.cgColor
        self.cancelBtn.layer.borderWidth = 1
        self.cancelBtn.layer.cornerRadius = 8
        self.cancelBtn.setTitleColor(UIColor.red, for: .normal)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension MainPersonalPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MainPersonalPageTableViewCell

        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = selectedView

        switch indexPath.row {
        case 0:
            cell.nameLabel.text = "Объекты"
            cell.descriptionLabel.text = "Доступно адресов: 22"
            cell.icon.image = UIImage(systemName: "house.fill")
        case 1:
            cell.nameLabel.text = "Личные данные"
            cell.descriptionLabel.text = "Изменение ФИО и номера телефона"
            cell.icon.image = UIImage(systemName: "person.fill")
        case 2:
            cell.nameLabel.text = "E-mail"
            cell.descriptionLabel.text = "Смена электронной почты и пароля"
            cell.icon.image = UIImage(systemName: "lock.fill")
        case 3:
            cell.nameLabel.text = "Электронное голосование"
            cell.descriptionLabel.text = "Требуется получить доступ"
            cell.icon.image = UIImage(systemName: "checkmark.shield.fill")
        case 4:
            cell.nameLabel.text = "Выйти"
            cell.descriptionLabel.text = ""
            cell.icon.image = UIImage(systemName: "rectangle.portrait.and.arrow.forward.fill")
        default:
            break
        }
        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let segueIdentifiers = [
            "showObjects",
            "showDetail",
            "logout",
            "logout",
            "logout",
        ]

        let selectedSegue = segueIdentifiers[indexPath.row]

        if selectedSegue == "logout" {
            self.logout()
        } else {
            performSegue(withIdentifier: selectedSegue, sender: indexPath)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
