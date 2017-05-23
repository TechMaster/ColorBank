//
//  YPMagnifyingView.swift
//  YPMagnifyingGlass
//
//  Created by Geert-Jan Nilsen on 02/06/15.
//  Copyright (c) 2015 Yuppielabel.com All rights reserved.
//

import UIKit

public class YPMagnifyingView: UIView {
    
    private var magnifyingGlassShowDelay: TimeInterval = 0.2
    
    private var touchTimer: Timer!
    
    public var magnifyingGlass: YPMagnifyingGlass = YPMagnifyingGlass()
    
    public var focusPoint: YPMagnifyingGlass = YPMagnifyingGlass()
    
    public var sniper: Sniper = Sniper()
    
    public var pickedColor: String = String()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Touch Events
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch: UITouch = touches.first {
            
            self.touchTimer = Timer.scheduledTimer(timeInterval: magnifyingGlassShowDelay, target: self, selector: #selector(YPMagnifyingView.addMagnifyingGlassTimer(timer:)), userInfo: NSValue(cgPoint: touch.location(in: self)), repeats: false)
            
            pickedColor = self.getPixelColorAtPoint(point: touch.location(in: self), sourceView: self)
            
            print(pickedColor)
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch: UITouch = touches.first {
            
            self.removeSniper()
            self.updateMagnifyingGlassAtPoint(point: touch.location(in: self))
            
            pickedColor = self.getPixelColorAtPoint(point: touch.location(in: self), sourceView: self)
            
            print(pickedColor)

        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchTimer.invalidate()
        self.touchTimer = nil
        
        self.removeMagnifyingGlass()
        
        if let touch: UITouch = touches.first {
            self.addSniperAtPoint(point: touch.location(in: self))
            pickedColor = self.getPixelColorAtPoint(point: touch.location(in: self), sourceView: self)
            print(pickedColor)

        }
    }
    
    // MARK: - Private Functions
    
    private func addSniperAtPoint(point: CGPoint){
        self.sniper.viewToMagnify = self as UIView
        self.sniper.touchPoint = point
        
        let selfView: UIView = self as UIView
        
        selfView.addSubview(self.sniper)
        self.sniper.setNeedsDisplay()

    }
    
    private func addMagnifyingGlassAtPoint(point: CGPoint) {
        
        self.magnifyingGlass.viewToMagnify = self as UIView
        self.magnifyingGlass.touchPoint = point
        
        self.focusPoint.viewToMagnify = self as UIView
        self.focusPoint.touchPoint = point
        
        let selfView: UIView = self as UIView
        
        selfView.addSubview(self.magnifyingGlass)
        selfView.addSubview(self.focusPoint)
        
        self.magnifyingGlass.setNeedsDisplay()
        self.focusPoint.setNeedsDisplay()

    }
    
    private func removeMagnifyingGlass() {
        self.magnifyingGlass.removeFromSuperview()
        self.focusPoint.removeFromSuperview()
    }
    
    private func removeSniper() {
        self.sniper.removeFromSuperview()
    }
    
    private func updateMagnifyingGlassAtPoint(point: CGPoint) {
        
        self.magnifyingGlass.touchPoint = point
        self.magnifyingGlass.setNeedsDisplay()
        
        self.focusPoint.touchPoint = point
        self.focusPoint.setNeedsDisplay()

    }
    
    public func addMagnifyingGlassTimer(timer: Timer) {
        let value: AnyObject? = timer.userInfo as AnyObject?
        if let point = value?.cgPointValue {
            self.addMagnifyingGlassAtPoint(point: point)
            self.removeSniper()
        }
    }
}
