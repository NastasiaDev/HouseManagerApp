//
//  PersonalDataViewController.swift
//  HouseManagerApp
//
//  Created by Anastasia Larina on 06.02.2025.
//

import UIKit

final class PersonalDataViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var patronymicNameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    @IBAction func phoneTextFieldChanged(_ sender: UITextField) {
        sender.text = formatPhoneNumber(sender.text ?? "")
        updateSaveButtonState()
    }
    @IBAction func saveBtn(_ sender: UIButton) {
        guard let userData = validateUserTextFieldInput() else { return }
        saveUserData(name: userData.name, surname: userData.surname,
                        patronymic: userData.patronymic, phone: userData.phone)
        performSegue(withIdentifier: "unwindToMain", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTextFieldsDelegates()
        self.setupUI()
        self.updateSaveButtonState()
        self.loadUserData()
    }
}

private extension PersonalDataViewController {
    private func setupUI() {
        self.setupSaveButton()
        self.setupPhoneTextField()
    }
    
    private func setupSaveButton() {
        self.saveButton.layer.cornerRadius = 8
    }
    
    private func setupPhoneTextField() {
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Изменить", for: .normal)
        cancelButton.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        self.phoneTextField.clearButtonMode = .never
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 65, height: 30))
        containerView.addSubview(cancelButton)
        self.phoneTextField.rightView = containerView
        self.phoneTextField.rightViewMode = .whileEditing
    }
    
    @objc func cancelButtonTapped() {
        self.phoneTextField.text = ""
        self.phoneTextField.resignFirstResponder()
    }
}

private extension PersonalDataViewController {
    private func validatePhoneNumber(_ number: String) -> Bool {
        let pattern = "^\\+7 \\d{3} \\d{3}-\\d{2}-\\d{2}$"
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: number.utf16.count)
        return regex.firstMatch(in: number, options: [], range: range) != nil
    }
    
    private func formatPhoneNumber(_ number: String) -> String {
        var digits = number.filter { "0123456789".contains($0) }
        if !digits.hasPrefix("7") {
            digits = "7" + digits
        }
        digits = String(digits.prefix(11))
        
        var formatted = "+7 "
        let sections = [3, 3, 2, 2]
        var index = digits.index(after: digits.startIndex)
        
        for (i, section) in sections.enumerated() {
            let end = digits.index(index, offsetBy: section, limitedBy: digits.endIndex) ?? digits.endIndex
            if index < end {
                formatted += String(digits[index..<end])
                if i == 0 {
                    formatted += " "
                } else if i == 1 || i == 2 {
                    formatted += "-"
                }
            }
            index = end
        }
        return formatted
    }
    
    private func validateUserTextFieldInput() -> (name: String, surname: String, patronymic: String, phone: String)? {
        guard let name = nameTextField.text, !name.isEmpty,
              let patronymic = patronymicNameField.text, !patronymic.isEmpty,
              let surname = surnameField.text, !surname.isEmpty,
              let phone = phoneTextField.text, validatePhoneNumber(phone) else {
            return nil
        }
        return (name, surname, patronymic, phone)
    }
    
    private func updateSaveButtonState() {
        let isNameValid = !(nameTextField.text?.isEmpty ?? true)
        let isPatronymicValid = !(patronymicNameField.text?.isEmpty ?? true)
        let isSurnameValid = !(surnameField.text?.isEmpty ?? true)
        let isPhoneValid = validatePhoneNumber(phoneTextField.text ?? "")
        self.saveButton.isEnabled = isNameValid && isPatronymicValid && isSurnameValid && isPhoneValid
    }
}

extension PersonalDataViewController: UITextFieldDelegate {
    func setupTextFieldsDelegates() {
        self.nameTextField.delegate = self
        self.patronymicNameField.delegate = self
        self.surnameField.delegate = self
        self.phoneTextField.delegate = self
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == nameTextField || textField == patronymicNameField || textField == surnameField {
            let allowedCharacters = CharacterSet.letters.union(.whitespaces)
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }

        if textField == phoneTextField {
            let currentText = textField.text ?? ""
            let newString = (currentText as NSString).replacingCharacters(in: range, with: string)
            let digits = newString.filter { "0123456789".contains($0) }
            return digits.count <= 11
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTextField || textField == patronymicNameField || textField == surnameField {
            textField.text = textField.text?.capitalized
        }
    }
}

private extension PersonalDataViewController {
   
    private func saveUserData(name: String, surname: String, patronymic: String, phone: String) {
        let defaults = UserDefaults.standard
        defaults.set(name, forKey: "userName")
        defaults.set(surname, forKey: "userSurname")
        defaults.set(patronymic, forKey: "userPatronymic")
        defaults.set(phone, forKey: "userPhone")
        defaults.synchronize()
    }
    
    private func loadUserData() {
        self.nameTextField.text = UserDefaults.standard.string(forKey: "userName") ?? ""
        self.patronymicNameField.text = UserDefaults.standard.string(forKey: "userPatronymic") ?? ""
        self.surnameField.text = UserDefaults.standard.string(forKey: "userSurname") ?? ""
        self.phoneTextField.text = UserDefaults.standard.string(forKey: "userPhone") ?? ""
    }
}
