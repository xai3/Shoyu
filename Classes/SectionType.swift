//
//  SectionType.swift
//  Shoyu
//
//  Created by asai.yuki on 2015/12/17.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

public protocol SectionType {
    var rows: [RowType] { get }
    
    var header: SectionHeaderFooterType? { get }
    var footer: SectionHeaderFooterType? { get }
    
    var rowCount: Int { get }
    func rowFor(_ row: Int) -> RowType
    func rowFor(_ indexPath: IndexPath) -> RowType
    
    @discardableResult func removeRow(_ index: Int) -> RowType
    func insertRow(_ row: RowType, index: Int)
}
