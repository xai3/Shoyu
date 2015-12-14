//
//  RowTests.swift
//  SoySource
//
//  Created by Asai.Yuki on 2015/12/14.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import XCTest
@testable import SoySource

class RowTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testConfigureCell() {
        var called = false
        let row = Row()
        row.configureCell = { _ in
            called = true
        }
        
        // Not called
        XCTAssertFalse(called)
        
        // Called
        row.configureCell(UITableViewCell(), indexPath: NSIndexPath())
        XCTAssert(called)
    }
    
    func testheightFor() {
        let row = Row()
        
        // Initialezed
        XCTAssertEqual(row.heightFor(NSIndexPath()), nil)
        
        // Constant
        row.height = 5
        XCTAssertEqual(row.heightFor(NSIndexPath()), 5)
        
        // Configure
        row.heightFor = { _ -> CGFloat? in
            return 10
        }
        let height = row.heightFor(NSIndexPath())
        XCTAssertEqual(height, 10)
    }
    
    func testDidSelect() {
        var called = false
        let row = Row()
        row.didSelect = { _ in
            called = true
        }
        
        // Not called
        XCTAssertFalse(called)
        
        // Called
        row.didSelect(NSIndexPath())
        XCTAssert(called)
    }
    
    func testGenericRow() {
        class Cell: UITableViewCell { }
        
        var called = false
        let row = Row<Cell>()
        row.configureCell = { (cell: Cell, _) in
            called = true
        }
        row.configureCell(Cell(), indexPath: NSIndexPath())
        XCTAssert(called)
    }
    
}
