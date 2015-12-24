//
//  SourceTests.swift
//  ShoyuTests
//
//  Created by asai.yuki on 2015/12/12.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import XCTest
@testable import Shoyu

class SourceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAddSection() {
        let source = Source().addSection(Section())
        XCTAssertEqual(source.sections.count, 1)
        
        source.addSection(Section())
        source.addSection(Section())
        XCTAssertEqual(source.sections.count, 3)
        
        // Method chain
        source.addSection(Section()).addSection(Section()).addSection(Section())
        XCTAssertEqual(source.sections.count, 6)
    }
    
    func testAddSections() {
        let source = Source().addSections([Section(), Section()])
        XCTAssertEqual(source.sections.count, 2)
        
        // Method chain
        source.addSections([Section()]).addSections([Section(), Section()])
        XCTAssertEqual(source.sections.count, 5)
    }
    
    func testCreateSection() {
        let source = Source().createSection { _ in }
        XCTAssertEqual(source.sections.count, 1)
        
        source.createSection { _ in }
        source.createSection { _ in }
        XCTAssertEqual(source.sections.count, 3)
        
        // Method chain
        source.createSection { _ in }.createSection { _ in }
        XCTAssertEqual(source.sections.count, 5)
    }
    
    func testCreateSections() {
        let source = Source()
        
        // Count
        let count = UInt(2)
        source.createSections(count) { _ in }
        XCTAssertEqual(source.sections.count, Int(count))
        
        // Items
        let items = [1, 2, 3]
        source.createSections(items) { _ in }
        XCTAssertEqual(source.sections.count, Int(count) + items.count)
    }
    
    func testSectionAndRowAtIndex() {
        let source = Source()
        
        let section1 = Section()
        let row1_1 = Row()
        let row1_2 = Row()
        section1.addRows([row1_1, row1_2])
        
        let section2 = Section()
        let row2_1 = Row()
        let row2_2 = Row()
        section2.addRows([row2_1, row2_2])
        
        source.addSections([section1, section2])
        
        XCTAssert(source.sectionFor(0) as! Section === section1)
        XCTAssert(source.sectionFor(1) as! Section === section2)
        XCTAssert(source.sectionFor(0).rowFor(0) as! Row === row1_1)
        XCTAssert(source.sectionFor(0).rowFor(1) as! Row === row1_2)
        XCTAssert(source.sectionFor(1).rowFor(0) as! Row === row2_1)
        XCTAssert(source.sectionFor(1).rowFor(1) as! Row === row2_2)
    }
    
    func testBenchmarkSource() {
        class HeaderView: UIView { }
        class FooterView: UIView { }
        class Cell: UITableViewCell {
            let label = UILabel()
        }
        
        let source = Source()
        self.measureBlock {
            source.createSections(100) { (_, section: Section<HeaderView, FooterView>) in
                section.createHeader { header in }
                section.createFooter { footer in }
                section.createRows(1000) { (_, row: Row<Cell>) in
                    row.configureCell = { event in
                        event.cell.label.text = "text"
                    }
                    row.heightFor = { _ in
                        return 52
                    }
                }
            }
        }
    }
    
}
