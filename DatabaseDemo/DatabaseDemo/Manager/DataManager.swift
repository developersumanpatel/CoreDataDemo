//
//  DataManager.swift
//  DatabaseDemo
//
//  Created by Suman on 29/04/20.
//  Copyright © 2020 Suman. All rights reserved.
//

import Foundation
import CoreData

enum CustomError: Error {
    case invalidParsing
}

class DataManager {
    static let shared: DataManager = DataManager()
    
    func fetchNewData(completion: @escaping (Error?) -> ()) {
        if let url = URL(string: Constants.baseUrl) {
            let config = URLSessionConfiguration.default
            config.requestCachePolicy = .reloadIgnoringLocalCacheData
            config.urlCache = nil
            let session = URLSession.init(configuration: config)
            session.dataTask(with: url) { (data, response, error) -> Void in
                if error == nil && data != nil {
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                        if let responseJson = jsonResult as? [String:Any] {
                            guard
                                let products = responseJson["products"] as? [String: Any]
                                else {
                                    completion(CustomError.invalidParsing)
                                    return
                            }
                            var productDict: [[String: Any]] = []
                            for key in products.keys {
                                var newDict = products[key] as? [String: Any]
                                newDict?["productId"] = key
                                if newDict != nil {
                                    productDict.append(newDict!)
                                }
                            }
                            DispatchQueue.main.async {
                                AppDelegate.shared.persistentContainer.performBackgroundTask({ (backgroundContext) in
                                    backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                                    Mobile.performMobileDataLoad(fromData: productDict, inContext: backgroundContext)
                                    DispatchQueue.main.async {
                                        completion(nil)
                                    }
                                })
                            }
                        }
                    } catch {
                        completion(error)
                    }
                } else {
                    completion(error)
                }
            }.resume()
        }
    }
}
