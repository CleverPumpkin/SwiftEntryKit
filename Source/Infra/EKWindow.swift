//
//  EKWindow.swift
//  SwiftEntryKit
//
//  Created by Daniel Huri on 4/19/18.
//  Copyright (c) 2018 huri000@gmail.com. All rights reserved.
//

import UIKit

class EKWindow: UIWindow {
    
    var isAbleToReceiveTouches = false
    
    init(with rootVC: UIViewController) {
        if #available(iOS 13.0, *) {
            let availableScenes = UIApplication.shared.connectedScenes.filter {
                $0.activationState == .foregroundActive
            }
            
            // TODO: Patched to support SwiftUI out of the box but should require attendance
            if let scene = availableScenes.first as? UIWindowScene {
                super.init(windowScene: scene)
                
                screen = scene.screen
            } else {
                super.init(frame: UIScreen.main.bounds)
                
                screen = UIScreen.main
            }
        } else {
            super.init(frame: UIScreen.main.bounds)
            
            screen = UIScreen.main
        }
        backgroundColor = .clear
        rootViewController = rootVC
        accessibilityViewIsModal = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if isAbleToReceiveTouches {
            return super.hitTest(point, with: event)
        }
        
        guard let rootVC = EKWindowProvider.shared.rootVC else {
            return nil
        }
        
        if let view = rootVC.view.hitTest(point, with: event) {
            return view
        }
        
        return nil
    }
}
