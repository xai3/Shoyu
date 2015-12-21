//
//  SectionHeaderFooter.swift
//  Shoyu
//
//  Created by Asai.Yuki on 2015/12/14.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

public class SectionHeaderFooter<Type: UIView>: SectionHeaderFooterType {
    public init() { }
    
    public init(@noescape closure: (SectionHeaderFooter<Type> -> Void)) {
        closure(self)
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
    public var titleFor: (Int -> String?)?
    public var createView: (Int -> Type?)?
}

extension SectionHeaderFooter: SectionHeaderFooterDelegateType {
    func configureView(view: UIView, section: Int) {
        guard let genericView = view as? Type else {
            fatalError()
        }
        configureView?(genericView, section)
    }
    
    func heightFor(section: Int) -> CGFloat? {
        return heightFor?(section) ?? height
    }
    
    func titleFor(section: Int) -> String? {
        return titleFor?(section) ?? title
    }
    
    func viewFor(section: Int) -> UIView? {
        return createView?(section)
    }
}
