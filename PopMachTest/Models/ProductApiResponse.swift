//
//  ProductApiResponse.swift
//  PopMachTest
//
//  Created by Moiz on 12/01/2019.
//  Copyright © 2019 Moiz Ullah. All rights reserved.
//

import Foundation

struct ProductApiResponse: Codable {
    let status: String
    let products: [Product]
    let total: Int
    let productsPerPage: Int
    let hasNextPage: Bool
    let responseCode: Int
}
