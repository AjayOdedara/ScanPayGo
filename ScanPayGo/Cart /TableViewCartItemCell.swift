//
//  TableViewCartItemCell.swift
//  ScanPayGo
//
//  Created by Ajay Odedra on 03/09/20.
//  Copyright © 2020 Ajay Odedra. All rights reserved.
//

import UIKit

class TableViewCartItemCell: UITableViewCell {
  
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var productImageView: UIImageView!
  @IBOutlet weak var productTitle: UILabel!
  @IBOutlet weak var productPrice: UILabel!
  @IBOutlet weak var quantityLbl: UILabel!

  override func awakeFromNib() {
    contentView.backgroundColor = .clear
    containerView.layer.cornerRadius = 5
    productImageView.layer.cornerRadius = 5
    productImageView.layer.borderWidth = 0.5
    productImageView.clipsToBounds = true
    containerView.clipsToBounds = true
  }
  var cart: CartData? {
    didSet {
      initWith()
    }
  }
  /**
    * Use to present the data of cell with CartData object type.
     - Parameter cart: cart data
   */
  func initWith() {
      guard let cart = cart else {
          return
      }
    productImageView.image = UIImage(named: cart.imageName)
    productTitle.text = cart.title
    productPrice.text = cart.price.format
  }
  override func prepareForReuse() {
    productImageView.image = nil
    productTitle.text = nil
    productPrice.text = nil
  }
  @IBAction func cartQuantityValueChange(_ sender: UIStepper) {
    // TODO: - Update value to cart viewmodel
    let qty = sender.value
    quantityLbl.text = "\(Int(qty))"
    guard let cart = cart else {
        return
    }
    productPrice.text = (cart.price * qty).format
  }
}
