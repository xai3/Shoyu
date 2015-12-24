//
//  SectionTest.swift
//  Shoyu
//
//  Created by Asai.Yuki on 2015/12/14.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import XCTest
@testable import Shoyu

class SectionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAddSingleRow() {
        let section = Section().addRow(Row())
        XCTAssertEqual(section.rows.count, 1)
    }
    
    func testAddMultiRow() {
        let section = Section()
        section.addRow(Row())
        section.addRow(Row())
        XCTAssertEqual(section.rows.count, 2)
        
        // Method chain
        section.addRow(Row()).addRow(Row()).addRow(Row())
        XCTAssertEqual(section.rows.count, 5)
    }
    
    func testAddRows() {
        let section = Section()
        section.addRows([Row(), Row()])
        XCTAssertEqual(section.rows.count, 2)
        
        // Method chain
        section.addRows([Row(), Row(), Row()])
        XCTAssertEqual(section.rows.count, 5)
    }
    
    func testCreateSingleRow() {
        let section = Section() { section in
            section.createRow { _ in }
        }
        XCTAssertEqual(section.rows.count, 1)
    }
    
    func testCreateMultiRow() {
        let section = Section() { section in
            section.createRow { _ in }
            section.createRow { _ in }
        }
        XCTAssertEqual(section.rows.count, 2)
    }
    
    func testCreateCountRows() {
        let count = UInt(10)
        let section = Section() { section in
            section.createRows(count) { _ in }
        }
        XCTAssertEqual(section.rows.count, Int(count))
    }
    
    func testCreateMapArrayRows() {
        let items = [1, 2, 3]
        let section = Section() { section in
            section.createRows(items) { _ in }
        }
        XCTAssertEqual(section.rows.count, items.count)
    }
    
    func testCreateHeader() {
        let section = Section() { section in
            section.createHeader { _ in }
        }
        XCTAssertNotNil(section.header)
    }
    
    func testCreateFooter() {
        let section = Section() { section in
            section.createFooter { _ in }
        }
        XCTAssertNotNil(section.footer)
    }
    
    func testCreateHeaderFooter() {
        let section = Section() { section in
            section.createHeader { _ in }
            section.createFooter { _ in }
        }
        XCTAssertNotNil(section.header)
        XCTAssertNotNil(section.footer)
    }
    
    func testCreateRowsAndHeaderFooter() {
        let count = UInt(2)
        let items = [1, 2, 3]
        let section = Section() { section in
            section.createRow { _ in }
            section.createRows(count) { _ in }
            section.createRows(items) { _ in }
            section.createHeader { _ in }
            section.createFooter { _ in }
        }
        XCTAssertEqual(section.rows.count, 1 + Int(count) + items.count)
        XCTAssertNotNil(section.header)
        XCTAssertNotNil(section.footer)
    }
    
    func testConfigureHeaderFooterHeight() {
        let section = Section()
        
        // Initialized
        XCTAssertEqual((section.header as? SectionHeaderFooterDelegateType)?.heightFor(UITableView(), section: 0), nil)
        XCTAssertEqual((section.footer as? SectionHeaderFooterDelegateType)?.heightFor(UITableView(), section: 0), nil)
        
        // Constant
        section.createHeader { header in
            header.height = 10
        }
        section.createFooter { footer in
            footer.height = 11
        }
        XCTAssertEqual((section.header as? SectionHeaderFooterDelegateType)?.heightFor(UITableView(), section: 0), 10)
        XCTAssertEqual((section.footer as? SectionHeaderFooterDelegateType)?.heightFor(UITableView(), section: 0), 11)
        
        // Configure height
        section.createHeader { header in
            header.heightFor = { _ -> CGFloat? in
                return 20
            }
        }
        section.createFooter { footer in
            footer.heightFor = { _ -> CGFloat? in
                return 21
            }
        }
        XCTAssertEqual((section.header as? SectionHeaderFooterDelegateType)?.heightFor(UITableView(), section: 0), 20)
        XCTAssertEqual((section.footer as? SectionHeaderFooterDelegateType)?.heightFor(UITableView(), section: 0), 21)
        
        // Configure nil height
        section.createHeader { header in
            header.height = 30
            header.heightFor = { _ -> CGFloat? in
                return nil
            }
        }
        section.createFooter { footer in
            footer.height = 31
            footer.heightFor = { _ -> CGFloat? in
                return nil
            }
        }
        XCTAssertEqual((section.header as? SectionHeaderFooterDelegateType)?.heightFor(UITableView(), section: 0), 30)
        XCTAssertEqual((section.footer as? SectionHeaderFooterDelegateType)?.heightFor(UITableView(), section: 0), 31)
    }
    
    func testConfigureHeaderFooterTitle() {
        let section = Section()
        
        let constantHeaderTitle = "header title"
        let constantFooterTitle = "footer title"
        let variableHeaderTitle = "header title for"
        let variableFooterTitle = "footer title for"
        
        // Initialized
        XCTAssertEqual((section.header as? SectionHeaderFooterDelegateType)?.titleFor(UITableView(), section: 0), nil)
        XCTAssertEqual((section.footer as? SectionHeaderFooterDelegateType)?.titleFor(UITableView(), section: 0), nil)
        
        // Constant
        section.createHeader { header in
            header.title = constantHeaderTitle
        }
        section.createFooter { footer in
            footer.title = constantFooterTitle
        }
        XCTAssertEqual((section.header as? SectionHeaderFooterDelegateType)?.titleFor(UITableView(), section: 0), constantHeaderTitle)
        XCTAssertEqual((section.footer as? SectionHeaderFooterDelegateType)?.titleFor(UITableView(), section: 0), constantFooterTitle)
        
        // Title for
        section.createHeader { header in
            header.titleFor = { _ -> String? in
                return variableHeaderTitle
            }
        }
        section.createFooter { footer in
            footer.titleFor = { _ -> String? in
                return variableFooterTitle
            }
        }
        XCTAssertEqual((section.header as? SectionHeaderFooterDelegateType)?.titleFor(UITableView(), section: 0), variableHeaderTitle)
        XCTAssertEqual((section.footer as? SectionHeaderFooterDelegateType)?.titleFor(UITableView(), section: 0), variableFooterTitle)
        
        // Both
        section.createHeader { header in
            header.title = constantHeaderTitle
            header.titleFor = { _ -> String? in
                return variableHeaderTitle
            }
        }
        section.createFooter { footer in
            footer.title = constantFooterTitle
            footer.titleFor = { _ -> String? in
                return variableFooterTitle
            }
        }
        XCTAssertEqual((section.header as? SectionHeaderFooterDelegateType)?.titleFor(UITableView(), section: 0), variableHeaderTitle)
        XCTAssertEqual((section.footer as? SectionHeaderFooterDelegateType)?.titleFor(UITableView(), section: 0), variableFooterTitle)
        
        // Title for nil
        section.createHeader { header in
            header.title = constantHeaderTitle
            header.titleFor = { _ -> String? in
                return nil
            }
        }
        section.createFooter { footer in
            footer.title = constantFooterTitle
            footer.titleFor = { _ -> String? in
                return nil
            }
        }
        XCTAssertEqual((section.header as? SectionHeaderFooterDelegateType)?.titleFor(UITableView(), section: 0), constantHeaderTitle)
        XCTAssertEqual((section.footer as? SectionHeaderFooterDelegateType)?.titleFor(UITableView(), section: 0), constantFooterTitle)
    }
    
}

