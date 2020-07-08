//
//  ViewController.swift
//  Kalendar
//
//  Created by Venkateswaran Venkatakrishnan on 7/3/20.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calendarView = CalendarView(frame: NSRect(x: 10, y: 10, width: 400, height: 400))
        
        self.view.addSubview(calendarView)
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

