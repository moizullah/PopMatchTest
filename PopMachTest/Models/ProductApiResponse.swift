//
//  ProductApiResponse.swift
//  PopMachTest
//
//  Created by Moiz on 12/01/2019.
//  Copyright © 2019 Moiz Ullah. All rights reserved.
//

import Foundation

struct ProductApiResponse: Codable {
    let status: Bool
    let products: [Product]
    let total: Int
    let productsPerPage: Int
    let hasNextPage: Bool
    let responseCode: Int
    
    enum CodingKeys: String, CodingKey {
        case status
        case products = "data"
        case total
        case productsPerPage = "per_page"
        case hasNextPage = "have_next_page"
        case responseCode = "code"
    }
}
