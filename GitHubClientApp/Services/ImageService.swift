//
//  ImageService.swift
//  GitHubClientApp
//
//  Created by Chuan on 2025/5/22.
//

import Foundation
import Kingfisher

protocol ImageServiceProtocol {
    func loadImage(url: URL, into imageView: UIImageView)
}

class ImageService: ImageServiceProtocol {
    private let placeholderImage = UIImage(named: "defaultImage") // 默认图片, 从Assets获取
        
        func loadImage(url: URL, into imageView: UIImageView) {
            imageView.kf.setImage(
                with: url,
                placeholder: placeholderImage, // 加载中/失败时显示
                options: [.transition(.fade(0.2))] // 可选动画
            )
        }
}    
