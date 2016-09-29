//
//  Row.swift
//  Shoyu
//
//  Created by asai.yuki on 2015/12/12.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

open class Row<T: UITableViewCell>: RowType {
    public typealias RowInformation = (row: Row<T>, tableView: UITableView, indexPath: IndexPath)
    public typealias RowMoveInformation = (row: Row<T>, tableView: UITableView, sourceIndexPath: IndexPath, destinationIndexPath: IndexPath)
    
    public init() { }
    
    public init(closure: ((Row<T>) -> Void)) {
        closure(self)
    }
    
    open var configureCell: ((T, RowInformation) -> Void)?
    open var heightFor: ((RowInformation) -> CGFloat?)?
    open var canRemove: ((RowInformation) -> Bool)?
    open var canMove: ((RowInformation) -> Bool)?
    open var canMoveTo: ((RowMoveInformation) -> Bool)?
    open var didSelect: ((RowInformation) -> Void)?
    open var didDeselect: ((RowInformation) -> Void)?
    open var willDisplayCell: ((T, RowInformation) -> Void)?
    open var didEndDisplayCell: ((T, RowInformation) -> Void)?
    open var willRemove: ((RowInformation) -> UITableViewRowAnimation?)?
    open var didRemove: ((RowInformation) -> Void)?
    
    fileprivate var _reuseIdentifier: String?
    open var reuseIdentifier: String {
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
    
    open var height: CGFloat?
}

extension Row: RowDelegateType {
    func configureCell(_ tableView: UITableView, cell: UITableViewCell, indexPath: IndexPath) {
        guard let genericCell = cell as? T else {
            fatalError()
        }
        configureCell?(genericCell, (self, tableView, indexPath))
    }
    
    func heightFor(_ tableView: UITableView, indexPath: IndexPath) -> CGFloat? {
        return heightFor?((self, tableView, indexPath)) ?? height
    }
    
    func canEdit(_ tableView: UITableView, indexPath: IndexPath) -> Bool {
        return canRemove(tableView, indexPath: indexPath) || canMove(tableView, indexPath: indexPath)
    }
    
    func canRemove(_ tableView: UITableView, indexPath: IndexPath) -> Bool {
        return canRemove?((self, tableView, indexPath)) ?? false
    }
    
    func canMove(_ tableView: UITableView, indexPath: IndexPath) -> Bool {
        return canMove?((self, tableView, indexPath)) ?? false
    }
    
    func canMoveTo(_ tableView: UITableView, sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) -> Bool {
        return canMoveTo?((self, tableView, sourceIndexPath, destinationIndexPath)) ?? false
    }
    
    func didSelect(_ tableView: UITableView, indexPath: IndexPath) {
        didSelect?((self, tableView, indexPath))
    }
    
    func didDeselect(_ tableView: UITableView, indexPath: IndexPath) {
        didDeselect?((self, tableView, indexPath))
    }
    
    func willDisplayCell(_ tableView: UITableView, cell: UITableViewCell, indexPath: IndexPath) {
        guard let genericCell = cell as? T else {
            fatalError()
        }
        willDisplayCell?(genericCell, (self, tableView, indexPath))
    }
    
    func didEndDisplayCell(_ tableView: UITableView, cell: UITableViewCell, indexPath: IndexPath) {
        guard let genericCell = cell as? T else {
            return
        }
        didEndDisplayCell?(genericCell, (self, tableView, indexPath))
    }
    
    func willRemove(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewRowAnimation {
        return willRemove?((self, tableView, indexPath)) ?? .fade
    }
    
    func didRemove(_ tableView: UITableView, indexPath: IndexPath) {
        didRemove?((self, tableView, indexPath))
    }
}
