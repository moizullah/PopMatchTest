//
//  Product.swift
//  PopMachTest
//
//  Created by Moiz on 12/01/2019.
//  Copyright © 2019 Moiz Ullah. All rights reserved.
//

import Foundation
import UIKit

class Product: Codable {
    let id: Int
    let name: String
    let price: String
    let type: String
    var image: UIImage?
    let imageUrl: URL
    let category: String
    let country: String
    let state: String
    let currency: String
    let isFavourite: Bool
    let dateCreated: String
    let dateUpdated: String
    let showFavouriteButton: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "product_id"
        case name = "product_name"
        case price = "product_price"
        case type = "product_type"
        case imageUrl = "image"
        case category = "category_name"
        case country
        case state
        case currency
        case isFavourite = "is_favourite"
        case dateCreated = "date_created"
        case dateUpdated = "date_updated"
        case showFavouriteButton = "show_button_favourite"
    }
    
    init(id: Int, name: String, price: String, type: String, imageUrl: URL, category: String, country: String, state: String, currency: String, isFavourite: Bool, dateCreated: String, dateUpdated: String, showFavouriteButton: Bool) {
        self.id = id
        self.name = name
        self.price = price
        self.type = type
        self.imageUrl = imageUrl
        self.category = category
        self.country = country
        self.state = state
        self.currency = currency
        self.isFavourite = isFavourite
        self.dateCreated = dateCreated
        self.dateUpdated = dateUpdated
        self.showFavouriteButton = showFavouriteButton
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(price, forKey: .price)
        try container.encode(type, forKey: .type)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(category, forKey: .category)
        try container.encode(country, forKey: .country)
        try container.encode(state, forKey: .state)
        try container.encode(currency, forKey: .currency)
        try container.encode(isFavourite, forKey: .isFavourite)
        try container.encode(dateCreated, forKey: .dateCreated)
        try container.encode(dateUpdated, forKey: .dateUpdated)
        try container.encode(showFavouriteButton, forKey: .showFavouriteButton)
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let price = try container.decode(String.self, forKey: .price)
        let type = try container.decode(String.self, forKey: .type)
        let imageUrl = try container.decode(URL.self, forKey: .imageUrl)
        let category = try container.decode(String.self, forKey: .category)
        let country = try container.decode(String.self, forKey: .country)
        let state = try container.decode(String.self, forKey: .state)
        let currency = try container.decode(String.self, forKey: .currency)
        let isFavourite = try container.decode(Bool.self, forKey: .isFavourite)
        let dateCreated = try container.decode(String.self, forKey: .dateCreated)
        let dateUpdated = try container.decode(String.self, forKey: .dateUpdated)
        let showFavouriteButton = try container.decode(Bool.self, forKey: .showFavouriteButton)
        
        self.init(id: id, name: name, price: price, type: type, imageUrl: imageUrl, category: category, country: country, state: state, currency: currency, isFavourite: isFavourite, dateCreated: dateCreated, dateUpdated: dateUpdated, showFavouriteButton: showFavouriteButton)
    }
}
