//
//  RowType.swift
//  Shoyu
//
//  Created by asai.yuki on 2015/12/17.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

public protocol RowType {
    var reuseIdentifier: String { get set }
    var height: CGFloat? { get }
}

protocol RowDelegateType {
    func configureCell(tableView: UITableView, cell: UITableViewCell, indexPath: NSIndexPath)
    func heightFor(tableView: UITableView, indexPath: NSIndexPath) -> CGFloat?
    func canEdit(indexPath: NSIndexPath) -> Bool
    func canRemove(indexPath: NSIndexPath) -> Bool
    func canMove(indexPath: NSIndexPath) -> Bool
    func canMoveTo(indexPath: NSIndexPath, destinationIndexPath: NSIndexPath) -> Bool
    func didSelect(tableView: UITableView, indexPath: NSIndexPath)
    func didDeselect(tableView: UITableView, indexPath: NSIndexPath)
    func willDisplayCell(tableView: UITableView, cell: UITableViewCell, indexPath: NSIndexPath)
    func didEndDisplayCell(tableView: UITableView, cell: UITableViewCell, indexPath: NSIndexPath)
    func willRemove(indexPath: NSIndexPath) -> UITableViewRowAnimation
    func didRemove(indexPath: NSIndexPath)
}
