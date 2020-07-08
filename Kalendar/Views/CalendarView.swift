//
//  CalendarView.swift
//  Kalendar
//
//  Created by Venkateswaran Venkatakrishnan on 7/3/20.
//

import Cocoa

class CalendarView: NSView {

    fileprivate var dayNames: [String] = ["Su","Mo","Tu","We","Th","Fr","Sa"]
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        
        
        self.wantsLayer = true
        self.layer?.borderColor = NSColor.gray.cgColor
        self.layer?.borderWidth = 5
        let currentMonth = CalendarMonth(month: 07, year: 2020)
        
        var row = 0
        var col = 0
        let cellWidth = 50
        let cellHeight = 50
        
        let viewFrame = self.frame
        let calendarFrame = viewFrame.insetBy(dx: 10, dy: 10)
        
        // title row
        
        for day in dayNames {
            let titleView = DateView(frame: NSRect(x: Int(calendarFrame.minX) + col * cellWidth, y: Int(calendarFrame.maxY) - (cellHeight + 20 + row * cellHeight), width: cellWidth, height: cellHeight))
            titleView.setTitle(title: day)
            self.addSubview(titleView)
            col = col + 1
            if col >= 7 {
                col = 0
                row = row + 1
            }
            
        }
        
        for _ in (0..<currentMonth.firstDayOfMonthWeekDay - 1)
        {
            let dateView = DateView(frame: NSRect(x: Int(calendarFrame.minX) + col * cellWidth, y: Int(calendarFrame.maxY) - (cellHeight + 20 + row * cellHeight), width: cellWidth, height: cellHeight))
            
            dateView.setDate(date: 0)
            self.addSubview(dateView)
            
            col = col + 1
        }
      
        for date in currentMonth.dates {
            
            let dateView = DateView(frame: NSRect(x: Int(calendarFrame.minX) + col * cellWidth, y: Int(calendarFrame.maxY) - (cellHeight + 20 + row * cellHeight), width: cellWidth, height: cellHeight))
            
            dateView.setDate(date: date)
            self.addSubview(dateView)
            col = col + 1
            if col >= 7 {
                col = 0
                row = row + 1
            }
        }
        
        print("col = \(col)")
        while (col < 7) {
            
           
            let dateView = DateView(frame: NSRect(x: Int(calendarFrame.minX) + col * cellWidth, y: Int(calendarFrame.maxY) - (cellHeight + 20 + row * cellHeight), width: cellWidth, height: cellHeight))
            
            dateView.setDate(date: 0)
            self.addSubview(dateView)
            col = col + 1
        }
    }

    
}
