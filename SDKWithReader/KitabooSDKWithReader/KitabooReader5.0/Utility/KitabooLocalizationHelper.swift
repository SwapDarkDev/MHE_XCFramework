//
//  KitabooLocalizationHelper.swift
//  Kitaboo
//
//  Created by Hurixadmin on 25/07/18.
//  Copyright © 2018 Hurix System. All rights reserved.
//

import Foundation
//import Kitaboo_Reader_SDK

extension LocalizationHelper {
     public static func localizedString(key: String) -> String {
        if (readerLanguageBundle != nil)
        {
            return NSLocalizedString(key, tableName: nil, bundle:readerLanguageBundle!  , value: "", comment: "")
        }
        return NSLocalizedString(key, tableName: nil, bundle: Bundle(for: ReaderViewController.self) , value: "", comment: "")
    }
    
     public static func localizedString(key: String , tableName: String , bundle: Bundle) -> String {

        return NSLocalizedString(key, tableName: tableName, bundle: bundle , value: "", comment: "")
    }
}
