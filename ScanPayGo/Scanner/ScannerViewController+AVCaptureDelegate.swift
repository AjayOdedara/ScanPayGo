//
//  ScannerViewController.swift
//  ScanPayGo
//
//  Created by Ajay Odedra on 03/09/20.
//  Copyright © 2020 Ajay Odedra. All rights reserved.
//


import UIKit
import AVFoundation

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
  
  public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    
    guard metadataObjects.count > 0 else {
      return
    }
    
    self.captureSession.stopRunning()
    
    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    
    if let metaObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
      
      if let strVal = metaObject.stringValue {
        
        if isModal() {
          dismiss(animated: true) {
            self.delegate?.barcodeDidScannedWith(text: strVal, error: nil)
          }
        } else {
          navigationController?.popViewController(animated: true)
          self.delegate?.barcodeDidScannedWith(text: strVal, error: nil)
        }
        
      } else {
        
        let error = ScanningError(code: .barCodeNotScanned, msg: "BarcodeDidNotScanned")
        
        if isModal() {
          dismiss(animated: true) {
            self.delegate?.barcodeDidScannedWith(text: "", error: error)
          }
        } else {
          navigationController?.popViewController(animated: true)
          self.delegate?.barcodeDidScannedWith(text: "", error: error)
        }
        
      }
      
    } else {
      
      let error = ScanningError(code: .barCodeNotScanned, msg: "BarcodeDidNotScanned")
      
      if isModal() {
        dismiss(animated: true) {
          
          self.delegate?.barcodeDidScannedWith(text: "", error: error)
        }
        
      } else {
        navigationController?.popViewController(animated: true)
        self.delegate?.barcodeDidScannedWith(text: "", error: error)
      }
      
    }
  }
}
