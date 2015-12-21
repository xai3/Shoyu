//
//  Section.swift
//  Shoyu
//
//  Created by asai.yuki on 2015/12/12.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

public class Section<HeaderType: UIView, FooterType: UIView>: SectionType {
    var rows: [RowType] = []
    
    public var header: SectionHeaderFooterType?
    public var footer: SectionHeaderFooterType?
    
    public init() { }
    
    public init(@noescape closure: (Section<HeaderType, FooterType> -> Void)) {
        closure(self)
    }
}

extension Section {
    public var rowCount: Int { return rows.count }
    
    public func rowFor(row: Int) -> RowType {
        return rows[row]
    }
    
    public func rowFor(indexPath: NSIndexPath) -> RowType {
        return rowFor(indexPath.row)
    }
}

extension Section {
    public func addRow(row: RowType) -> Self {
        rows.append(row)
        return self
    }
    
    public func addRows(rows: [RowType]) -> Self {
        self.rows.appendContentsOf(rows)
        return self
    }
    
    public func createRow<T>(@noescape closure: (Row<T> -> Void)) -> Self {
        return addRow(Row<T>() { closure($0) })
    }
    
    public func createRows<T, E>(elements: [E], @noescape closure: ((E, Row<T>) -> Void)) -> Self {
        return addRows(
            elements.map { element -> Row<T> in
                return Row<T>() { closure(element, $0) }
                }.map { $0 as RowType }
        )
    }
    
    public func createRows<T>(count: UInt, @noescape closure: ((UInt, Row<T>) -> Void)) -> Self {
        return createRows([UInt](0..<count), closure: closure)
    }
    
    public func createHeader(@noescape closure: (SectionHeaderFooter<HeaderType> -> Void)) -> Self {
        return createHaederFooter { (header: SectionHeaderFooter<HeaderType>) in
            self.header = header
            closure(header)
        }
    }
    
    public func createFooter(@noescape closure: (SectionHeaderFooter<FooterType> -> Void)) -> Self {
        return createHaederFooter { (footer: SectionHeaderFooter<FooterType>) in
            self.footer = footer
            closure(footer)
        }
    }
    
    private func createHaederFooter<T>(@noescape closure:(SectionHeaderFooter<T> -> Void)) -> Self {
        closure(SectionHeaderFooter<T>())
        return self
    }
}
