//
//  NetworkService.swift
//  PopMachTest
//
//  Created by Moiz on 12/01/2019.
//  Copyright © 2019 Moiz Ullah. All rights reserved.
//

import Foundation
import UIKit

class NetworkService {

    /// API Urls
    ///
    /// - ProductsList: Product listing API
    enum API: String {
        case ProductsList = "https://dev.popmach.com/api/listing/products/latest"
    }
    
    // MARK: - Properties
    /// Shared instance of NetworkService
    public static let shared = NetworkService()
    
    private let session: URLSession

    // MARK: - Init
    private init() {
        session = URLSession.shared
    }
    
    // MARK: - Methods
    
    
    /// Fetch products from the server for the given page number. This function also downloads any images
    /// for each of the downloaded products. It also checks if the last page of the listing has been reached
    /// or not. The list of `Product` objects is returned via a completion block.
    ///
    /// - Parameters:
    ///   - page: The page number to fetch.
    ///   - completion: Completion block that returns the response
    ///   - products: An optional array of `Product` objects
    ///   - isLastPage: A flag indicating whether the current page is marked as the last page by the server
    ///   - error: An optional error object
    func downloadProducts(page: Int, completion: @escaping (_ products: [Product]?, _ isLastPage: Bool, _ error: Error?) -> Void) {
        let url = URL(string: API.ProductsList.rawValue + "?page=\(page)")!
        let group = DispatchGroup()

        // Request products listing parsed as ProductApiResponse
        requestJSON(from: url, model: ProductApiResponse.self) { (response, error) in
            guard error == nil else {
                completion(nil, true, error)
                return
            }
            
            guard let response = response else {
                completion(nil, true, error)
                return
            }
            
            let products = response.products
            // Fetch image for each product
            products.forEach({ (product) in
                group.enter()
                self.session.dataTask(with: product.imageUrl, completionHandler: { (data, _, error) in
                    if let data = data {
                        product.image = UIImage(data: data)
                    }
                    group.leave()
                }).resume()
            })
            
            // Call completion block once all requests have finished
            group.notify(queue: DispatchQueue.global(), execute: {
                completion(products, !response.hasNextPage, nil)
            })
        }
    }
    
    
    /// Download data from a given `URL` and parse it as JSON, based on the given data model. The given
    /// data model must conform to the `Codable` protocol.
    ///
    /// - Parameters:
    ///   - url: The `URL` from which the data has to be downloaded.
    ///   - model: The JSON data model to which the data must be parsed.
    ///   - completion: Completion block that returns the response.
    ///   - data: An optional object of the given data model's Type
    ///   - error: An optional error object
    func requestJSON<T>(from url: URL, model: T.Type, completion: @escaping (_ data: T?, _ error: Error?) -> Void) where T: Codable {
        session.dataTask(with: url) { (data, _, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, nil)
                return
            }
            
            do {
                let parsedData = try JSONDecoder().decode(T.self, from: data)
                completion(parsedData, nil)
            } catch let error {
                completion(nil, error)
            }
        }.resume()
    }
}
