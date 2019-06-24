//
//  HudView.swift
//  My Locations
//
//  Created by demas on 24/06/2019.
//  Copyright © 2019 demas. All rights reserved.
//

import UIKit

class HudView: UIView {

    var text = ""
    
    class func hudInView(view: UIView, animated: Bool) -> HudView {
        
        let hudView = HudView(frame: view.bounds)
        hudView.isOpaque = false
        view.addSubview(hudView)
        view.isUserInteractionEnabled = false
        hudView.showAnimated(animated: animated)
        return hudView
    }
    
    func showAnimated(animated: Bool) {
        if animated {
            alpha = 0
            transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions(rawValue: 0), animations: {
                self.alpha = 1
                self.transform = .identity
            }, completion: nil)
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        let boxWidth: CGFloat = 96
        let boxHeight: CGFloat = 96
        
        let boxRect = CGRect(x: round((bounds.size.width - boxWidth) / 2),
                             y: round((bounds.size.height - boxHeight) / 2),
                             width: boxWidth, height: boxHeight)
        
        let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)
        UIColor(white: 0.3, alpha: 0.8).setFill()
        roundedRect.fill()
        
        if let image = UIImage(named: "Checkmark") {
            let imagePoint = CGPoint(
                x: center.x - round(image.size.width / 2),
                y: center.y - round(image.size.height / 2) - boxHeight / 8)
            image.draw(at: imagePoint)
        }

        let attribs: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 16.0),
                                                       .foregroundColor: UIColor.white]
        let textSize = text.size(withAttributes: attribs as [NSAttributedString.Key : Any])
        let textPoint = CGPoint(
            x: center.x - round(textSize.width / 2),
            y: center.y - round(textSize.height / 2) + boxHeight / 4)
        text.draw(at: textPoint, withAttributes: attribs as [NSAttributedString.Key : Any])
        
    }
}
