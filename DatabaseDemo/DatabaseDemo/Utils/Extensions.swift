//
//  Extensions.swift
//  DatabaseDemo
//
//  Created by Suman on 29/04/20.
//  Copyright © 2020 Suman. All rights reserved.
//

import UIKit
import CoreData

extension String {
    public var trim : String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
}

extension NSManagedObjectContext {
    public func saveData() -> Bool {
        do {
            try save()
            return true
        } catch let error {
            debugPrint("----->> Error: \(error)")
            return false
        }
    }
    
    func saveContext() {
        _ = saveData()
    }
}

public protocol ReusableView: class {
    static var reuseIdentity: String { get }
}

extension ReusableView where Self: UIView {
    public static var reuseIdentity: String {
        return "\(self)"
    }
}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(_: T.Type) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentity) as? T else {
            debugPrint("Could not dequeue cell with identifier: \(T.reuseIdentity)")
            return UITableViewCell() as! T
        }
        return cell
    }
    
    func dequeueReusableView<T: UITableViewHeaderFooterView>(_: T.Type) -> T where T: ReusableView {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentity) as? T else {
            debugPrint("Could not dequeue cell with identifier: \(T.reuseIdentity)")
            return UIView() as! T
        }
        return view
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_: T.Type, for indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentity, for: indexPath) as? T else {
            debugPrint("Could not dequeue cell with identifier: \(T.reuseIdentity)")
            return UITableViewCell() as! T
        }
        
        return cell
    }
}
