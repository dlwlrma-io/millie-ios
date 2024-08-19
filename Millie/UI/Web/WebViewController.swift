//
//  WebViewController.swift
//  Millie
//
//  Created by dlwlrma on 8/19/24.
//

import Combine
import Foundation
import SnapKit
import UIKit
import WebKit

class WebViewController: UIViewController {
    private let viewModel = WebViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    var contentTitle: String = ""
    var contentUrl: String = ""
    
    private let navigationBar: UIView = {
        let view = UIView()
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        initNavigationBar()
        initWebView()
        loadWebView()
    }
    
    private func initNavigationBar() {
        navigationBar.addSubview(titleLabel)
        navigationBar.addSubview(backButton)
        
        titleLabel.text = contentTitle
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(80)
            $0.trailing.equalToSuperview().inset(80)
            $0.center.equalToSuperview()
        }
        
        backButton.addTarget(self, action: #selector(onBackButtonAction), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.snp.makeConstraints {
            $0.width.equalTo(40)
            $0.height.equalTo(40)
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        view.addSubview(navigationBar)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.snp.makeConstraints {
            $0.width.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(56)
            $0.leading.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func initWebView() {
        view.addSubview(webView)
        webView.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func loadWebView() {
        guard let url = URL(string: contentUrl) else {
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }

    @objc func onBackButtonAction(sender: UIButton) {
        self.dismiss(animated: true)
    }
}
