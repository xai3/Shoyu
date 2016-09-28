//
//  SourceTests.swift
//  ShoyuTests
//
//  Created by asai.yuki on 2015/12/12.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import XCTest

class SourceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAddSection() {
        let source = Source().add(section: Section())
        XCTAssertEqual(source.sections.count, 1)
        
        _ = source.add(section: Section()).add(section: Section())
        XCTAssertEqual(source.sections.count, 3)
        
        // Method chain
        _ = source.add(section: Section()).add(section: Section()).add(section: Section())
        XCTAssertEqual(source.sections.count, 6)
    }
    
    func testAddSections() {
        let source = Source().add(sections: [Section(), Section()])
        XCTAssertEqual(source.sections.count, 2)
        
        // Method chain
        _ = source.add(sections: [Section()]).add(sections: [Section(), Section()])
        XCTAssertEqual(source.sections.count, 5)
    }
    
    func testCreateSection() {
        let source = Source().createSection { _ in }
        XCTAssertEqual(source.sections.count, 1)
        
        _ = source.createSection { _ in }.createSection { _ in }
        XCTAssertEqual(source.sections.count, 3)
        
        // Method chain
        _ = source.createSection { _ in }.createSection { _ in }
        XCTAssertEqual(source.sections.count, 5)
    }
    
    func testCreateSections() {
        let source = Source()
        
        // Count
        let count = UInt(2)
        _ = source.createSections(for: count) { _ in }
        XCTAssertEqual(source.sections.count, Int(count))
        
        // Items
        let items = [1, 2, 3]
        _ = source.createSections(for: items) { _ in }
        XCTAssertEqual(source.sections.count, Int(count) + items.count)
    }
    
    func testSectionAndRowAtIndex() {
        let source = Source()
        
        let section1 = Section()
        let row1_1 = Row()
        let row1_2 = Row()
        _ = section1.add(rows: [row1_1, row1_2])
        
        let section2 = Section()
        let row2_1 = Row()
        let row2_2 = Row()
        _ = section2.add(rows: [row2_1, row2_2])
        
        _ = source.add(sections: [section1, section2])
        
        XCTAssert(source.section(for: 0) as! Section === section1)
        XCTAssert(source.section(for: 1) as! Section === section2)
        XCTAssert(source.section(for: 0).rowFor(0) as! Row === row1_1)
        XCTAssert(source.section(for: 0).rowFor(1) as! Row === row1_2)
        XCTAssert(source.section(for: 1).rowFor(0) as! Row === row2_1)
        XCTAssert(source.section(for: 1).rowFor(1) as! Row === row2_2)
    }
    
    func testMoveRow() {
        func reuseIdentifierFrom(section: Int, row: Int) -> String {
            return String(section * 10000 + row)
        }
        func reuserIdentifier(from indexPath: IndexPath) -> String {
            return reuseIdentifierFrom(section: indexPath.section, row: indexPath.row)
        }
        
        let sectionCount = 10
        let rowCount = 10
        let source = Source { source in
            _ = source.createSections(for: UInt(sectionCount)) { sectionIndex, section in
                _ = section.createRows(for: UInt(rowCount)) { rowIndex, row in
                    row.reuseIdentifier = reuseIdentifierFrom(section: Int(sectionIndex), row: Int(rowIndex))
                }
            }
        }
        
        let sourceIndexPath = IndexPath(row: 2, section: 3)
        let destinationIndexPath = IndexPath(row: 4, section: 5)
        
        // Move
        source.moveRow(sourceIndexPath, destinationIndexPath: destinationIndexPath)
        
        // Validation
        XCTAssertNotEqual(source.section(for: sourceIndexPath).rowFor(sourceIndexPath).reuseIdentifier, reuserIdentifier(from: sourceIndexPath))
        XCTAssertEqual(source.section(for: destinationIndexPath).rowFor(destinationIndexPath).reuseIdentifier, reuserIdentifier(from: sourceIndexPath))
    }
    
    func testPermitIndexPath() {
        let rowLimit = UInt(10)
        let sectionLimit = UInt(10)
        
        let source = Source() { source in
            _ = source.createSections(for: sectionLimit) { _, section in
                _ = section.createRows(for: rowLimit) { _ in }
            }
        }
        
        let notFailIndexPath = IndexPath(row: Int(rowLimit - 1), section: Int(sectionLimit - 1))
        XCTAssertTrue(source.isPermitIndexPath(notFailIndexPath))
        
        let failIndexPath = IndexPath(row: Int(rowLimit), section: Int(sectionLimit))
        XCTAssertFalse(source.isPermitIndexPath(failIndexPath))
    }
    
    func testBenchmarkSource() {
        class HeaderView: UIView { }
        class FooterView: UIView { }
        class Cell: UITableViewCell {
            let label = UILabel()
        }
        
        let source = Source()
        self.measure {
            _ = source.createSections(for: 100) { (_, section: Section<HeaderView, FooterView>) in
                _ = section
                    .createHeader { header in }
                    .createFooter { footer in }
                    .createRows(for: 1000) { (_, row: Row<Cell>) in
                        row.configureCell = { cell, info in
                            cell.label.text = "text"
                        }
                        row.heightFor = { _ in
                            return 52
                        }
                }
            }
        }
    }
    
}
