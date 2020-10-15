//
//  HomeDelegate.swift
//  DatabaseDemo
//
//  Created by Suman on 29/04/20.
//  Copyright © 2020 Suman. All rights reserved.
//

import Foundation
import CoreData

protocol HomeDelegate: NSFetchedResultsControllerDelegate {
    func finishWithError(_ error: String?)
}
