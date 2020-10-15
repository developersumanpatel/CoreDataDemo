//
//  Mobile+CoreDataProperties.swift
//  DatabaseDemo
//
//  Created by Suman on 29/04/20.
//  Copyright © 2020 Suman. All rights reserved.
//
//

import Foundation
import CoreData


extension Mobile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Mobile> {
        return NSFetchRequest<Mobile>(entityName: "Mobile")
    }

    @NSManaged public var subcategory: String?
    @NSManaged public var title: String?
    @NSManaged public var popularity: Int64
    @NSManaged public var price: Int64
    @NSManaged public var isDataDeleted: Bool
    @NSManaged public var productId: String?
}
