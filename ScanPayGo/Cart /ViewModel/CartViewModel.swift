//
//  CartViewModel.swift
//  ScanPayGo
//
//  Created by Ajay Odedra on 03/09/20.
//  Copyright © 2020 Ajay Odedra. All rights reserved.
//

import Foundation

class CartViewModel {
  var checkOutTotal: String? {
    let total = searchResultData.value.map({$0.price}).reduce(0, +).format
    return total + CartConstants.ScanView.checkOutText
  }
  // Error Presentors
  var onShowError: ((_ alert: SingleButtonAlert) -> Void)?
  var searchResultData = Bindable([CartData]())
  // API service init
  let appServerClient = AppServerClient.sharedInstance
  func getProduct(from id: String) {
    guard let data = pathToData() else { return }
    appServerClient.getProducts(of: Cart.self, from: data) { result in
      switch result {
      case .failure(let error):
        // Show Alert
        let alert = SingleButtonAlert(title: CartConstants.AlertView.alertTitle,
                                      message: error.localizedDescription,
                                      action: AlertAction(buttonTitle: CartConstants.AlertView.alertOkayButtonTitle, handler: {
            print("Alert action clicked")
        }))
        self.onShowError?(alert)
      case .success(let cart):
        print(cart)
        if let data = cart.cartData.filter({$0.identity == id}).first {
          self.searchResultData.value.append(data)
        }
      }
    }
  }
  /// Return `Data` From `Url` path Json
  func pathToData() -> Data? {
    if let path = Bundle.main.path(forResource: CartConstants.JSON.productJsonName, ofType: "json") {
      do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        return data
      } catch {
        print(DataError.invalidPath)
      }
    }
    return nil
  }
  /// Deletes the Cart Item at `Index`
  func deleteCartItem(at index: Int) {
    searchResultData.value.remove(at: index)
  }
}
