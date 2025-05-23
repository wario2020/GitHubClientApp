//
//  HomeViewController.swift
//  GitHubClientApp
//
//  Created by Chuan on 2025/5/22.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    private var viewModel: HomeViewModelProtocol
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RepositoryCell.self, forCellReuseIdentifier: RepositoryCell.identifier)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private let userInfoView: UserInfoView = {
        let view = UserInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Logout", comment: "退出"), for: .normal)
        button.tintColor = .red
        return button
    }()
    
    private let errorView: ErrorView = {
        let view = ErrorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private let loginStatusLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            label.textAlignment = .center
            label.textColor = .secondaryLabel
            return label
        }()
    
    //三个导航按钮
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Login", comment: "Login"), for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let profileButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Profile", comment: "Profile"), for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Search", comment: "Search"), for: .normal)
        button.backgroundColor = .systemOrange
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    init(viewModel: HomeViewModelProtocol) {
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
        fetchData()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        tableView.backgroundColor = .systemBackground
        errorView.backgroundColor = .systemBackground
        
        // 添加按钮到栈视图
        buttonStackView.addArrangedSubview(loginButton)
        buttonStackView.addArrangedSubview(profileButton)
        buttonStackView.addArrangedSubview(searchButton)
        
        // 添加所有视图
        view.addSubview(buttonStackView)
        view.addSubview(tableView)
        view.addSubview(userInfoView)
        view.addSubview(logoutButton)
        view.addSubview(errorView)
        view.addSubview(loginStatusLabel)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        updateLoginStatus()
        navigationItem.title = "GitHub"
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // 按钮栈视图约束
            buttonStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStackView.heightAnchor.constraint(equalToConstant: 44),
            
            // 用户信息视图约束调整
            userInfoView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 20),
            userInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userInfoView.heightAnchor.constraint(equalToConstant: 200),
            
            logoutButton.topAnchor.constraint(equalTo: userInfoView.bottomAnchor, constant: 10),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // 登录状态 Label 约束（新增：位于 logoutButton 下方）
            loginStatusLabel.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 10), // 关键修改点
            loginStatusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loginStatusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loginStatusLabel.heightAnchor.constraint(equalToConstant: 20),
            
            tableView.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            errorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupActions() {
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        // 新增：按钮点击事件
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
    }
    
    private func updateLoginStatus() {
        if viewModel.isAuthenticated {
            loginStatusLabel.text = NSLocalizedString("Already logged in", comment: "已登录")
            loginStatusLabel.textColor = .systemGreen
        } else {
            loginStatusLabel.text = NSLocalizedString("Not logged in", comment: "未登录")
            loginStatusLabel.textColor = .systemRed
        }
    }
    
    private func fetchData() {
        if viewModel.isAuthenticated {
            viewModel.fetchUser()
            viewModel.fetchRepositories()
            
            // 已登录时隐藏登录按钮
//            loginButton.isHidden = true
        } else {
//            // 未登录时隐藏个人资料按钮
//            profileButton.isHidden = true
//
//            // 未登录状态下的处理
//            tableView.isHidden = true
//            userInfoView.isHidden = true
//            logoutButton.isHidden = true
        }
    }
    
    @objc private func logoutButtonTapped() {
        viewModel.logout()
    }
    
    // 新增：按钮点击处理方法
    @objc private func loginButtonTapped() {
       // 采用Coordinator方式打开登录页面，相关Service从AppDelegate获取
       guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
       let authCoordinator = AuthCoordinator(
           navigationController: navigationController ?? UINavigationController(),
           authService: appDelegate.authService,
           keychainService: appDelegate.keychainService,
           networkService: appDelegate.networkService
       )
       authCoordinator.start()
        
//        let loginViewModel = LoginViewModel(
//            authService: appDelegate.authService,
//            keychainService: appDelegate.keychainService,
//            networkService: appDelegate.networkService
//        )
//        let loginVC = LoginViewController(viewModel: loginViewModel)
//        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @objc private func profileButtonTapped() {
        
        let profileVC = ProfileViewController()
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @objc private func searchButtonTapped() {
        let searchVC = SearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.identifier, for: indexPath) as! RepositoryCell
        let repository = viewModel.repositories[indexPath.row]
        cell.configure(with: repository)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func didLogout() {
        // 刷新界面状态
        fetchData()
        
        // 可以添加登出后跳转逻辑
    }
    
    func didLoadUser() {
        if let user = viewModel.user {
            userInfoView.configure(with: user)
            
            // 登录成功后更新按钮状态
//            loginButton.isHidden = true
//            profileButton.isHidden = false
//            tableView.isHidden = false
//            userInfoView.isHidden = false
//            logoutButton.isHidden = false
        }
    }
    
    func didFailToLoadUser(with error: Error) {
        showError(error.localizedDescription)
    }
    
    func didLoadRepositories() {
        tableView.reloadData()
    }
    
    func didFailToLoadRepositories(with error: Error) {
        showError(error.localizedDescription)
    }
    
    private func showError(_ message: String) {
        errorView.configure(with: message)
        errorView.isHidden = false
    }
}
