//
//  PersonalDataViewController.swift
//  HouseManagerApp
//
//  Created by Anastasia Larina on 06.02.2025.
//

import UIKit

final class PersonalDataViewController: UIViewController {
    // MARK: - Properties

    private let userService = UserDefaultsService()

    // MARK: - Outlets

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var patronymicNameField: UITextField!
    @IBOutlet var surnameField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var saveButton: UIButton!

    // MARK: - Action

    @IBAction func textFieldChanged(_: UITextField) {
        self.updateSaveButtonState()
    }

    @IBAction func phoneTextFieldChanged(_ sender: UITextField) {
        sender.text = PhoneValidator.formatPhoneNumber(sender.text ?? "")
        self.updateSaveButtonState()
    }

    @IBAction func saveBtn(_: UIButton) {
        guard let userData = validateUserTextFieldInput() else { return }
        let user = User(name: userData.name, surname: userData.surname,
                        patronymic: userData.patronymic, phone: userData.phone)
        DispatchQueue.global(qos: .background).async {
               self.userService.saveUser(user)
               
               DispatchQueue.main.async {
                   self.performSegue(withIdentifier: "unwindToMain", sender: self)
               }
           }
    }

    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTextFieldsDelegates()
        self.setupUI()
        self.updateSaveButtonState()
        self.loadUserData()
    }
}

// MARK: - SetupUI

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

// MARK: - Data validation and save

private extension PersonalDataViewController {
    private func validateUserTextFieldInput() -> (name: String, surname: String, patronymic: String, phone: String)? {
        guard let name = nameTextField.text, !name.isEmpty,
              let patronymic = patronymicNameField.text, !patronymic.isEmpty,
              let surname = surnameField.text, !surname.isEmpty,
              let phone = phoneTextField.text, PhoneValidator.validatePhoneNumber(phone)
        else {
            return nil
        }
        return (name, surname, patronymic, phone)
    }

    private func updateSaveButtonState() {
        let isNameValid = !(nameTextField.text?.isEmpty ?? true)
        let isPatronymicValid = !(patronymicNameField.text?.isEmpty ?? true)
        let isSurnameValid = !(surnameField.text?.isEmpty ?? true)
        let isPhoneValid = PhoneValidator.validatePhoneNumber(phoneTextField.text ?? "")
        saveButton.isEnabled = isNameValid && isPatronymicValid && isSurnameValid && isPhoneValid
    }

    private func loadUserData() {
        if let user = userService.loadUser() {
            self.nameTextField.text = user.name
            self.patronymicNameField.text = user.patronymic
            self.surnameField.text = user.surname
            self.phoneTextField.text = user.phone
        }
    }
}

// MARK: - TextFieldDelegate

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
