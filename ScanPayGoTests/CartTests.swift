//
//  CartTests.swift
//  ScanPayGoTests
//
//  Created by Ajay Odedra on 03/09/20.
//  Copyright © 2020 Ajay Odedra. All rights reserved.
//

import XCTest
@testable import ScanPayGo

class CartTests: XCTestCase {
  
  let viewModel: CartViewModel = CartViewModel()
  let appServerClient = AppServerClient.sharedInstance
  
  func testJSONData() {
    let expectHandlerCall = XCTestExpectation(description: "JSON Data response")
    guard let data = viewModel.pathToData() else {
      XCTFail("Failed to get JSON Data response")
      return
    }
    print("Data:", data)
    expectHandlerCall.fulfill()
    wait(for: [expectHandlerCall], timeout: 0.5)
  }
  func testGetProduct(){
    let productId = "20930824"
    let expectHandlerCall = XCTestExpectation(description: "Cart Data response")
    
    guard let data = viewModel.pathToData() else {
      XCTFail("Failed to get JSON Data response")
      return
    }
    appServerClient.getProducts(of: Cart.self, from: data) { result in
      switch result {
      case .failure(let error):
        XCTFail("Failed to get Cart Data response, reason: \(error.localizedDescription)")
      case .success(let cart):
        print(cart)
        if let data = cart.cartData.filter({$0.identity == productId}).first {
          print("Data:", data)
          expectHandlerCall.fulfill()
        }
      }
    }
    wait(for: [expectHandlerCall], timeout: 0.5)
  }
  
}
