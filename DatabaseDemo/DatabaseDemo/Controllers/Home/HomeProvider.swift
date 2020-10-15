//
//  HomeProvider.swift
//  DatabaseDemo
//
//  Created by Suman on 29/04/20.
//  Copyright © 2020 Suman. All rights reserved.
//

import Foundation

struct HomeProvider {
    func fetchNewData(completion: @escaping (Error?) -> ()) {
        DataManager.shared.fetchNewData{ error in
            completion(error)
        }
    }
}
