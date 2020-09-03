//
//  ScanError+Struct.swift
//  ScanPayGo
//
//  Created by Ajay Odedra on 03/09/20.
//  Copyright © 2020 Ajay Odedra. All rights reserved.
//

import Foundation

public enum ErrorCode {
  case cameraNotFound
  case cameraPermissionNotGranted
  case cameraPermissionRestricted
  case camerePermissionNotDetermined
  case barCodeNotScanned
  case unknown
}

/// ScanningError struct to combine error with code
public struct ScanningError: Error {
  public let code: ErrorCode
  public let msg: String
}

public enum CloseBarButtonDirection {
  case right
  case left
}

