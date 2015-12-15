//
//  Section.swift
//  SoySource
//
//  Created by asai.yuki on 2015/12/12.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

protocol SectionType {
    var rows: [RowType] { get }
    var header: SectionHeaderFooterType? { get }
    var footer: SectionHeaderFooterType? { get }
    
    var rowCount: Int { get }
    func rowFor(row: Int) -> RowType
    func rowFor(indexPath: NSIndexPath) -> RowType
}

typealias PlainSection = Section<UIView, UIView>

class Section<HeaderType: UIView, FooterType: UIView>: SectionType {
    var rows: [RowType] = []
    var header: SectionHeaderFooterType?
    var footer: SectionHeaderFooterType?
    
    var rowCount: Int { return rows.count }
    
    init() { }
    
    init(@noescape clousure: (Section<HeaderType, FooterType> -> Void)) {
        clousure(self)
    }
}

extension Section {
    func rowFor(row: Int) -> RowType {
        return rows[row]
    }
    
    func rowFor(indexPath: NSIndexPath) -> RowType {
        return rowFor(indexPath.row)
    }
}

extension Section {
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
    
    func createHeader(@noescape clousure: (SectionHeaderFooter<HeaderType> -> Void)) -> Self {
        return createHaederFooter { (header: SectionHeaderFooter<HeaderType>) in
            self.header = header
            clousure(header)
        }
    }
    
    func createFooter(@noescape clousure: (SectionHeaderFooter<FooterType> -> Void)) -> Self {
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
