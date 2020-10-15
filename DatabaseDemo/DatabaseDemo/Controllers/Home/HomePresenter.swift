//
//  HomePresenter.swift
//  DatabaseDemo
//
//  Created by Suman on 29/04/20.
//  Copyright © 2020 Suman. All rights reserved.
//

import Foundation
import CoreData
class HomePresenter {
    private var provider: HomeProvider?
    weak var delegate: HomeDelegate?
    lazy var fetchedResultsController: NSFetchedResultsController<Mobile> = {
        let fetchRequest = NSFetchRequest<Mobile>(entityName: Mobile.entityName)
        
        let mainPredicate = NSPredicate(format: "%K != %@", Mobile.Keys.isDataDeleted.rawValue, NSNumber(value: true))
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [mainPredicate])
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Mobile.Keys.productId.rawValue, ascending: true)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: AppDelegate.shared.persistentContainer.viewContext,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = delegate
        
        do {
            try controller.performFetch()
        } catch {
            let nserror = error as NSError
            debugPrint("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return controller
    }()
    
    init(provider: HomeProvider, delegate: HomeDelegate) {
        self.provider = provider
        self.delegate = delegate
    }
    
    func fetchMobileData() {
        provider?.fetchNewData(completion: { [weak self] error in
            guard let strongSelf = self else { return }
            guard error == nil else {
                strongSelf.delegate?.finishWithError(error?.localizedDescription)
                return
            }
        })
    }
    
    // Searching
    func filterMobileDataForSearchText(searchText: String?) {
        guard let text = searchText, !text.isEmpty else {
            return
        }
        
        let mainPredicate = NSPredicate(format: "%K != %@", Mobile.Keys.isDataDeleted.rawValue, NSNumber(value: true))
        var predicates: [NSPredicate] = [mainPredicate]
        
        if text.lowercased().contains("and") {
            var keywords: [String] = []

            for keyword in text.components(separatedBy: "and") {
                keywords.append(keyword.trim)
            }
            
            let andPredicate = NSPredicate(format: "%K IN %@", Mobile.Keys.title.rawValue, keywords)
            predicates.append(andPredicate)
        }
        
        if text.lowercased().contains("below") {
            let price = Int64(text.lowercased().replacingOccurrences(of: "below", with: "").trim) ?? 0
            let lowPricePredicate = NSPredicate(format: "(%K <= %d)", Mobile.Keys.price.rawValue, price)
            predicates.append(lowPricePredicate)
        }
        
        if text.lowercased().contains("above") {
            let price = Int64(text.lowercased().replacingOccurrences(of: "above", with: "").trim) ?? 0
            let lowPricePredicate = NSPredicate(format: "(%K >= %d)", Mobile.Keys.price.rawValue, price)
            predicates.append(lowPricePredicate)
        }
        
        if predicates.count == 1 { // just the main predicate
            let titlePredicate = NSPredicate(format: "(%K CONTAINS[c] %@)", Mobile.Keys.title.rawValue, text.trim)
            predicates.append(titlePredicate)
        }
        
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        self.fetchedResultsController.fetchRequest.predicate = compoundPredicate
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let nserror = error as NSError
            debugPrint("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
//    func filterMobileDataForSearchTextAll(searchText: String?) {
//        guard let text = searchText, !text.isEmpty else {
//            return
//        }
//        let searchPredicate = NSPredicate(format:"(title CONTAINS[c] %@)", text)
//
//        let mainPredicate = NSPredicate(format: "%K != %@", Mobile.Keys.isDataDeleted.rawValue, NSNumber(value: true))
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [mainPredicate, searchPredicate])
//        self.fetchedResultsController.fetchRequest.predicate = compoundPredicate
//        do {
//            try self.fetchedResultsController.performFetch()
//        } catch {
//            let nserror = error as NSError
//            debugPrint("Unresolved error \(nserror), \(nserror.userInfo)")
//        }
//    }
    
    func cancelFilteringMobileData() {
        let mainPredicate = NSPredicate(format: "%K != %@", Mobile.Keys.isDataDeleted.rawValue, NSNumber(value: true))
        self.fetchedResultsController.fetchRequest.predicate = mainPredicate
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let nserror = error as NSError
            debugPrint("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
