//
//  VLinkButton.swift
//  Temporal
//
//  Created by Venky Venkatakrishnan on 4/7/20.
//  Copyright © 2020 Venky UL. All rights reserved.
//

import Cocoa

@IBDesignable class VLinkButton : NSButton
{
    @IBInspectable var link: String = ""
    var url: URL?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupButton()
    }
    
    override init(frame frameRect: NSRect) {
   
        super.init(frame: frameRect)
        setupButton()
    }
    
    convenience init(link: String, title: String) {
        
        self.init()
        self.link = link
        setupButton()
    }
    
    override func awakeFromNib() {
        
        setupLink()
        self.sendAction(on: NSEvent.EventTypeMask.leftMouseUp)
        setupButton()
        
    }
    
    func setLink(link: String) {
        self.link = link
        
       
        
        
    }
    
    func setupLink() {
        
        if let url = URL(string: self.link) {
            self.url = url
            self.toolTip = link
                 
        }
        
    }
    
    func setupButton () {
     
        self.isBordered = false
        self.contentTintColor = NSColor.blue
        self.target = self
        self.action = #selector(openLink)
       
        setupLink()
        
    }
   
    @objc func openLink()
    {
        print("Button clicked: \(link)")
        
        if let url = self.url {
            NSWorkspace.shared.open(url)
        
        }
    }
    
}
