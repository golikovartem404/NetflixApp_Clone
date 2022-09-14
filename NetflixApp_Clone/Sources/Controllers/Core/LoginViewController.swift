//
//  LoginViewController.swift
//  NetflixApp_Clone
//
//  Created by User on 14.09.2022.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Outlets

    private lazy var netflixIcon: UIImageView = {
        let image = UIImage(named: "netflixMain")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.backgroundColor = .systemGray5
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.backgroundColor = .systemGray5
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        return textField
    }()

    private lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(UIColor.systemGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.systemGray5.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var loginStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalCentering
        stack.spacing = 5
        return stack
    }()

    private lazy var recoverButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Recover Password", for: .normal)
        button.setTitleColor(UIColor.systemGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupHierarchy()
        setupLayout()
    }

    // MARK: - Setups

    private func setupHierarchy() {
        view.addSubview(netflixIcon)
        loginStack.addArrangedSubview(usernameTextField)
        loginStack.addArrangedSubview(passwordTextField)
        loginStack.addArrangedSubview(signInButton)
        view.addSubview(loginStack)
        view.addSubview(recoverButton)
    }

    private func setupLayout() {
        loginStack.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view)
            make.width.equalTo(view.snp.width).multipliedBy(0.9)
        }

        usernameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        netflixIcon.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view.snp.centerY).multipliedBy(0.6)
            make.height.equalTo(140)
        }

        recoverButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(loginStack.snp.bottom).offset(7)
        }
    }

    @objc func signInButtonTapped() {
        SceneDelegate.shared.changeViewcontroller(viewController: TabBarViewController(), animated: true, animationOptions: .transitionFlipFromRight)
    }

}
