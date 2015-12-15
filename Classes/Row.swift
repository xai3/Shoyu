//
//  Row.swift
//  Shoyu
//
//  Created by asai.yuki on 2015/12/12.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

public protocol RowType {
    var reuseIdentifier: String { get set }
    var height: CGFloat? { get }
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath)
    func heightFor(indexPath: NSIndexPath) -> CGFloat?
    func didSelect(indexPath: NSIndexPath)
    func didDeselect(indexPath: NSIndexPath)
    func willDisplayCell(cell: UITableViewCell, indexPath: NSIndexPath)
    func didEndDisplayCell(cell: UITableViewCell, indexPath: NSIndexPath)
}

public class Row<T: UITableViewCell>: RowType {
    init() { }
    
    init(@noescape clousure: (Row<T> -> Void)) {
        clousure(self)
    }
    
    public var configureCell: ((T, NSIndexPath) -> Void)?
    public var heightFor: (NSIndexPath -> CGFloat?)?
    public var didSelect: (NSIndexPath -> Void)?
    public var didDeselect: (NSIndexPath -> Void)?
    public var willDisplayCell: ((T, NSIndexPath) -> Void)?
    public var didEndDisplayCell: ((T, NSIndexPath) -> Void)?
    
    private var _reuseIdentifier: String?
    public var reuseIdentifier: String {
        set {
            _reuseIdentifier = newValue
        }
        get {
            if let identifier = _reuseIdentifier {
                return identifier
            }
            if let identifier = T() as? ReuseIdentifierType {
                return identifier.identifier
            }
            fatalError()
        }
    }
    
    public var height: CGFloat?
}

extension Row {
    public func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        guard let genericCell = cell as? T else {
            fatalError()
        }
        configureCell?(genericCell, indexPath)
    }
    
    public func heightFor(indexPath: NSIndexPath) -> CGFloat? {
        return heightFor?(indexPath) ?? height
    }
    
    public func didSelect(indexPath: NSIndexPath) {
        didSelect?(indexPath)
    }
    
    public func didDeselect(indexPath: NSIndexPath) {
        didDeselect?(indexPath)
    }
    
    public func willDisplayCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        guard let genericCell = cell as? T else {
            fatalError()
        }
        willDisplayCell?(genericCell, indexPath)
    }
    
    public func didEndDisplayCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        guard let genericCell = cell as? T else {
            fatalError()
        }
        didEndDisplayCell?(genericCell, indexPath)
    }
}
