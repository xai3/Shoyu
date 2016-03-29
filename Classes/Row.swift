//
//  Row.swift
//  Shoyu
//
//  Created by asai.yuki on 2015/12/12.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

public class Row<T: UITableViewCell>: RowType {
    public typealias RowInformation = (row: Row<T>, tableView: UITableView, indexPath: NSIndexPath)
    public typealias RowMoveInformation = (row: Row<T>, tableView: UITableView, sourceIndexPath: NSIndexPath, destinationIndexPath: NSIndexPath)
    
    public init() { }
    
    public init(@noescape closure: (Row<T> -> Void)) {
        closure(self)
    }
    
    public var configureCell: ((T, RowInformation) -> Void)?
    public var heightFor: (RowInformation -> CGFloat?)?
    public var canRemove: (RowInformation -> Bool)?
    public var canMove: (RowInformation -> Bool)?
    public var canMoveTo: (RowMoveInformation -> Bool)?
    public var didSelect: (RowInformation -> Void)?
    public var didDeselect: (RowInformation -> Void)?
    public var willDisplayCell: ((T, RowInformation) -> Void)?
    public var didEndDisplayCell: ((T, RowInformation) -> Void)?
    public var willRemove: (RowInformation -> UITableViewRowAnimation?)?
    public var didRemove: (RowInformation -> Void)?
    
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
        configureCell?(genericCell, (self, tableView, indexPath))
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
        willDisplayCell?(genericCell, (self, tableView, indexPath))
    }
    
    func didEndDisplayCell(tableView: UITableView, cell: UITableViewCell, indexPath: NSIndexPath) {
        guard let genericCell = cell as? T else {
            fatalError()
        }
        didEndDisplayCell?(genericCell, (self, tableView, indexPath))
    }
    
    func willRemove(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewRowAnimation {
        return willRemove?((self, tableView, indexPath)) ?? .Fade
    }
    
    func didRemove(tableView: UITableView, indexPath: NSIndexPath) {
        didRemove?((self, tableView, indexPath))
    }
}
