//
//  VButton.swift
//  CustomControls
//
//  Created by Venky Venkatakrishnan on 8/6/18.
//  Copyright © 2018 Venky UL. All rights reserved.
//

import Cocoa

@IBDesignable

class VButton: NSButton {
    
    enum ButtonType {
        case circle
        case forwardArrow
        case backwardArrow
        case forwardDoubleArrow
        case backwardDoubleArrow
       
    }
    
    @IBInspectable var backColor: NSColor = NSColor.black
    
    var buttonType: ButtonType = .circle
    
    var inset: CGFloat = 0
    var isDown: Bool = false
    var size: Size = .normal
    
    var lineWidth: CGFloat = 0.5
    
    var buttonPath: NSBezierPath = NSBezierPath()
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        setPath()
        
    }
    
    required override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
    
        setPath()
    }
    
    convenience init(buttonType: ButtonType, size: Size) {
        
        var width = 0
        var height = 0
        
        switch size {
        case .small:
            width = 8
            height = 8
        case .normal:
            width = 10
            height = 10
        case .large:
            width = 15
            height = 15
        
        }
        self.init(frame: NSRect(origin: CGPoint.zero, size: CGSize(width: width, height: height)))
        self.buttonType = buttonType
        self.size = size
        
    }
    
    override var intrinsicContentSize: NSSize {
        return NSSize(width: self.bounds.width, height: self.bounds.height)
    }
    
    func setPath()
    {
        let shapeBounds = bounds.insetBy(dx: inset, dy: inset)
        
        switch self.size {
        case .small:
            lineWidth = 1
        case .normal:
            lineWidth = 2
        case .large:
            lineWidth = 3
        
        }
        
        switch self.buttonType
        {
        case .circle:
            self.buttonPath = NSBezierPath()
            self.buttonPath = NSBezierPath(ovalIn: shapeBounds)
            self.lineWidth = 0.1
            
        case .forwardArrow:
                   
           self.buttonPath = NSBezierPath()
           
           self.buttonPath.move(to: NSPoint(x: shapeBounds.minX,y: shapeBounds.minY))
           self.buttonPath.line(to: NSPoint(x: shapeBounds.maxX - shapeBounds.width *  0.4, y: shapeBounds.minY
           + shapeBounds.height/2))
           self.buttonPath.line(to: NSPoint(x: shapeBounds.minX, y: shapeBounds.maxY))
          
                           
        case .backwardArrow:
                
           self.buttonPath = NSBezierPath()
           self.buttonPath.move(to: NSPoint(x: shapeBounds.maxX,y: shapeBounds.minY))
           self.buttonPath.line(to: NSPoint(x: shapeBounds.minX + shapeBounds.width * 0.4, y: shapeBounds.minY + shapeBounds.height/2))
           self.buttonPath.line(to: NSPoint(x: shapeBounds.maxX, y: shapeBounds.maxY))
                                              
        case .forwardDoubleArrow:
                           
           self.buttonPath = NSBezierPath()
                           
           self.buttonPath.move(to: NSPoint(x: shapeBounds.minX,y: shapeBounds.minY))
           self.buttonPath.line(to: NSPoint(x: shapeBounds.minX + shapeBounds.width * 0.6, y: shapeBounds.minY + shapeBounds.height/2))
           self.buttonPath.line(to: NSPoint(x: shapeBounds.minX, y: shapeBounds.maxY))
                              
           let secondArrow = NSBezierPath()
           secondArrow.move(to: NSPoint(x: shapeBounds.minX + shapeBounds.width * 0.4, y: shapeBounds.minY))
           secondArrow.line(to: NSPoint(x: shapeBounds.minX + shapeBounds.width, y: shapeBounds.minY + shapeBounds.height/2))
           secondArrow.line(to: NSPoint(x: shapeBounds.minX + shapeBounds.width * 0.4, y: shapeBounds.maxY))
        
           self.buttonPath.append(secondArrow)
        
                               
        case .backwardDoubleArrow:
            
           self.buttonPath = NSBezierPath()
           self.buttonPath.move(to: NSPoint(x: shapeBounds.maxX,y: shapeBounds.minY))
           self.buttonPath.line(to: NSPoint(x: shapeBounds.minX + shapeBounds.width * 0.4, y: shapeBounds.minY + shapeBounds.height/2))
           self.buttonPath.line(to: NSPoint(x: shapeBounds.maxX, y: shapeBounds.maxY))
                            
           let secondArrow = NSBezierPath()
           secondArrow.move(to: NSPoint(x: shapeBounds.minX + shapeBounds.width * 0.6, y: shapeBounds.minY))
           secondArrow.line(to: NSPoint(x: shapeBounds.minX, y: shapeBounds.minY +  shapeBounds.height/2))
           secondArrow.line(to: NSPoint(x: shapeBounds.minX + shapeBounds.width * 0.6, y: shapeBounds.maxY))
                               
           self.buttonPath.append(secondArrow)
       
       
        }
        
    }
    
    override func draw(_ dirtyRect: NSRect) {
    
        setPath()
        if isDown == true
        {
            NSColor.darkGray.setFill()
            NSColor.darkGray.setStroke()
        }
        else
        {
            self.backColor.setFill()
            self.backColor.setStroke()
        }
                
        buttonPath.lineWidth = self.lineWidth
        
        buttonPath.stroke()
        
        if self.buttonType == .circle {
            buttonPath.fill()
        }
        
        
    }
    

}
