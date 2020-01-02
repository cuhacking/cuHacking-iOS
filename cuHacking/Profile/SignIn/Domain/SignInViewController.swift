//
//  SignInViewController.swift
//  cuHacking
//
//  Created by Santos on 2020-01-02.
//  Copyright © 2020 cuHacking. All rights reserved.
//

import UIKit
class SignInViewController: UIViewController {
    private let signInRepository: SignInRepository
    
    init(signInRepository: SignInRepository = SignInDataSource()) {
        self.signInRepository = signInRepository
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Asset.Images.cuHackingLogo.image
        return imageView
    }()

    private let emailField: UITextFieldPadding = {
        let textField = UITextFieldPadding()
        textField.keyboardType = .emailAddress
        textField.placeholder = "Email"
        textField.layer.borderColor = Asset.Colors.primaryText.color.cgColor
        textField.layer.borderWidth = 1.0
        return textField
    }()

    private let passwordField: UITextFieldPadding = {
        let textField = UITextFieldPadding()
        textField.isSecureTextEntry = true
        textField.placeholder = "Password"
        textField.layer.borderColor = Asset.Colors.primaryText.color.cgColor
        textField.layer.borderWidth = 1.0
        return textField
    }()

    private let signInButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = Asset.Colors.purple.color
        button.dropShadow()
        button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        return button
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont(font: Fonts.Roboto.light, size: 1)
        label.text = "Couldn't sign in"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.background.color
        setup()
    }
    
    private func setup() {
        emailField.delegate = self
        passwordField.delegate = self

        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        emailField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubviews(views: logoImageView, emailField, passwordField, signInButton, errorLabel)

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            emailField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 70),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 16),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            signInButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.10),
            signInButton.topAnchor.constraint(equalTo: passwordField.topAnchor, constant: 100),

            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 30)

        ])
    }

    @objc private func signIn() {
        let email = emailField.text?.replacingOccurrences(of: " ", with: "") ?? ""
        let password = passwordField.text?.replacingOccurrences(of: " ", with: "") ?? ""
        signInRepository.signIn(email: email, password: password) { (token, error) in
            if token == nil {
                DispatchQueue.main.async {
                    self.errorLabel.text = "Incorrect username/password."
                    self.errorLabel.isHidden = false
                }
            } else {
                UserSession.current.initalizeSession(token: token)
                DispatchQueue.main.async {
                    self.errorLabel.isHidden = true
                    let profileViewController = ProfileViewController()
                    var relevantViewControllers = self.navigationController!.viewControllers
                    relevantViewControllers[relevantViewControllers.count-1] = profileViewController

                    self.navigationController?.setViewControllers(relevantViewControllers, animated: true)
                }
            }
        }
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
