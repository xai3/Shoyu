//
//  Row.swift
//  Shoyu
//
//  Created by asai.yuki on 2015/12/12.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

public class Row<T: UITableViewCell>: RowType {
    init() { }
    
    init(@noescape closure: (Row<T> -> Void)) {
        closure(self)
    }
    
    public var configureCell: ((T, NSIndexPath) -> Void)?
    public var heightFor: (NSIndexPath -> CGFloat?)?
    public var canRemove: (NSIndexPath -> Bool?)?
    public var canMove: (NSIndexPath -> Bool?)?
    public var canMoveTo: ((NSIndexPath, NSIndexPath) -> Bool?)?
    public var didSelect: (NSIndexPath -> Void)?
    public var didDeselect: (NSIndexPath -> Void)?
    public var willDisplayCell: ((T, NSIndexPath) -> Void)?
    public var didEndDisplayCell: ((T, NSIndexPath) -> Void)?
    public var willRemove: (NSIndexPath -> UITableViewRowAnimation?)?
    public var didRemove: (NSIndexPath -> Void)?
    
    private var _reuseIdentifier: String?
    public var reuseIdentifier: String {
        set {
            _reuseIdentifier = newValue
        }
        get {
            if let identifier = _reuseIdentifier {
                return identifier
            }
            let identifier = T() as ReuseIdentifierType
            return identifier.identifier
        }
    }
    
    public var height: CGFloat?
}

extension Row: RowDelegateType {
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        guard let genericCell = cell as? T else {
            fatalError()
        }
        configureCell?(genericCell, indexPath)
    }
    
    func heightFor(indexPath: NSIndexPath) -> CGFloat? {
        return heightFor?(indexPath) ?? height
    }
    
    func canEdit(indexPath: NSIndexPath) -> Bool {
        return canRemove(indexPath) || canMove(indexPath)
    }
    
    func canRemove(indexPath: NSIndexPath) -> Bool {
        return canRemove?(indexPath) ?? false
    }
    
    func canMove(indexPath: NSIndexPath) -> Bool {
        return canMove?(indexPath) ?? false
    }
    
    func canMoveTo(indexPath: NSIndexPath, destinationIndexPath: NSIndexPath) -> Bool {
        return canMoveTo?(indexPath, destinationIndexPath) ?? false
    }
    
    func didSelect(indexPath: NSIndexPath) {
        didSelect?(indexPath)
    }
    
    func didDeselect(indexPath: NSIndexPath) {
        didDeselect?(indexPath)
    }
    
    func willDisplayCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        guard let genericCell = cell as? T else {
            fatalError()
        }
        willDisplayCell?(genericCell, indexPath)
    }
    
    func didEndDisplayCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        guard let genericCell = cell as? T else {
            fatalError()
        }
        didEndDisplayCell?(genericCell, indexPath)
    }
    
    func willRemove(indexPath: NSIndexPath) -> UITableViewRowAnimation {
        return willRemove?(indexPath) ?? .Fade
    }
    
    func didRemove(indexPath: NSIndexPath) {
        didRemove?(indexPath)
    }
}
