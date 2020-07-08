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
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
 
    func setDate(date: Int)
    {
        self.date = date
        if let label = self.label {
            label.stringValue = self.date.description
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
        self.layer?.borderWidth = 1
        self.layer?.borderColor = NSColor.gray.cgColor
        
        self.label = NSTextField(labelWithString: "")
        self.label?.font = NSFont.systemFont(ofSize: 20)
        self.addSubview(self.label!)
        dateLabelConstraints()
        
    }
    
    func layoutViews() {
        
        
        if isTitle {
            self.date = 0
            self.layer?.backgroundColor = NSColor.lightGray.cgColor
            
        }
        else {
         
            
       
            let trackingArea = NSTrackingArea(rect: self.bounds, options: [NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.activeAlways], owner: self, userInfo: nil)
            
            self.addTrackingArea(trackingArea)
        
        }
       
    }
    override func mouseEntered(with event: NSEvent) {
        self.layer?.borderWidth = 3
        self.layer?.backgroundColor = NSColor.red.cgColor
    }
    override func mouseExited(with event: NSEvent) {
        self.layer?.borderWidth = 1
        self.layer?.backgroundColor = NSColor.clear.cgColor
    
    }
    
    func dateLabelConstraints() {
        
        if let label = self.label {
            label.translatesAutoresizingMaskIntoConstraints = false
            
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
            
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive =  true
        }
    }
    
}
