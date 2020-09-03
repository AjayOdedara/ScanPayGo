//
//  SearchAlbumConstant.swift
//  ScanPayGo
//
//  Created by Ajay Odedra on 03/09/20.
//  Copyright © 2020 Ajay Odedra. All rights reserved.
//

import UIKit
public struct CartConstants {
  struct JSON {
    static let productJsonName = "cartData"
  }
  struct ScanView {
    static let navigationTitle = NSLocalizedString("cart_navigation_bar_title",
                                                   comment: "Cart navigation large title")
    static let checkOutText = NSLocalizedString("cart_navigation_bar_checkout_title",
                                                comment: "Cart navigation check-out title")
  }
  struct Identifier {
    static let tableViewCellReuseIdentifier = "TableViewCartItemCell"
  }
  struct AlertView {
    static let defaultMessgae = NSLocalizedString("cart_api_failure",
                                                  comment: "Default api failure message")
    static let alertTitle = NSLocalizedString("cart_alert_error_title",
                                              comment: "Alert title for failure")
    static let alertOkayButtonTitle = NSLocalizedString("cart_alert_okay_title",
                                                        comment: "Alert okay button title for failure")
  }
}
