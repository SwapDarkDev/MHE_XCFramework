//
//  LanguageBundle.swift
//  MultipleLangSupport
//
//  Created by Bhanu Kashyap on 25/06/20.
//  Copyright © 2020 hurix. All rights reserved.
//

import Foundation
var bundleKey: UInt8 = 0

open class HDLanguageBundle: Bundle {

    override open func localizedString(forKey key: String,
                                  value: String?,
                                  table tableName: String?) -> String {

        guard let path = objc_getAssociatedObject(self, &bundleKey) as? String,
              let bundle = Bundle(path: path) else {

            return super.localizedString(forKey: key, value: value, table: tableName)
            }

        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
    
    @objc open class func setApplicationLanguage(_ language: String)
    {
        object_setClass(Bundle(for: HDLanguageBundle.self), HDLanguageBundle.self)
        objc_setAssociatedObject(Bundle(for: HDLanguageBundle.self), &bundleKey,    Bundle(for: HDLanguageBundle.self).path(forResource: language, ofType: "lproj"), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
