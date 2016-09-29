//
//  Section.swift
//  Shoyu
//
//  Created by asai.yuki on 2015/12/12.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

open class Section<HeaderType: UIView, FooterType: UIView>: SectionType {
    open fileprivate(set) var rows: [RowType] = []
    
    open var header: SectionHeaderFooterType?
    open var footer: SectionHeaderFooterType?
    
    public init() { }
    
    public init(closure: ((Section<HeaderType, FooterType>) -> Void)) {
        closure(self)
    }
}

extension Section {
    public var rowCount: Int { return rows.count }
    
    public func rowFor(_ row: Int) -> RowType {
        return rows[row]
    }
    
    public func rowFor(_ indexPath: IndexPath) -> RowType {
        return rowFor((indexPath as NSIndexPath).row)
    }
    
    @discardableResult public func removeRow(_ index: Int) -> RowType {
        return rows.remove(at: index)
    }
    
    public func insertRow(_ row: RowType, index: Int) {
        rows.insert(row, at: index)
    }
}

extension Section {
    @discardableResult public func add(row: RowType) -> Self {
        rows.append(row)
        return self
    }
    
    @discardableResult public func add(rows: [RowType]) -> Self {
        self.rows.append(contentsOf: rows)
        return self
    }
    
    @discardableResult public func createRow<T>(_ closure: ((Row<T>) -> Void)) -> Self {
        return add(row: Row<T>() { closure($0) })
    }
    
    @discardableResult public func createRows<T, E>(for elements: [E], closure: ((E, Row<T>) -> Void)) -> Self {
        return add(rows:
            elements.map { element -> Row<T> in
                return Row<T>() { closure(element, $0) }
                }.map { $0 as RowType }
        )
    }
    
    @discardableResult public func createRows<T>(for count: UInt, closure: ((UInt, Row<T>) -> Void)) -> Self {
        return createRows(for: [UInt](0..<count), closure: closure)
    }
    
    @discardableResult public func createHeader(_ closure: ((SectionHeaderFooter<HeaderType>) -> Void)) -> Self {
        return createHeaderFooter { (header: SectionHeaderFooter<HeaderType>) in
            self.header = header
            closure(header)
        }
    }
    
    @discardableResult public func createFooter(_ closure: ((SectionHeaderFooter<FooterType>) -> Void)) -> Self {
        return createHeaderFooter { (footer: SectionHeaderFooter<FooterType>) in
            self.footer = footer
            closure(footer)
        }
    }
    
    @discardableResult fileprivate func createHeaderFooter<T>(_ closure: ((SectionHeaderFooter<T>) -> Void)) -> Self {
        closure(SectionHeaderFooter<T>())
        return self
    }
}
