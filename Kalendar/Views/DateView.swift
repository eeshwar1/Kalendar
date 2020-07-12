//
//  DateView.swift
//  Kalendar
//
//  Created by Venkateswaran Venkatakrishnan on 7/3/20.
//

import Cocoa

class DateView: NSView {

    var date: Int = 0
    var title: String = ""
    var label: NSTextField?
    var isTitle: Bool = false
    var isOtherMonth: Bool = false
  
    var fontSize: CGFloat = 5
    
    var borderColor = NSColor.controlAccentColor
    var textColor = NSColor.textColor
    var altTextColor = NSColor.disabledControlTextColor
    
    var borderWidth: CGFloat = 0
    var highlightBorderWidth: CGFloat = 3
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    convenience init(frame frameRect: NSRect, size: Size ) {
        
        self.init(frame: frameRect)
    
        switch size {
        case .small:
            self.fontSize = 9
        case .normal:
            self.fontSize = 12
        case .large:
            self.fontSize = 14
       
        }
    }
 
    func setDate(date: Int, isOtherMonth: Bool = false)
    {
        self.date = date
        if let label = self.label {
            label.stringValue = self.date.description
            
            if isOtherMonth {
                label.textColor = altTextColor
            }
            else {
                label.textColor = textColor
            }
        }
        layoutViews()
        
    }
    
    func setTitle(title: String) {
        self.title = title
        self.isTitle = true
        if let label = self.label {
            label.stringValue = self.title
        }
        layoutViews()
    }
    
    func commonInit() {
        
        self.date = 0
        self.wantsLayer = true
        self.layer?.borderWidth = self.borderWidth
        self.layer?.borderColor = self.borderColor.cgColor
       
        self.label = NSTextField(labelWithString: "")
        
        self.addSubview(self.label!)
        
        
        
    }
    
    func layoutViews() {
        
        if let label = self.label {
         
            label.font = NSFont.systemFont(ofSize: self.fontSize)
            dateLabelConstraints()
        }
        
        if isTitle {
            self.date = 0
                self.layer?.backgroundColor = NSColor.lightGray.cgColor
            
        }
        else {
            
            self.layer?.cornerRadius = 5
            let trackingArea = NSTrackingArea(rect: self.bounds, options: [NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.activeAlways], owner: self, userInfo: nil)
            
            self.addTrackingArea(trackingArea)
        
        }
        
        self.toolTip = self.date.description
      
       
    }
    override func mouseEntered(with event: NSEvent) {
        self.layer?.borderWidth = self.highlightBorderWidth
        
    }
    override func mouseExited(with event: NSEvent) {
        self.layer?.borderWidth = self.borderWidth
    
    }
    
    func dateLabelConstraints() {
        
        if let label = self.label {
            
            label.translatesAutoresizingMaskIntoConstraints = false
            
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
            
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive =  true
        }
    }
    
}
