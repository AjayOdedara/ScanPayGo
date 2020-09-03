//
//  CartData.swift
//  ScanPayGo
//
//  Created by Ajay Odedra on 03/09/20.
//  Copyright © 2020 Ajay Odedra. All rights reserved.
//

import Foundation

typealias Codable = Decodable & Encodable

// MARK: - Cart
struct Cart: Codable {
  let cartData: [CartData]
}

// MARK: - CartData
struct CartData: Codable {
  let identity: String
  let title: String
  let price: Double
  let imageName: String
  let quantity: Int
}

extension Double {
  var format: String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    let currencySymbol = Locale.current.currencySymbol ?? "$"
    let formattedNumber = numberFormatter.string(from: NSNumber(value: self))
    return "\(currencySymbol)" + (formattedNumber ?? "0")
  }
}

