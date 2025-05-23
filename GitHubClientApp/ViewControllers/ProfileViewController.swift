//
//  ProfileViewController.swift
//  GitHubClientApp
//
//  Created by Chuan on 2025/5/22.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    private let avatarImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let bioLabel = UILabel()
    private let statsStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "个人资料"
        
        // 头像
        avatarImageView.backgroundColor = .systemGray4
        avatarImageView.layer.cornerRadius = 60
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
        view.addSubview(avatarImageView)
        
        // 用户名
        usernameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        usernameLabel.textAlignment = .center
        view.addSubview(usernameLabel)
        
        // 个人简介
        bioLabel.font = .systemFont(ofSize: 16, weight: .regular)
        bioLabel.textAlignment = .center
        bioLabel.numberOfLines = 0
        view.addSubview(bioLabel)
        
        // 统计信息（仓库、关注者等）
        statsStackView.axis = .horizontal
        statsStackView.distribution = .equalSpacing
        statsStackView.alignment = .center
        statsStackView.spacing = 20
        view.addSubview(statsStackView)
        
        // 添加示例统计项
        addStat(title: "仓库", value: "24")
        addStat(title: "关注", value: "108")
        addStat(title: "粉丝", value: "56")
    }
    
    private func setupConstraints() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // 头像约束
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 120),
            avatarImageView.heightAnchor.constraint(equalToConstant: 120),
            
            // 用户名约束
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // 个人简介约束
            bioLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10),
            bioLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            // 统计信息约束
            statsStackView.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 40),
            statsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            statsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            statsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func addStat(title: String, value: String) {
        let statView = UIView()
        statView.backgroundColor = .systemBackground
        statView.layer.cornerRadius = 8
        statView.layer.borderWidth = 1
        statView.layer.borderColor = UIColor.systemGray3.cgColor
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 18, weight: .bold)
        valueLabel.textAlignment = .center
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        titleLabel.textColor = .secondaryLabel
        titleLabel.textAlignment = .center
        
        statView.addSubview(valueLabel)
        statView.addSubview(titleLabel)
        
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: statView.topAnchor, constant: 8),
            valueLabel.leadingAnchor.constraint(equalTo: statView.leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: statView.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: statView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: statView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: statView.bottomAnchor, constant: -8)
        ])
        
        statsStackView.addArrangedSubview(statView)
        
        // 设置统计项的宽度
        statView.widthAnchor.constraint(equalTo: statsStackView.widthAnchor, multiplier: 1/3, constant: -14).isActive = true
        statView.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
}
