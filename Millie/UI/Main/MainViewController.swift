//
//  MainViewController.swift
//  Millie
//
//  Created by dlwlrma on 8/18/24.
//

import Combine
import UIKit

class MainViewController: UIViewController {
    private let viewModel = MainViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initView()
        initViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateLayout()
    }
    
    private func initView() {
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func initViewModel() {
        viewModel.diffableDataSource = NewsDiffableDataSource(collectionView: collectionView) {
            (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as? MainCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.bind(news: itemIdentifier)
            return cell
        }
        
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "MainCollectionViewCell")
        collectionView.dataSource = viewModel.diffableDataSource
    }
    
    func updateLayout() {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let numberOfColumns: CGFloat = UIDevice.current.orientation.isLandscape ? 3 : 1
            let totalSpacing = (numberOfColumns - 1) * flowLayout.minimumInteritemSpacing + flowLayout.sectionInset.left + flowLayout.sectionInset.right
            let itemWidth = (collectionView.bounds.width - totalSpacing) / numberOfColumns
            flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
            flowLayout.invalidateLayout()
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let news = viewModel.diffableDataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        let viewController = WebViewController()
        viewController.contentTitle = news.title
        viewController.contentUrl = news.url
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
}
