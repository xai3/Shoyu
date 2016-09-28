//
//  RowTests.swift
//  Shoyu
//
//  Created by Asai.Yuki on 2015/12/14.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import XCTest

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
        row.configureCell(UITableView(), cell: UITableViewCell(), indexPath: IndexPath())
        XCTAssert(called)
    }
    
    func testheightFor() {
        let row = Row()
        
        // Initialezed
        XCTAssertEqual(row.heightFor(UITableView(), indexPath: IndexPath()), nil)
        
        // Constant
        row.height = 5
        XCTAssertEqual(row.heightFor(UITableView(), indexPath: IndexPath()), 5)
        
        // Configure
        row.heightFor = { _ -> CGFloat? in
            return 10
        }
        let height = row.heightFor(UITableView(), indexPath: IndexPath())
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
        row.didSelect(UITableView(), indexPath: IndexPath())
        XCTAssert(called)
    }
    
    func testCanRemove() {
        let row = Row()
        XCTAssertFalse(row.canRemove(UITableView(), indexPath: IndexPath()))
        
        row.canRemove = { event -> Bool in
            return false
        }
        XCTAssertFalse(row.canRemove(UITableView(), indexPath: IndexPath()))
        
        row.canRemove = { event -> Bool in
            return true
        }
        XCTAssertTrue(row.canRemove(UITableView(), indexPath: IndexPath()))
    }
    
    func testCanMove() {
        let row = Row()
        XCTAssertFalse(row.canMove(UITableView(), indexPath: IndexPath()))
        
        row.canMove = { event -> Bool in
            return false
        }
        XCTAssertFalse(row.canMove(UITableView(), indexPath: IndexPath()))
        
        row.canMove = { event -> Bool in
            return true
        }
        XCTAssertTrue(row.canMove(UITableView(), indexPath: IndexPath()))
    }
    
    func testCanMoveTo() {
        let row = Row()
        XCTAssertFalse(row.canMoveTo(UITableView(), sourceIndexPath: IndexPath(), destinationIndexPath: IndexPath()))
        
        row.canMoveTo = { event -> Bool in
            return false
        }
        XCTAssertFalse(row.canMoveTo(UITableView(), sourceIndexPath: IndexPath(), destinationIndexPath: IndexPath()))
        
        row.canMoveTo = { event -> Bool in
            return true
        }
        XCTAssertTrue(row.canMoveTo(UITableView(), sourceIndexPath: IndexPath(), destinationIndexPath: IndexPath()))
    }
    
    func testCanEdit() {
        let row = Row()
        XCTAssertFalse(row.canEdit(UITableView(), indexPath: IndexPath()))
        
        row.canRemove = { event -> Bool in
            return false
        }
        row.canMove = { event -> Bool in
            return false
        }
        XCTAssertFalse(row.canEdit(UITableView(), indexPath: IndexPath()))
        
        row.canRemove = { event -> Bool in
            return true
        }
        row.canMove = { event -> Bool in
            return false
        }
        XCTAssertTrue(row.canEdit(UITableView(), indexPath: IndexPath()))
        
        row.canRemove = { event -> Bool in
            return false
        }
        row.canMove = { event -> Bool in
            return true
        }
        XCTAssertTrue(row.canEdit(UITableView(), indexPath: IndexPath()))
    }
    
    func testGenericRow() {
        class Cell: UITableViewCell { }
        
        var called = false
        let row = Row<Cell>()
        row.configureCell = { event in
            called = true
        }
        row.configureCell(UITableView(), cell: Cell(), indexPath: IndexPath())
        XCTAssert(called)
    }
    
}
