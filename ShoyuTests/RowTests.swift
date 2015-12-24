//
//  RowTests.swift
//  Shoyu
//
//  Created by Asai.Yuki on 2015/12/14.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import XCTest
@testable import Shoyu

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
        row.configureCell(UITableView(), cell: UITableViewCell(), indexPath: NSIndexPath())
        XCTAssert(called)
    }
    
    func testheightFor() {
        let row = Row()
        
        // Initialezed
        XCTAssertEqual(row.heightFor(UITableView(), indexPath: NSIndexPath()), nil)
        
        // Constant
        row.height = 5
        XCTAssertEqual(row.heightFor(UITableView(), indexPath: NSIndexPath()), 5)
        
        // Configure
        row.heightFor = { _ -> CGFloat? in
            return 10
        }
        let height = row.heightFor(UITableView(), indexPath: NSIndexPath())
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
        row.didSelect(UITableView(), indexPath: NSIndexPath())
        XCTAssert(called)
    }
    
    func testGenericRow() {
        class Cell: UITableViewCell { }
        
        var called = false
        let row = Row<Cell>()
        row.configureCell = { event in
            called = true
        }
        row.configureCell(UITableView(), cell: Cell(), indexPath: NSIndexPath())
        XCTAssert(called)
    }
    
}
