//
//  MainPersonalPageViewController.swift
//  HouseManagerApp
//
//  Created by Anastasia Larina on 06.02.2025.
//

import UIKit

final class MainPersonalPageViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBAction func cancelBtn(_ sender: UIButton) {
    }
    
    @IBAction func unwindToMainScreen(_ unwindSegue: UIStoryboardSegue) {
        if let sourceVC = unwindSegue.source as? PersonalDataViewController {
            let name = sourceVC.nameTextField.text ?? "Гость"
            let surname = sourceVC.surnameField.text ?? ""
            let patronymic = sourceVC.patronymicNameField.text ?? ""
            let phone = sourceVC.phoneTextField.text ?? ""

            UserDefaults.standard.setValue(name, forKey: "userName")
            UserDefaults.standard.setValue(surname, forKey: "userSurname")
            UserDefaults.standard.setValue(patronymic, forKey: "userPatronymic")
            UserDefaults.standard.setValue(phone, forKey: "userPhone")

            loadUserData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.setupUI()
        self.loadUserData()
    }
    
    private func logout() {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = sender as? IndexPath {
            switch indexPath.row {
            case 0:
                if segue.identifier == "showObjects",
                   let detailVC = segue.destination as? ListOfObjectsViewController {
                }
            case 1:
                if segue.identifier == "showDetail",
                   let personalVC = segue.destination as? PersonalDataViewController {
                    
                }
            case 2:
                print("Смена электронной почты")
            case 3:
                print("Элетронное голосование")
            case 4:
                print("Выход из аккаунта")
                break
            default:
                break
            }
        }
    }
    
    private func loadUserData() {
        let saveName = UserDefaults.standard.string(forKey: "userName") ?? "Гость"
        let saveSurname = UserDefaults.standard.string(forKey: "userSurname") ?? ""
        userNameLabel.text = "\(saveName) \(saveSurname)".trimmingCharacters(in: .whitespaces)
    }

}

private extension MainPersonalPageViewController {
    private func setupUI() {
        self.setupCancelBtn()
        self.setupBackgroundView()
    }
    
    private func setupBackgroundView() {
        backgroundView?.layer.cornerRadius = 10
        backgroundView?.layer.borderWidth = 1
        backgroundView?.layer.borderColor = UIColor.systemGray4.cgColor
        backgroundView?.clipsToBounds = true
        backgroundView?.backgroundColor = .white
        backgroundView?.layoutIfNeeded()
    }

    private func setupCancelBtn() {
        cancelBtn.layer.backgroundColor = UIColor.white.cgColor
        cancelBtn.layer.borderColor = UIColor.gray.cgColor
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.cornerRadius = 8
        cancelBtn.setTitleColor(UIColor.red, for: .normal)
    }
}

extension MainPersonalPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let segueIdentifiers = [
            "showObjects",
            "showDetail",
            "logout",
            "logout",
            "logout"
        ]
        
        let selectedSegue = segueIdentifiers[indexPath.row]
        
        if selectedSegue == "logout" {
            logout()
        } else {
            performSegue(withIdentifier: selectedSegue, sender: indexPath)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
