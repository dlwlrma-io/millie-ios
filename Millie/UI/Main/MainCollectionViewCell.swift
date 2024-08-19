//
//  MainCollectionViewCell.swift
//  Millie
//
//  Created by dlwlrma on 8/19/24.
//

import Foundation
import Kingfisher
import SnapKit
import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override var isSelected: Bool{
        didSet {
            if isSelected {
                titleLabel.textColor = .red
            } else {
                titleLabel.textColor = .black
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    func initView() {
        self.backgroundColor = UIColor.white
        self.addSubview(titleLabel)
        self.addSubview(dateLabel)
        self.addSubview(imageView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    func bind(news: News) {
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: news.publishedAt) else {
            fatalError("Invalid ISO 8601 date string")
        }
        
        let koreaTimeZone = TimeZone(identifier: "Asia/Seoul")!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 HH:mm"
        dateFormatter.timeZone = koreaTimeZone
        
        titleLabel.text = news.title
        dateLabel.text = dateFormatter.string(from: date)
        
        let urlToImage = URL(string: news.urlToImage ?? "")
        let placeholder = UIImage(named: "NoImagePlaceholder")
        imageView.kf.setImage(with: urlToImage, placeholder: placeholder)
    }
}
