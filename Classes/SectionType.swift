//
//  SectionType.swift
//  Shoyu
//
//  Created by asai.yuki on 2015/12/17.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

public protocol SectionType {
    var header: SectionHeaderFooterType? { get }
    var footer: SectionHeaderFooterType? { get }
    
    var rowCount: Int { get }
    func rowFor(row: Int) -> RowType
    func rowFor(indexPath: NSIndexPath) -> RowType
}

extension SectionType {
    var rows: [RowType] { return [] }
}
