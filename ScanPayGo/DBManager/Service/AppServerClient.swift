//
//  AppServerClient.swift
//  ScanPayGo
//
//  Created by Ajay Odedra on 03/09/20.
//  Copyright © 2020 Ajay Odedra. All rights reserved.
//

import UIKit

enum DataError: Error {
  case decodingError
  case invalidPath
}

class AppServerClient {
  static var sharedInstance: AppServerClient = AppServerClient()
  /**
   * Use to call `Data`convert to given model.
   - Parameter Data: Data of json
   */

  typealias ResultBlock<T> = (Result <T, Error>) -> Void
  func getProducts<T: Decodable>(of type: T.Type,
                             from data: Data,
                             completion: @escaping ResultBlock<T>) {
    do {
      let decodedData: T = try JSONDecoder().decode(T.self, from: data)
      completion(.success(decodedData))
    } catch {
      completion(.failure(DataError.decodingError))
    }
  }
}
