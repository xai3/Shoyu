//
//  SectionHeaderFooter.swift
//  Shoyu
//
//  Created by Asai.Yuki on 2015/12/14.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

public protocol SectionHeaderFooterType {
    var reuseIdentifier: String? { get }
    var height: CGFloat? { get set }
    var title: String? { get set }
    
    func configureView(view: UIView, section: Int)
    func heightFor(section: Int) -> CGFloat?
    func viewFor(section: Int) -> UIView?
}

public class SectionHeaderFooter<Type: UIView>: SectionHeaderFooterType {
    public init() { }
    
    public init(@noescape clousure: (SectionHeaderFooter<Type> -> Void)) {
        clousure(self)
    }
    
    private var _reuseIdentifier: String?
    public var reuseIdentifier: String? {
        set {
            _reuseIdentifier = newValue
        }
        get {
            if let identifier = _reuseIdentifier {
                return identifier
            }
            if let identifier = Type() as? ReuseIdentifierType {
                return identifier.identifier
            }
            return nil
        }
    }
    
    public var height: CGFloat?
    public var title: String?
    
    public var configureView: ((Type, Int) -> Void)?
    public var heightFor: (Int -> CGFloat?)?
    public var createView: (Int -> Type?)?
}

extension SectionHeaderFooter {
    public func configureView(view: UIView, section: Int) {
        guard let genericView = view as? Type else {
            fatalError()
        }
        configureView?(genericView, section)
    }
    
    public func heightFor(section: Int) -> CGFloat? {
        return heightFor?(section) ?? height
    }
    
    public func viewFor(section: Int) -> UIView? {
        return createView?(section)
    }
}
