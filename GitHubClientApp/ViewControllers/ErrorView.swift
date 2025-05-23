//
//  ErrorView.swift
//  GitHubClientApp
//
//  Created by Chuan on 2025/5/22.
//

import Foundation
import UIKit

class ErrorView: UIView {
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "exclamationmark.triangle")
        imageView.tintColor = .systemRed
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.text = "Oops!"
        label.textAlignment = .center
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Try Again", for: .normal)
        button.backgroundColor = UIColor(red: 36/255, green: 41/255, blue: 46/255, alpha: 1.0)
        button.tintColor = .white
        button.layer.cornerRadius = 6
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return button
    }()
    
    var retryHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(messageLabel)
        addSubview(retryButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -80),
            iconImageView.widthAnchor.constraint(equalToConstant: 60),
            iconImageView.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
            retryButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 30),
            retryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            retryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            retryButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40)
        ])
    }
    
    private func setupActions() {
        retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
    }
    
    func configure(with message: String) {
        messageLabel.text = message
    }
    
    @objc private func retryButtonTapped() {
        retryHandler?()
    }
}    
