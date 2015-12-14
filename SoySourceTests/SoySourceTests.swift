//
//  SoySourceTests.swift
//  SoySourceTests
//
//  Created by asai.yuki on 2015/12/12.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import XCTest
@testable import SoySource

class SoySourceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAddSection() {
        let source = SoySource().addSection(Section())
        XCTAssertEqual(source.sections.count, 1)
        
        source.addSection(Section())
        source.addSection(Section())
        XCTAssertEqual(source.sections.count, 3)
        
        // Method chain
        source.addSection(Section()).addSection(Section()).addSection(Section())
        XCTAssertEqual(source.sections.count, 6)
    }
    
    func testAddSections() {
        let source = SoySource().addSections([Section(), Section()])
        XCTAssertEqual(source.sections.count, 2)
        
        // Method chain
        source.addSections([Section()]).addSections([Section(), Section()])
        XCTAssertEqual(source.sections.count, 5)
    }
    
    func testCreateSection() {
        let source = SoySource().createSection { _ in }
        XCTAssertEqual(source.sections.count, 1)
        
        source.createSection { _ in }
        source.createSection { _ in }
        XCTAssertEqual(source.sections.count, 3)
        
        // Method chain
        source.createSection { _ in }.createSection { _ in }
        XCTAssertEqual(source.sections.count, 5)
    }
    
    func testCreateSections() {
        let source = SoySource()
        
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
        let source = SoySource()
        
        let section1 = Section()
        let row1_1 = Row()
        let row1_2 = Row()
        section1.addRows([row1_1, row1_2])
        
        let section2 = Section()
        let row2_1 = Row()
        let row2_2 = Row()
        section2.addRows([row2_1, row2_2])
        
        source.addSections([section1, section2])
        
        XCTAssert(source.sectionWith(0) as! Section === section1)
        XCTAssert(source.sectionWith(1) as! Section === section2)
        XCTAssert(source.rowWith(NSIndexPath(forRow: 0, inSection: 0)) as! Row === row1_1)
        XCTAssert(source.rowWith(NSIndexPath(forRow: 1, inSection: 0)) as! Row === row1_2)
        XCTAssert(source.rowWith(NSIndexPath(forRow: 0, inSection: 1)) as! Row === row2_1)
        XCTAssert(source.rowWith(NSIndexPath(forRow: 1, inSection: 1)) as! Row === row2_2)
    }
    
}
