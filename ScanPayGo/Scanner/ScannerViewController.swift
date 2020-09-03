//
//  ScannerViewController.swift
//  ScanPayGo
//
//  Created by Ajay Odedra on 03/09/20.
//  Copyright © 2020 Ajay Odedra. All rights reserved.
//



import UIKit
import AVFoundation


/// This delegate method repoponds to the event when any qr code or barcode detected and also respond to an error event.
public protocol ScannerViewControllerDelegate {
  func cameraPermission(error: ScanningError)
  func barcodeDidScannedWith(text: String, error: ScanningError?)
}

/// This class detects qr code, barcode, etc.
public class ScannerViewController: UIViewController {
  //MARK:- Properties
  /// This color will be set on camera overlay
  public var overlayColor: UIColor = UIColor.red
  
  /// This width be set on camera overlay
  public var borderWidth: Float = 3
  /// to close view controller you can set custom bar button
  public var closeBarButton: UIBarButtonItem?
  /// customize the place of the bar button left/right
  public var closeBarButtonDirection: CloseBarButtonDirection = .left
  /// delegate to respons to the caller
  public var delegate: ScannerViewControllerDelegate?
  var captureSession: AVCaptureSession = AVCaptureSession()
  fileprivate var videoPreviewLayer: AVCaptureVideoPreviewLayer?
  
  //MARK:- Class Method
  
  public class func viewControllerFrom(storyboard: String, withIdentifier identifier: String) -> ScannerViewController? {
    return UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: identifier) as? ScannerViewController
  }
  
  // MARK:- View Life Cycle Methods
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    self.setupView()
    
  }
}

//MARK:- Custom Methods
extension ScannerViewController {
  
  fileprivate func setupView() {
    
    AVCaptureDevice.requestAccess(for: .video) { (isGranted) in
      
      DispatchQueue.main.async {
        
        if !isGranted {
          let error = ScanningError(code: .cameraPermissionNotGranted, msg: "CameraPermissionIsNotGranted")
          if self.isModal() {
            self.dismiss(animated: true) {
              self.delegate?.cameraPermission(error: error);
            }
          } else {
            self.navigationController?.popViewController(animated: true)
            self.delegate?.cameraPermission(error: error)
          }
          
          return
        } else {
          self.setUpViewAfterCameraAccess()
        }
      }
    }
  }
  
  fileprivate func setUpViewAfterCameraAccess() {
    
    var err: ScanningError?
    
    let auth = AVCaptureDevice.authorizationStatus(for: .video)
    switch auth {
    case .denied:
      
      err = ScanningError(code: .cameraPermissionNotGranted, msg: "CameraPermissionIsNotGranted")
      
    case .restricted:
      
      err = ScanningError(code: .cameraPermissionRestricted, msg: "CameraPermissionIsRestricted")
      
    case .notDetermined:
      
      err = ScanningError(code: .camerePermissionNotDetermined, msg: "CameraPermissionIsNotDetermined")
      
    default:
      debugPrint("Camera access is given.")
    }
    
    if let error = err {
      
      if isModal() {
        dismiss(animated: true) {
          self.delegate?.cameraPermission(error: error);
        }
      } else {
        navigationController?.popViewController(animated: true)
        self.delegate?.cameraPermission(error: error)
      }
      
      return
    }
    
    if closeBarButton == nil {
      closeBarButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(closeViewController))
    }
    
    if closeBarButtonDirection == .right  {
      navigationItem.rightBarButtonItem = closeBarButton
      navigationItem.leftBarButtonItem = UIBarButtonItem()
    } else {
      navigationItem.leftBarButtonItem = closeBarButton
    }
    
    var deviceType: AVCaptureDevice.DeviceType
    if #available(iOS 10.2, *) {
      deviceType = .builtInWideAngleCamera
    } else {
      deviceType = .builtInDuoCamera
    }
    
    self.view.layer.masksToBounds = true
    let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [deviceType], mediaType: .video, position: .back)
    guard let capureDevice = discoverySession.devices.first else {
      
      let error = ScanningError(code: .cameraNotFound, msg: "Camera Not found.")
      
      if isModal() {
        dismiss(animated: true) {
          self.delegate?.barcodeDidScannedWith(text: "",error: error)
        }
      } else {
        navigationController?.popViewController(animated: true)
        self.delegate?.barcodeDidScannedWith(text: "", error: error)
      }
      return
    }
    do {
      let input = try AVCaptureDeviceInput(device: capureDevice)
      captureSession.addInput(input)
      
      let captureMetaOutput = AVCaptureMetadataOutput()
      captureSession.addOutput(captureMetaOutput)
      
      captureMetaOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
      captureMetaOutput.metadataObjectTypes = [.qr, .code128, .code39, .aztec, .code39Mod43, .ean13, .ean8]
      
      videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
      videoPreviewLayer?.videoGravity = .resizeAspectFill
      videoPreviewLayer?.frame = self.view.layer.bounds
      view.layer.addSublayer(videoPreviewLayer!)
      
      captureSession.startRunning()
    } catch {
      debugPrint(error.localizedDescription)
      let error = ScanningError(code: .unknown, msg: error.localizedDescription)
      if isModal() {
        dismiss(animated: true) {
          self.delegate?.barcodeDidScannedWith(text: "", error: error)
        }
      } else {
        navigationController?.popViewController(animated: true)
        self.delegate?.barcodeDidScannedWith(text: "", error: error)
      }
      return
    }
    self.setOverlayLayer()
  }
  
  fileprivate func setOverlayLayer() {
    
    let overlayPath = UIBezierPath(rect: view.bounds)
    
    let overlayWidth = self.view.frame.size.width * 80 * 0.01
    let x: CGFloat = view.bounds.width/2 - overlayWidth/2
    let y: CGFloat = view.bounds.height/2 - overlayWidth/2 + 44
    
    let transparentPath = UIBezierPath(rect: CGRect(x: x, y: y, width: overlayWidth, height: overlayWidth))
    overlayPath.append(transparentPath);
    overlayPath.usesEvenOddFillRule = true
    
    let fillLayer = CAShapeLayer()
    fillLayer.path = overlayPath.cgPath;
    fillLayer.fillRule = CAShapeLayerFillRule.evenOdd;
    fillLayer.fillColor =  UIColor.black.withAlphaComponent(0.5).cgColor
    self.view.layer.addSublayer(fillLayer)
    
    let lineHeight = overlayWidth/4
    
    //for top left corner
    let path1 = UIBezierPath()
    path1.move(to: CGPoint(x: x, y: y))
    path1.addLine(to: CGPoint(x: x+lineHeight, y: y))
    
    let path2 = UIBezierPath()
    path2.move(to: CGPoint(x: x, y: y))
    path2.addLine(to: CGPoint(x: x, y: y+lineHeight))
    path1.append(path2)
    
    //for top right corner
    let path3 = UIBezierPath()
    path3.move(to: CGPoint(x: x+overlayWidth,y: y))
    path3.addLine(to: CGPoint(x: x+overlayWidth,y: y+lineHeight))
    path1.append(path3)
    
    let path4 = UIBezierPath()
    path4.move(to: CGPoint(x: x+overlayWidth,y: y))
    path4.addLine(to: CGPoint(x: x+overlayWidth-lineHeight,y: y))
    path1.append(path4)
    
    
    //for bottom right
    let path5 = UIBezierPath()
    path5.move(to: CGPoint(x: x+overlayWidth,y: y+overlayWidth))
    path5.addLine(to: CGPoint(x: x+overlayWidth,y: y+overlayWidth-lineHeight))
    path1.append(path5)
    
    let path6 = UIBezierPath()
    path6.move(to: CGPoint(x: x+overlayWidth,y: y+overlayWidth))
    path6.addLine(to: CGPoint(x: x+overlayWidth-lineHeight,y: y+overlayWidth))
    path1.append(path6)
    
    
    //for bottom left
    let path7 = UIBezierPath()
    path7.move(to: CGPoint(x: x,y: y+overlayWidth))
    path7.addLine(to: CGPoint(x: x+lineHeight,y: y+overlayWidth))
    path1.append(path7)
    
    let path8 = UIBezierPath()
    path8.move(to: CGPoint(x: x,y: y+overlayWidth))
    path8.addLine(to: CGPoint(x: x,y: y+overlayWidth-lineHeight))
    path1.append(path8)
    
    let layer = CAShapeLayer()
    layer.path = path1.cgPath
    layer.lineWidth = CGFloat(borderWidth)
    layer.lineCap = CAShapeLayerLineCap.square
    layer.lineJoin = CAShapeLayerLineJoin.bevel
    layer.fillColor = UIColor.clear.cgColor
    layer.strokeColor = overlayColor.cgColor
    self.view.layer.addSublayer(layer)
  }
  
  //-----------------------------------------------------
  
  @objc fileprivate func closeViewController() {
    
    if isModal() {
      navigationController?.dismiss(animated: true, completion: nil)
    } else {
      navigationController?.popViewController(animated: true)
    }
    
  }
  func isModal() -> Bool {
    if self.presentingViewController != nil {
      return true
    } else if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController  {
      return true
    } else if self.tabBarController?.presentingViewController is UITabBarController {
      return true
    }
    
    return false
  }
}

