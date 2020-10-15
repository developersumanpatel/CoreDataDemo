//
//  Mobile+CoreDataClass.swift
//  DatabaseDemo
//
//  Created by Suman on 29/04/20.
//  Copyright © 2020 Suman. All rights reserved.
//
//

import Foundation
import CoreData


public class Mobile: NSManagedObject, ManagedObjectProtocol {
    public enum Keys: String {
        case productId
        case isDataDeleted
        case price
        case title
    }
}

extension Mobile {
    
    // MARK: Data Loading
    public class func performMobileDataLoad(fromData: [[String: Any]], inContext:NSManagedObjectContext) {
        let existingData = self.findAll(in: inContext)
        
        existingData.forEach {
            $0.isDataDeleted = true
        }
        var predicate: NSPredicate
        for aNode in fromData {
            guard
                let productId = aNode["productId"] as? String
                else {
                    continue
            }
            predicate = NSPredicate(format: "%K == %@", Mobile.Keys.productId.rawValue, productId)
            let filteredData = existingData.filter {predicate.evaluate(with: $0)}
            var aMobile = filteredData.last
           
            if aMobile == nil {
                aMobile = Mobile(context: inContext)
                aMobile?.productId = productId
            }
            do {
                try aMobile?.updateMobile(withData: aNode)
                aMobile?.isDataDeleted = false
            } catch {
                debugPrint(error)
                aMobile?.isDataDeleted = true
            }
        }
        inContext.saveContext()
    }
    
    // parse data and populate a location
    func updateMobile(withData data:[String:Any]) throws {
        guard
            let title = data["title"] as? String,
            let subcategory = data["subcategory"] as? String,
            let price = data["price"] as? String,
            let popularity = data["popularity"] as? String
        else {
            throw NSError(domain: "Mobile Data parsing", code: 0, userInfo: nil)
        }

        self.title = title
        self.subcategory = subcategory
        self.price = Int64(price) ?? 0
        self.popularity = Int64(popularity) ?? 0
    }
}

//------------------------------------------- ManagedObjectProtocol

protocol ManagedObjectProtocol {}

extension ManagedObjectProtocol where Self: NSManagedObject {
    static var entityName: String {
        return entity().name ?? ""
    }
    
    static func findAll(in context: NSManagedObjectContext, with predicate: NSPredicate? = nil) -> [Self] {
        
        let request = fetchRequest()
        if let predicate = predicate {
            request.predicate = predicate
        }
        
        return results(in: context, from: request)
    }
    
    private static func results(in context: NSManagedObjectContext, from request: NSFetchRequest<NSFetchRequestResult>) -> [Self] {
        
        do {
            let results = try context.fetch(request) as? [Self]
            return results ?? []
        } catch {
            debugPrint("No objects found for: \(entityName)")
            return []
        }
    }
}
