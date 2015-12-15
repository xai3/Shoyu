//
//  Section.swift
//  Shoyu
//
//  Created by asai.yuki on 2015/12/12.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

public protocol SectionType {
    var rows: [RowType] { get }
    var header: SectionHeaderFooterType? { get }
    var footer: SectionHeaderFooterType? { get }
    
    var rowCount: Int { get }
    func rowFor(row: Int) -> RowType
    func rowFor(indexPath: NSIndexPath) -> RowType
}

public class Section<HeaderType: UIView, FooterType: UIView>: SectionType {
    public var rows: [RowType] = []
    public var header: SectionHeaderFooterType?
    public var footer: SectionHeaderFooterType?
    
    public var rowCount: Int { return rows.count }
    
    public init() { }
    
    public init(@noescape clousure: (Section<HeaderType, FooterType> -> Void)) {
        clousure(self)
    }
}

extension Section {
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
    
    public func createRow<T>(@noescape clousure: (Row<T> -> Void)) -> Self {
        return addRow(Row<T>() { clousure($0) })
    }
    
    public func createRows<T, E>(elements: [E], @noescape clousure: ((E, Row<T>) -> Void)) -> Self {
        return addRows(
            elements.map { element -> Row<T> in
                return Row<T>() { clousure(element, $0) }
                }.map { $0 as RowType }
        )
    }
    
    public func createRows<T>(count: UInt, @noescape clousure: ((UInt, Row<T>) -> Void)) -> Self {
        return createRows([UInt](0..<count), clousure: clousure)
    }
    
    public func createHeader(@noescape clousure: (SectionHeaderFooter<HeaderType> -> Void)) -> Self {
        return createHaederFooter { (header: SectionHeaderFooter<HeaderType>) in
            self.header = header
            clousure(header)
        }
    }
    
    public func createFooter(@noescape clousure: (SectionHeaderFooter<FooterType> -> Void)) -> Self {
        return createHaederFooter { (footer: SectionHeaderFooter<FooterType>) in
            self.footer = footer
            clousure(footer)
        }
    }
    
    private func createHaederFooter<T>(@noescape clousure:(SectionHeaderFooter<T> -> Void)) -> Self {
        clousure(SectionHeaderFooter<T>())
        return self
    }
}
