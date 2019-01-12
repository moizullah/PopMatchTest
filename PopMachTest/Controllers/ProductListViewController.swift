//
//  ProductListViewController.swift
//  PopMachTest
//
//  Created by Moiz on 12/01/2019.
//  Copyright © 2019 Moiz Ullah. All rights reserved.
//

import UIKit

private let cellReuseIdentifier = "productListCell"

class ProductListViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomRefreshContainer: UIView!
    @IBOutlet weak var bottomActivityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    let refreshControl = UIRefreshControl()
    let networkService = NetworkService.shared
    var products = [Product]()
    private var pageNumber = 1
    private var isLastPage = false
    private var isLoading = true

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // CollectionView settings
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.refreshControl = refreshControl

        // Refresh control
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.tintColor = Theme.yellowTint
        
        bottomActivityIndicator.color = Theme.yellowTint
        bottomRefreshContainer.backgroundColor = .clear
        bottomRefreshContainer.frame.size.height = 60
        bottomRefreshContainer.transform = CGAffineTransform(translationX: 0, y: 60)
        
        // Color settings
        view.backgroundColor = Theme.darkBackground
        collectionView.backgroundColor = .clear
        
        // Nav settings
        navigationItem.title = "Products"
        
        // Download products
        showBottomActivityIndicator()
        downloadProducts()
    }
    
    
    /// Download products from the server using the current page number.
    func downloadProducts() {
        isLoading = true
        networkService.downloadProducts(page: pageNumber) { [weak self] (products, isLastPage, error) in
            guard let `self` = self else { return }
            self.isLoading = false

            guard error == nil else {
                print("Error downloading: \(String(describing: error))")
                return
            }
            
            guard let products = products else {
                print("No data found")
                return
            }
            
            DispatchQueue.main.async {
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                    self.products.removeAll()
                }
                self.hideBottomActivityIndicator()
                self.products.append(contentsOf: products)
                self.pageNumber += 1
                self.isLastPage = isLastPage
                self.collectionView.reloadData()
            }
        }
    }
    
    func showBottomActivityIndicator() {
        self.bottomRefreshContainer.isHidden = false
        self.bottomActivityIndicator.startAnimating()
        UIView.animate(withDuration: 1.0) {
            self.bottomRefreshContainer.transform = CGAffineTransform.identity
        }
    }
    
    func hideBottomActivityIndicator() {
        self.bottomActivityIndicator.stopAnimating()
        UIView.animate(withDuration: 1.0) {
            self.bottomRefreshContainer.isHidden = true
            self.bottomRefreshContainer.transform = CGAffineTransform(translationX: 0, y: 60)
        }
    }
    
    // Refresh control action
    @objc func refreshData(_ sender: UIRefreshControl) {
        pageNumber = 1
        isLastPage = false
        downloadProducts()
    }
}

// MARK: - UICollectionViewDelegate
extension ProductListViewController: UICollectionViewDelegate {}

// MARK: - UICollectionViewDataSource
extension ProductListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        guard let productCell = cell as? ProductCollectionViewCell else {
            return cell
        }
        let product = products[indexPath.row]
        productCell.displayProduct(product: product)
        return productCell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProductListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat((collectionView.bounds.size.width / 2) - 15)
        return CGSize(width: width, height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

// MARK: - UIScrollView Methods
extension ProductListViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Fetch more data when user reaches end of current list
        let height = scrollView.frame.size.height
        let contentOffsetY = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentOffsetY
        if distanceFromBottom < height {
            if !isLoading && !isLastPage {
                showBottomActivityIndicator()
                downloadProducts()
            }
        }
    }
}
