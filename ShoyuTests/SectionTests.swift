//
//  SectionTest.swift
//  Shoyu
//
//  Created by Asai.Yuki on 2015/12/14.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import XCTest

class SectionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAddSingleRow() {
        let section = Section().add(row: Row())
        XCTAssertEqual(section.rows.count, 1)
    }
    
    func testAddMultiRow() {
        let section = Section()
        _ = section.add(row: Row()).add(row: Row())
        XCTAssertEqual(section.rows.count, 2)
        
        // Method chain
        _ = section.add(row: Row()).add(row: Row()).add(row: Row())
        XCTAssertEqual(section.rows.count, 5)
    }
    
    func testAddRows() {
        let section = Section()
        _ = section.add(rows: [Row(), Row()])
        XCTAssertEqual(section.rows.count, 2)
        
        // Method chain
        _ = section.add(rows: [Row(), Row(), Row()])
        XCTAssertEqual(section.rows.count, 5)
    }
    
    func testCreateSingleRow() {
        let section = Section() { section in
            _ = section.createRow { _ in }
        }
        XCTAssertEqual(section.rows.count, 1)
    }
    
    func testCreateMultiRow() {
        let section = Section() { section in
            _ = section.createRow { _ in }
            _ = section.createRow { _ in }
        }
        XCTAssertEqual(section.rows.count, 2)
    }
    
    func testCreateCountRows() {
        let count = UInt(10)
        let section = Section() { section in
            _ = section.createRows(for: count) { _ in }
        }
        XCTAssertEqual(section.rows.count, Int(count))
    }
    
    func testCreateMapArrayRows() {
        let items = [1, 2, 3]
        let section = Section() { section in
            _ = section.createRows(for: items) { _ in }
        }
        XCTAssertEqual(section.rows.count, items.count)
    }
    
    func testCreateHeader() {
        let section = Section() { section in
            _ = section.createHeader { _ in }
        }
        XCTAssertNotNil(section.header)
    }
    
    func testCreateFooter() {
        let section = Section() { section in
            _ = section.createFooter { _ in }
        }
        XCTAssertNotNil(section.footer)
    }
    
    func testCreateHeaderFooter() {
        let section = Section() { section in
            _ = section.createHeader { _ in }
            _ = section.createFooter { _ in }
        }
        XCTAssertNotNil(section.header)
        XCTAssertNotNil(section.footer)
    }
    
    func testCreateHeaderGeneric() {
        let section = Section() { (section: Section<UILabel, UIButton>) in
            _ = section.createHeader { header -> Void in
                header.configureView = { label, info in
                    label.text = "label"
                }
            }
            _ = section.createFooter { footer -> Void in
                footer.configureView = { button, info in
                    button.titleLabel!.text = "button"
                }
            }
        }
        XCTAssertNotNil(section.header)
        XCTAssertNotNil(section.footer)
    }
    
    func testCreateRowsAndHeaderFooter() {
        let count = UInt(2)
        let items = [1, 2, 3]
        let section = Section() { section in
            _ = section
                .createRow { _ in }
                .createRows(for: count) { _ in }
                .createRows(for: items) { _ in }
                .createHeader { _ in }
                .createFooter { _ in }
        }
        XCTAssertEqual(section.rows.count, 1 + Int(count) + items.count)
        XCTAssertNotNil(section.header)
        XCTAssertNotNil(section.footer)
    }
    
    func testRemoveRow() {
        let count = 10
        let section = Section() { section in
            _ = section.createRows(for: UInt(count)) { index, row in
                row.reuseIdentifier = String(index)
            }
        }
        XCTAssertEqual(section.rowCount, count)
        
        // Remove
        let removeIndex = 1
        let row = section.removeRow(removeIndex)
        XCTAssertNotNil(row)
        XCTAssertEqual(section.rowCount, count - 1)
        
        // Validation
        section.rows.forEach { row in
            print(row.reuseIdentifier)
            XCTAssertNotEqual(Int(row.reuseIdentifier), removeIndex)
        }
    }
    
    func testInsertRow() {
        let count = 10
        let section = Section() { section in
            _ = section.createRows(for: UInt(count)) { _, _ in }
        }
        XCTAssertEqual(section.rowCount, count)
        
        section.insertRow(Row() { $0.reuseIdentifier = "last" }, index: count)
        section.insertRow(Row() { $0.reuseIdentifier = "first" }, index: 0)
        
        // Validation
        XCTAssertEqual(section.rowCount, count + 2)
        XCTAssertEqual(section.rows.first?.reuseIdentifier, "first")
        XCTAssertEqual(section.rows.last?.reuseIdentifier, "last")
    }
    
    func testConfigureHeaderFooterHeight() {
        let section = Section()
        
        // Initialized
        XCTAssertEqual((section.header as? SectionHeaderFooterDelegateType)?.heightFor(UITableView(), section: 0), nil)
        XCTAssertEqual((section.footer as? SectionHeaderFooterDelegateType)?.heightFor(UITableView(), section: 0), nil)
        
        // Constant
        _ = section
            .createHeader { header in
                header.height = 10
            }
            .createFooter { footer in
                footer.height = 11
            }
        XCTAssertEqual((section.header as? SectionHeaderFooterDelegateType)?.heightFor(UITableView(), section: 0), 10)
        XCTAssertEqual((section.footer as? SectionHeaderFooterDelegateType)?.heightFor(UITableView(), section: 0), 11)
        
        // Configure height
        _ = section
            .createHeader { header in
                header.heightFor = { _ -> CGFloat? in
                    return 20
                }
            }
            .createFooter { footer in
                footer.heightFor = { _ -> CGFloat? in
                    return 21
                }
            }
        XCTAssertEqual((section.header as? SectionHeaderFooterDelegateType)?.heightFor(UITableView(), section: 0), 20)
        XCTAssertEqual((section.footer as? SectionHeaderFooterDelegateType)?.heightFor(UITableView(), section: 0), 21)
        
        // Configure nil height
        _ = section
            .createHeader { header in
                header.height = 30
                header.heightFor = { _ -> CGFloat? in
                    return nil
                }
            }
            .createFooter { footer in
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
        _ = section
            .createHeader { header in
                header.title = constantHeaderTitle
            }.createFooter { footer in
                footer.title = constantFooterTitle
            }
        XCTAssertEqual((section.header as? SectionHeaderFooterDelegateType)?.titleFor(UITableView(), section: 0), constantHeaderTitle)
        XCTAssertEqual((section.footer as? SectionHeaderFooterDelegateType)?.titleFor(UITableView(), section: 0), constantFooterTitle)
        
        // Title for
        _ = section
            .createHeader { header in
                header.titleFor = { _ -> String? in
                    return variableHeaderTitle
                }
            }
            .createFooter { footer in
                footer.titleFor = { _ -> String? in
                    return variableFooterTitle
                }
            }
        XCTAssertEqual((section.header as? SectionHeaderFooterDelegateType)?.titleFor(UITableView(), section: 0), variableHeaderTitle)
        XCTAssertEqual((section.footer as? SectionHeaderFooterDelegateType)?.titleFor(UITableView(), section: 0), variableFooterTitle)
        
        // Both
        _ = section
            .createHeader { header in
                header.title = constantHeaderTitle
                header.titleFor = { _ -> String? in
                    return variableHeaderTitle
                }
            }
            .createFooter { footer in
                footer.title = constantFooterTitle
                footer.titleFor = { _ -> String? in
                    return variableFooterTitle
                }
            }
        XCTAssertEqual((section.header as? SectionHeaderFooterDelegateType)?.titleFor(UITableView(), section: 0), variableHeaderTitle)
        XCTAssertEqual((section.footer as? SectionHeaderFooterDelegateType)?.titleFor(UITableView(), section: 0), variableFooterTitle)
        
        // Title for nil
        _ = section
            .createHeader { header in
                header.title = constantHeaderTitle
                header.titleFor = { _ -> String? in
                    return nil
                }
            }
            .createFooter { footer in
                footer.title = constantFooterTitle
                footer.titleFor = { _ -> String? in
                    return nil
                }
            }
        XCTAssertEqual((section.header as? SectionHeaderFooterDelegateType)?.titleFor(UITableView(), section: 0), constantHeaderTitle)
        XCTAssertEqual((section.footer as? SectionHeaderFooterDelegateType)?.titleFor(UITableView(), section: 0), constantFooterTitle)
    }
    
}

