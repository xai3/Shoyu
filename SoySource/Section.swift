//
//  Section.swift
//  SoySource
//
//  Created by asai.yuki on 2015/12/12.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

class Section {
    internal var rows = [RowType]()
    
    init() { }
    
    init(@noescape clousure: (Section -> Void)) {
        clousure(self)
    }
    
    func addRow(row: RowType) -> Self {
        rows.append(row)
        return self
    }
    
    func addRows(rows: [RowType]) -> Self {
        self.rows.appendContentsOf(rows)
        return self
    }
    
    func createRow<T>(@noescape clousure: (Row<T> -> Void)) -> Self {
        return addRow(Row<T>() { clousure($0) })
    }
    
    func createRows<T, E>(elements: [E], @noescape clousure: ((E, Row<T>) -> Void)) -> Self {
        return addRows(
            elements.map { element -> Row<T> in
                return Row<T>() { clousure(element, $0) }
                }.map { $0 as RowType }
        )
    }
    
    func createRows<T>(count: UInt, @noescape clousure: ((UInt, Row<T>) -> Void)) -> Self {
        return createRows([UInt](0..<count), clousure: clousure)
    }
}
