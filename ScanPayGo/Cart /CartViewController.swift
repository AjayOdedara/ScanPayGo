//
//  CartViewController.swift
//  ScanPayGo
//
//  Created by Ajay Odedra on 03/09/20.
//  Copyright © 2020 Ajay Odedra. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {

  @IBOutlet weak var startScanBtn: UIButton!{
    didSet{
      startScanBtn.layer.cornerRadius = 5
      startScanBtn.layer.borderWidth = 1
      startScanBtn.layer.borderColor = startScanBtn.titleColor(for: .normal)!.cgColor
    }
  }
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUp()
  }
  // MARK: - View Setup
  private func setUp() {
    self.title = CartConstants.ScanView.navigationTitle
    
    tableView.tableFooterView = UIView()
    tableView.dataSource = self
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableView.automaticDimension
    /// Register Talbe cell
    tableView.register(UINib(nibName: CartConstants.Identifier.tableViewCellReuseIdentifier,
                             bundle: nil),
                       forCellReuseIdentifier: CartConstants.Identifier.tableViewCellReuseIdentifier)
  }

  // MARK: - Navigation Actions
  @IBAction func startScanBtnPressed() {
    guard let scannerView = ScannerViewController.viewControllerFrom(storyboard: "Main",
                                                                     withIdentifier: "ScannerViewController") else {
      return
    }
    scannerView.delegate = self
    scannerView.closeBarButtonDirection = .right
    scannerView.overlayColor = UIColor.white
    scannerView.closeBarButton = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(close))
    let nav = UINavigationController(rootViewController: scannerView)
    nav.navigationBar.tintColor = UIColor.black
    nav.navigationBar.barTintColor = UIColor.white
    present(nav, animated: true, completion: nil)
  }
  
  @objc func close() {
    self.dismiss(animated: true, completion: nil)
  }

}

//MARK: - ScannerViewControllerDelegate
extension CartViewController: ScannerViewControllerDelegate {
  func cameraPermission(error: ScanningError) {
    print(error)
  }
  func barcodeDidScannedWith(text: String, error: ScanningError?) {
    if error != nil {
      return
    }
    print(text)
  }
}
// MARK: - Alert
extension CartViewController: SingleButtonDialogPresenter { }


// MARK: - TableView DataSource
extension CartViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: CartConstants.Identifier.tableViewCellReuseIdentifier, for: indexPath) as? TableViewCartItemCell else {
      return UITableViewCell()
    }
    return cell
  }
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  internal func tableView(_ tableView: UITableView,
                          commit editingStyle: UITableViewCell.EditingStyle,
                          forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      
    }
  }
}
