//
//  SectionTest.swift
//  SoySource
//
//  Created by Asai.Yuki on 2015/12/14.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import XCTest
@testable import SoySource

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
    
}

