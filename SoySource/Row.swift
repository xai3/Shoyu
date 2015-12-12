//
//  Row.swift
//  SoySource
//
//  Created by asai.yuki on 2015/12/12.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

protocol RowType {
    var cellIdentifier: String { get }
    var height: CGFloat { get }
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath)
    func heightFor(indexPath: NSIndexPath) -> CGFloat?
    func didSelect(indexPath: NSIndexPath)
}

class Row<T: UITableViewCell>: RowType {
    init() { }
    
    init(@noescape clousure: (Row<T> -> Void)) {
        clousure(self)
    }
    
    var configureCell: ((T, NSIndexPath) -> Void)?
    var configureHeight: (NSIndexPath -> CGFloat?)?
    var didSelect: (NSIndexPath -> Void)?
    
    var cellIdentifier: String {
        // TODO: Imp
        return "Cell"
    }
    
    var height: CGFloat = 0
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        guard let genericCell = cell as? T else {
            fatalError()
        }
        configureCell?(genericCell, indexPath)
    }
    
    func heightFor(indexPath: NSIndexPath) -> CGFloat? {
        return configureHeight?(indexPath)
    }
    
    func didSelect(indexPath: NSIndexPath) {
        didSelect?(indexPath)
    }
}
