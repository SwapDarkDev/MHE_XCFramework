//
//  RTLorLTRFlowLayoutForReader.swift
//  KitabooSDKWithReader
//
//  Created by Bhanu Kashyap on 25/02/21.
//  Copyright © 2021 Hurix Systems. All rights reserved.
//

import UIKit

@objc open class RTLorLTRFlowLayoutForReader: UICollectionViewFlowLayout {
    @objc public override init() {
        super.init()
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc open override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        return UIApplication.shared.userInterfaceLayoutDirection == UIUserInterfaceLayoutDirection.rightToLeft
      }
}
