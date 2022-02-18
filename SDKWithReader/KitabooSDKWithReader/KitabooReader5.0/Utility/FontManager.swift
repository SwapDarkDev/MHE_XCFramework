//
//  FontManager.swift
//  Kitaboo 5.0
//
//
//  Copyright © 2020 Hurix System. All rights reserved.
//

import UIKit

class FontManager: NSObject {

}

public extension UIFont {

    @objc static func jbs_registerFont(withFilenameString filenameString: String, bundle: Bundle) {

        guard let pathForResourceString = bundle.path(forResource: filenameString, ofType: "ttf") else {
            return
        }

        guard let fontData = NSData(contentsOfFile: pathForResourceString) else {
            return
        }

        guard let dataProvider = CGDataProvider(data: fontData) else {
            return
        }

        guard let font = CGFont(dataProvider) else {
            return
        }

        var errorRef: Unmanaged<CFError>? = nil
        if (CTFontManagerRegisterGraphicsFont(font, &errorRef) == false) {
        }
    }
}
