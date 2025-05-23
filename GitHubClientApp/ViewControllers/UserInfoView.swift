//
//  UserInfoView.swift
//  GitHubClientApp
//
//  Created by Chuan on 2025/5/22.
//

import Foundation
import UIKit

class UserInfoView: UIView {
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        imageView.image = UIImage(named: "defaultImage") //默认图片, 从Assets取
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 2
        return label
    }()
    
    private let statsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let reposCountView: StatView = {
        let view = StatView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let followersCountView: StatView = {
        let view = StatView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let followingCountView: StatView = {
        let view = StatView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageService: ImageServiceProtocol = ImageService()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        addSubview(nameLabel)
        addSubview(bioLabel)
        addSubview(statsStackView)
        
        statsStackView.addArrangedSubview(reposCountView)
        statsStackView.addArrangedSubview(followersCountView)
        statsStackView.addArrangedSubview(followingCountView)
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 4
        layer.masksToBounds = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            avatarImageView.widthAnchor.constraint(equalToConstant: 80),
            avatarImageView.heightAnchor.constraint(equalToConstant: 80),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 20),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            nameLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            bioLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 15),
            bioLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            bioLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            statsStackView.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 15),
            statsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            statsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            statsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with user: User) {
        usernameLabel.text = user.login
        nameLabel.text = user.name ?? "No name provided"
        bioLabel.text = user.bio ?? "No bio provided"
        
        reposCountView.configure(title: "Repos", count: user.publicRepos)
        followersCountView.configure(title: "Followers", count: user.followers)
        followingCountView.configure(title: "Following", count: user.following)
        
        if let avatarUrl = URL(string: user.avatarUrl) {
            imageService.loadImage(url: avatarUrl, into: avatarImageView)
        } 
    }
}    
