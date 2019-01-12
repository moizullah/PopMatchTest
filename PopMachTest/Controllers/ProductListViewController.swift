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
    
    // MARK: - Properties
    let networkService = NetworkService.shared
    var products = [Product]()
    private var pageNumber = 1
    private var isLastPage = false
    private var isLoading = false

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // CollectionView settings
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
        
        // Color settings
        view.backgroundColor = Theme.darkBackground
        collectionView.backgroundColor = .clear
        
        // Nav settings
        navigationItem.title = "Products"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Download products
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
                self.products = products
                self.isLastPage = isLastPage
                self.collectionView.reloadData()
            }
        }
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
