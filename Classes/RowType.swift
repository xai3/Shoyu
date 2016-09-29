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
    func configureCell(_ tableView: UITableView, cell: UITableViewCell, indexPath: IndexPath)
    func heightFor(_ tableView: UITableView, indexPath: IndexPath) -> CGFloat?
    func canEdit(_ tableView: UITableView, indexPath: IndexPath) -> Bool
    func canRemove(_ tableView: UITableView, indexPath: IndexPath) -> Bool
    func canMove(_ tableView: UITableView, indexPath: IndexPath) -> Bool
    func canMoveTo(_ tableView: UITableView, sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) -> Bool
    func didSelect(_ tableView: UITableView, indexPath: IndexPath)
    func didDeselect(_ tableView: UITableView, indexPath: IndexPath)
    func willDisplayCell(_ tableView: UITableView, cell: UITableViewCell, indexPath: IndexPath)
    func didEndDisplayCell(_ tableView: UITableView, cell: UITableViewCell, indexPath: IndexPath)
    func willRemove(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewRowAnimation
    func didRemove(_ tableView: UITableView, indexPath: IndexPath)
}
