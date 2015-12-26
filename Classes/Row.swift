//
//  Row.swift
//  Shoyu
//
//  Created by asai.yuki on 2015/12/12.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

public class Row<T: UITableViewCell>: RowType {
    public typealias RowEventType = (row: Row<T>, tableView: UITableView, indexPath: NSIndexPath)
    public typealias RowCellEventType = (row: Row<T>, tableView: UITableView, cell: T, indexPath: NSIndexPath)
    public typealias RowMoveToEventType = (row: Row<T>, tableView: UITableView, sourceIndexPath: NSIndexPath, destinationIndexPath: NSIndexPath)
    
    init() { }
    
    init(@noescape closure: (Row<T> -> Void)) {
        closure(self)
    }
    
    public var configureCell: (RowCellEventType -> Void)?
    public var heightFor: (RowEventType -> CGFloat?)?
    public var canRemove: (RowEventType -> Bool?)?
    public var canMove: (RowEventType -> Bool?)?
    public var canMoveTo: (RowMoveToEventType -> Bool?)?
    public var didSelect: (RowEventType -> Void)?
    public var didDeselect: (RowEventType -> Void)?
    public var willDisplayCell: (RowCellEventType -> Void)?
    public var didEndDisplayCell: (RowCellEventType -> Void)?
    public var willRemove: (RowEventType -> UITableViewRowAnimation?)?
    public var didRemove: (RowEventType -> Void)?
    
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
    func configureCell(tableView: UITableView, cell: UITableViewCell, indexPath: NSIndexPath) {
        guard let genericCell = cell as? T else {
            fatalError()
        }
        configureCell?((self, tableView, genericCell, indexPath))
    }
    
    func heightFor(tableView: UITableView, indexPath: NSIndexPath) -> CGFloat? {
        return heightFor?((self, tableView, indexPath)) ?? height
    }
    
    func canEdit(tableView: UITableView, indexPath: NSIndexPath) -> Bool {
        return canRemove(tableView, indexPath: indexPath) || canMove(tableView, indexPath: indexPath)
    }
    
    func canRemove(tableView: UITableView, indexPath: NSIndexPath) -> Bool {
        return canRemove?((self, tableView, indexPath)) ?? false
    }
    
    func canMove(tableView: UITableView, indexPath: NSIndexPath) -> Bool {
        return canMove?((self, tableView, indexPath)) ?? false
    }
    
    func canMoveTo(tableView: UITableView, sourceIndexPath: NSIndexPath, destinationIndexPath: NSIndexPath) -> Bool {
        return canMoveTo?((self, tableView, sourceIndexPath, destinationIndexPath)) ?? false
    }
    
    func didSelect(tableView: UITableView, indexPath: NSIndexPath) {
        didSelect?((self, tableView, indexPath))
    }
    
    func didDeselect(tableView: UITableView, indexPath: NSIndexPath) {
        didDeselect?((self, tableView, indexPath))
    }
    
    func willDisplayCell(tableView: UITableView, cell: UITableViewCell, indexPath: NSIndexPath) {
        guard let genericCell = cell as? T else {
            fatalError()
        }
        willDisplayCell?((self, tableView, genericCell, indexPath))
    }
    
    func didEndDisplayCell(tableView: UITableView, cell: UITableViewCell, indexPath: NSIndexPath) {
        guard let genericCell = cell as? T else {
            fatalError()
        }
        didEndDisplayCell?((self, tableView, genericCell, indexPath))
    }
    
    func willRemove(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewRowAnimation {
        return willRemove?((self, tableView, indexPath)) ?? .Fade
    }
    
    func didRemove(tableView: UITableView, indexPath: NSIndexPath) {
        didRemove?((self, tableView, indexPath))
    }
}
