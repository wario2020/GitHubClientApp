//
//  LoginViewController.swift
//  GitHubClientApp
//
//  Created by Chuan on 2025/5/22.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    private let viewModel: LoginViewModelProtocol
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "github-logo") ?? UIImage())
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Username"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("sign_in_to_github", comment: "登录"), for: .normal)
        button.backgroundColor = UIColor(red: 36/255, green: 41/255, blue: 46/255, alpha: 1.0)
        button.tintColor = .white
        button.layer.cornerRadius = 6
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return button
    }()
    
    private let biometricLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("sign_in_with_biometrics", comment: "faceID 指纹登录"), for: .normal)
        button.backgroundColor = UIColor(red: 36/255, green: 41/255, blue: 46/255, alpha: 1.0)
        button.tintColor = .white
        button.layer.cornerRadius = 6
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return button
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    init(viewModel: LoginViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        setupViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(logoImageView)
        contentView.addSubview(usernameTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(loginButton)
        contentView.addSubview(biometricLoginButton)
        contentView.addSubview(errorLabel)
        
        navigationItem.title = "GitHub Login"
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40),
            usernameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            usernameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            biometricLoginButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            biometricLoginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            biometricLoginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            errorLabel.topAnchor.constraint(equalTo: biometricLoginButton.bottomAnchor, constant: 20),
            errorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            errorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        biometricLoginButton.addTarget(self, action: #selector(biometricLoginButtonTapped), for: .touchUpInside)
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func setupViewModel() {
        // 这里可以设置 viewModel 的 delegate
    }
    
    @objc private func loginButtonTapped() {
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showError("Please enter both username and password")
            return
        }
        
        errorLabel.isHidden = true
        
        viewModel.login(username: username, password: password)
    }
    
    @objc private func biometricLoginButtonTapped() {
        errorLabel.isHidden = true
        viewModel.authenticateWithBiometrics()
    }
    
    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            loginButtonTapped()
        }
        return true
    }
}

extension LoginViewController: LoginViewModelDelegate {
    func loginSucceeded() {
        // 登录成功的处理逻辑
    }
    
    func loginFailed(with error: Error) {
        showError(error.localizedDescription)
    }
}    
