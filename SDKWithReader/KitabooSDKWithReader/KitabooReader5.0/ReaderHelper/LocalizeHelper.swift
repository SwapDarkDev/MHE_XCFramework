//
//  LocalizeHelper.swift
//  Kitaboo 5.0
//
//  Created by Jyoti Suthar on 06/02/19.
//  Copyright © 2019 Hurix System. All rights reserved.
//

import UIKit
import Kitaboo_Reader_SDK

@objc public class LocalizeHelper: NSObject
{
    @objc public static let shared:LocalizeHelper = LocalizeHelper()
    private var myBundle:Bundle
    private var language = UserDefaults.standard
    
    override init()
    {
        myBundle = Bundle.main
    }
    
    @objc public func setLanguage(_ lang:String)
    {
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        if (path == nil)
        {
            myBundle = Bundle.main
        }else
        {
            myBundle = Bundle.init(path: path!) ?? Bundle.main
        }
        language.set(lang, forKey: "CurrentLanguage")
    }
    
    @objc public func localizedStringForKey(_ key:String?) -> String
    {
        if language.object(forKey: "CurrentLanguage") != nil
        {
            setLanguage(language.object(forKey: "CurrentLanguage")! as! String)
        }
        return myBundle.localizedString(forKey: key!, value: "", table: nil)
    }
    
    @objc public func localizedStringForKey(_ key:String?, tableName: String , bundle: Bundle) -> String
    {
        if language.object(forKey: "CurrentLanguage") != nil
        {
            setLanguage(language.object(forKey: "CurrentLanguage")! as! String)
        }
        return NSLocalizedString(key!, tableName: tableName, bundle: bundle , value: "", comment: "")
    }
}
