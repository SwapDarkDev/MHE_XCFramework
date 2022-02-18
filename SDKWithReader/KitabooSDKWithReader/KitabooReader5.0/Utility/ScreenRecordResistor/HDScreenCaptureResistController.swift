//
//  ScreenCaptureResistController.swift
//
//  Created by Sumanth Myrala on 24/06/20.
//  Copyright © 2020 Hurix Systems. All rights reserved.
//

import UIKit


@objc public class HDScreenCaptureResistController: UIViewController
{
    let window = UIApplication.shared.keyWindow!
    
    //MARK: Initializer Methods
    @objc public init()
    {
        super.init(nibName: nil, bundle: nil)
        self.addObserverForScreenRecording()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View LifeCycle Methods
    public override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    //MARK: Observer Methods
    func addObserverForScreenRecording()
    {
        if #available(iOS 11.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(didChangeInScreenRecord(_:)), name: UIScreen.capturedDidChangeNotification, object: nil)
        } else {
                
        }
    }

    
    func removeObserverForScreenRecording()
    {
        if #available(iOS 11.0, *) {
            NotificationCenter.default.removeObserver(self, name: UIScreen.capturedDidChangeNotification, object: nil)
        } else {
            
        }
    }
    
    @objc func didChangeInScreenRecord(_ notification:NSNotification)
    {
        resistScreenCapture()
    }
    
    
    //MARK: Utility Methods
    @objc public func resistScreenCapture()
    {
        if #available(iOS 11.0, *) {
            if UIScreen.main.isCaptured
            {
                self.view.backgroundColor = .black
                window.addSubview(self.view)
                self.view.frame = window.frame
            }
            else
            {
                self.view.backgroundColor = .white
                self.view.removeFromSuperview()
            }
        }
    }
    
    //MARK: DeInit
    deinit
    {
        self.removeObserverForScreenRecording()
    }
}
