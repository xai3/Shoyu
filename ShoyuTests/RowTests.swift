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
    
    func testCanRemove() {
        let row = Row()
        XCTAssertFalse(row.canRemove(UITableView(), indexPath: NSIndexPath()))
        
        row.canRemove = { event -> Bool? in
            return false
        }
        XCTAssertFalse(row.canRemove(UITableView(), indexPath: NSIndexPath()))
        
        row.canRemove = { event -> Bool? in
            return true
        }
        XCTAssertTrue(row.canRemove(UITableView(), indexPath: NSIndexPath()))
    }
    
    func testCanMove() {
        let row = Row()
        XCTAssertFalse(row.canMove(UITableView(), indexPath: NSIndexPath()))
        
        row.canMove = { event -> Bool? in
            return false
        }
        XCTAssertFalse(row.canMove(UITableView(), indexPath: NSIndexPath()))
        
        row.canMove = { event -> Bool? in
            return true
        }
        XCTAssertTrue(row.canMove(UITableView(), indexPath: NSIndexPath()))
    }
    
    func testCanMoveTo() {
        let row = Row()
        XCTAssertFalse(row.canMoveTo(UITableView(), sourceIndexPath: NSIndexPath(), destinationIndexPath: NSIndexPath()))
        
        row.canMoveTo = { event -> Bool? in
            return false
        }
        XCTAssertFalse(row.canMoveTo(UITableView(), sourceIndexPath: NSIndexPath(), destinationIndexPath: NSIndexPath()))
        
        row.canMoveTo = { event -> Bool? in
            return true
        }
        XCTAssertTrue(row.canMoveTo(UITableView(), sourceIndexPath: NSIndexPath(), destinationIndexPath: NSIndexPath()))
    }
    
    func testCanEdit() {
        let row = Row()
        XCTAssertFalse(row.canEdit(UITableView(), indexPath: NSIndexPath()))
        
        row.canRemove = { event -> Bool? in
            return false
        }
        row.canMove = { event -> Bool? in
            return false
        }
        XCTAssertFalse(row.canEdit(UITableView(), indexPath: NSIndexPath()))
        
        row.canRemove = { event -> Bool? in
            return true
        }
        row.canMove = { event -> Bool? in
            return false
        }
        XCTAssertTrue(row.canEdit(UITableView(), indexPath: NSIndexPath()))
        
        row.canRemove = { event -> Bool? in
            return false
        }
        row.canMove = { event -> Bool? in
            return true
        }
        XCTAssertTrue(row.canEdit(UITableView(), indexPath: NSIndexPath()))
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
