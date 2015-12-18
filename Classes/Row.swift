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
}
