//
//  AccessibilityHelper.swift
//  Kitaboo 5.0
//
//  Created by Gaurav Bhatia on 04/02/19.
//  Copyright © 2019 Hurix System. All rights reserved.
//

import Foundation
import UIKit

extension UIView
{
    @objc public func setAccessibility(ForElementID elementID:String)
    {
       //Access KitabooAccessibility Json and get the properties for the respective element and pass the same to setAccessibility
        let themeFilePath =  Bundle(for: TOCViewController.self).path(forResource: "KitabooAccessibility", ofType: "json")
        let data = NSData.init(contentsOfFile: themeFilePath!)
        do
        {
            let resultJson = try JSONSerialization.jsonObject(with: data! as Data, options: []) as? [String:AnyObject]
            if let dictionary = resultJson
            {
                if  let nestedDictionary = dictionary[elementID] as? [String: Any] {
                    setAccessibility(isAccessibilityEnabled: ((nestedDictionary["isAccessiblityEnabled"] != nil)), accessibilityLabel: nestedDictionary["label"] as! String, accessibilityHint: nestedDictionary["hint"] as! String)
                }
            }
        } catch
        {
            print("Error -> \(error)")
        }
    }
    
    private func setAccessibility(isAccessibilityEnabled:Bool,accessibilityLabel:String,accessibilityHint:String)
    {
        self.isAccessibilityElement=isAccessibilityEnabled
        self.accessibilityLabel=accessibilityLabel
        self.accessibilityHint=accessibilityHint
        self.accessibilityTraits=UIAccessibilityTraits.staticText
    }
}
