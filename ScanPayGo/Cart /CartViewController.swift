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
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
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
