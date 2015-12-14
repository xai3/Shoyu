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
    
    func configureHeader(view: UIView, section: Int)
    func configureFooter(view: UIView, section: Int)
    func heightForHeader(section: Int) -> CGFloat?
    func heightForFooter(section: Int) -> CGFloat?
}

typealias PlainSection = Section<UIView, UIView>

class Section<HeaderType: UIView, FooterType: UIView> {
    var rows: [RowType] = []
    var header: SectionHeaderFooterType?
    var footer: SectionHeaderFooterType?
    
    // MARK: Configurer
    var configureHeader: ((HeaderType, Int) -> Void)?
    var configureFooter: ((FooterType, Int) -> Void)?
    var configureHeaderHeight: (Int -> CGFloat?)?
    var configureFooterHeight: (Int -> CGFloat?)?
    
    init() { }
    
    init(@noescape clousure: (Section<HeaderType, FooterType> -> Void)) {
        clousure(self)
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
        }
    }
    
    func createFooter(@noescape clousure: (SectionHeaderFooter<FooterType> -> Void)) -> Self {
        return createHaederFooter { (footer: SectionHeaderFooter<FooterType>) in
            self.footer = footer
        }
    }
    
    private func createHaederFooter<T>(@noescape clousure:(SectionHeaderFooter<T> -> Void)) -> Self {
        clousure(SectionHeaderFooter<T>())
        return self
    }
}

extension Section: SectionType {
 
    func configureHeader(view: UIView, section: Int) {
        guard let headerView = view as? HeaderType else {
            fatalError()
        }
        configureHeader?(headerView, section)
    }
    
    func configureFooter(view: UIView, section: Int) {
        guard let footerView = view as? FooterType else {
            fatalError()
        }
        configureFooter?(footerView, section)
    }
    
    func heightForHeader(section: Int) -> CGFloat? {
        return configureHeaderHeight?(section) ?? header?.height
    }
    
    func heightForFooter(section: Int) -> CGFloat? {
        return configureFooterHeight?(section) ?? footer?.height
    }
}

protocol SectionHeaderFooterType {
    var identifier: String { get }
    var height: CGFloat? { get set }
    var title: String? { get set }
}

class SectionHeaderFooter<Type: UIView>: SectionHeaderFooterType {
    init() { }
    
    init(@noescape clousure: (SectionHeaderFooter<Type> -> Void)) {
        clousure(self)
    }
    
    var identifier: String {
        // TODO: Imp
        return "Header"
    }
    
    var height: CGFloat?
    var title: String?
}
