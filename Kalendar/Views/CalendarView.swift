//
//  CalendarView.swift
//  Kalendar
//
//  Created by Venkateswaran Venkatakrishnan on 7/3/20.
//

import Cocoa

enum Size {
    case small
    case normal
    case large
}

class CalendarView: NSView {

    fileprivate var dayNames: [String] = ["Su","Mo","Tu","We","Th","Fr","Sa"]
    
    var width: CGFloat = 0
    var height: CGFloat = 0
    var titleAreaHeight: CGFloat = 0
    
    var cellWidth = 30
    var cellHeight = 30
    var cellSpacing = 5
    
    var fontSize: CGFloat = 8
    
    var size: Size = .normal
    var buttonStackWidth: CGFloat = 50
    var buttonStackHeight: CGFloat = 30
    var titleStackHeight: CGFloat = 30
    var titleStackWidth: CGFloat = 100
    
    var month: CalendarMonth?
    
    var stackView: NSStackView?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override var intrinsicContentSize: NSSize {
        
        NSSize(width: width, height: height)
    }
    
    convenience init(size: Size = .normal) {
        
        var width: CGFloat = 0
        var height: CGFloat = 0
        var offset: CGFloat = 10
        
        switch size {
            case .small:
                width = 160
                offset = 12
            case .normal:
                width = 200
                offset = 14
            case .large:
                width = 250
                offset = 20
               
        }
        
        height = width + offset
        self.init(frame: NSRect(origin: CGPoint.zero, size: CGSize(width: width, height: height)))
        self.size = size
       
    }
    
    func commonInit() {
      
       
        self.width = self.bounds.width
        self.height = self.bounds.height
        
        self.wantsLayer = true
        self.layer?.borderColor = NSColor.gray.cgColor
        self.layer?.borderWidth = 3
        self.layer?.cornerRadius = 5
        self.month = CalendarMonth(month: 08, year: 2020)
        
        setConstraints()
        
        
       
    }

    override func viewWillDraw() {
        
        self.stackView = NSStackView()
        
        setupTitleArea()
        setupDateViews()
    }
        
    func setupTitleArea() {
        
        switch size {
        case .small:
            fontSize = 9
            buttonStackWidth = 30
            buttonStackHeight = 12
            titleStackHeight = 12
        case .normal:
            fontSize = 11
            buttonStackWidth = 40
            buttonStackHeight = 14
            titleStackHeight = 14
        case .large:
            fontSize = 14
            buttonStackWidth = 50
            buttonStackHeight = 20
            titleStackHeight = 20
        }
        
        let monthLabel =  NSTextField(labelWithString: "August 2020")
        monthLabel.font = NSFont.systemFont(ofSize: self.fontSize)
    
        let buttonNextMonth = VButton(buttonType: .forwardArrow, size: self.size)
        let buttonPrevMonth = VButton(buttonType: .backwardArrow, size: self.size)
        let buttonToday = VButton(buttonType: .circle, size: self.size)
        
        buttonPrevMonth.target = self
        buttonPrevMonth.action = #selector(showPrevMonth)
        
        buttonToday.target = self
        buttonToday.action = #selector(showToday)
        
        buttonNextMonth.target = self
        buttonNextMonth.action = #selector(showNextMonth)
        
        let titleStack = NSStackView()
        titleStack.orientation = .horizontal
        titleStack.alignment = .centerY
        titleStack.distribution = .equalSpacing
        titleStack.spacing = 5
    
        titleStack.addArrangedSubview(monthLabel)
    
        let buttonStack = NSStackView()
        buttonStack.orientation = .horizontal
        buttonStack.alignment = .centerY
        buttonStack.distribution = .equalSpacing
        buttonStack.spacing = 1
  
        buttonStack.addArrangedSubview(buttonPrevMonth)
        buttonStack.addArrangedSubview(buttonToday)
        buttonStack.addArrangedSubview(buttonNextMonth)
        
        titleStack.addArrangedSubview(buttonStack)
        
        buttonStack.heightAnchor.constraint(equalToConstant: buttonStackHeight).isActive = true
        buttonStack.widthAnchor.constraint(lessThanOrEqualToConstant: buttonStackWidth).isActive = true
        buttonStack.trailingAnchor.constraint(equalTo: buttonStack.superview!.trailingAnchor, constant: 0).isActive = true
    
        if let stackView = self.stackView {
            
            stackView.orientation = .vertical
            stackView.distribution = .equalSpacing
            stackView.alignment = .centerX
            stackView.spacing = 5
            
            self.addSubview(stackView)
            stackViewConstraints()
            
            stackView.addArrangedSubview(titleStack)
            
            titleStack.translatesAutoresizingMaskIntoConstraints = false
            titleStack.heightAnchor.constraint(equalToConstant: titleStackHeight).isActive = true
            titleStack.widthAnchor.constraint(greaterThanOrEqualToConstant: titleStackWidth).isActive = true
            
            titleStack.topAnchor.constraint(equalTo: titleStack.superview!.topAnchor, constant: 2).isActive = true
        
            titleStack.leftAnchor.constraint(equalTo: titleStack.superview!.leftAnchor, constant: 5).isActive = true
            
            

        }
    }
    
    func setupDateViews() {
        
        guard let month = self.month, let stackView = self.stackView else {
        
            return
        }
        
        let datesArea = NSView(frame: CGRect(origin: CGPoint(x: 0,y: titleAreaHeight), size: CGSize(width: self.bounds.width, height: self.bounds.height - titleAreaHeight)))
       
        stackView.addArrangedSubview(datesArea)
       
        let datesBounds = datesArea.bounds
        
        // dates area constraints
        cellWidth = Int(datesBounds.width/7)
        cellHeight = Int(datesBounds.height/7)
        cellSpacing = Int(datesBounds.height/50)
        
        // title row
        var row = 0
        var col = 0
        for day in dayNames {
            let titleView = DateView(frame: NSRect(x: Int(datesBounds.minX) + col * cellWidth, y: Int(datesBounds.maxY) - (cellHeight + cellSpacing + row * cellHeight), width: cellWidth, height: cellHeight), size: self.size)
            titleView.setTitle(title: day)
            datesArea.addSubview(titleView)
            col = col + 1
            if col >= 7 {
                col = 0
                row = row + 1
            }
            
        }
        
        var prevMonthIndex = 0
        let prevMonthDatesLastIndex = month.prevMonthDates.count - 1
        var prevMonthDateIndex = 0
        
        for _ in (0..<month.firstDayOfMonthWeekDay - 1)
        {
            let dateView = DateView(frame: NSRect(x: Int(datesBounds.minX) + col * cellWidth, y: Int(datesBounds.maxY) - (cellHeight + cellSpacing + row * cellHeight), width: cellWidth, height: cellHeight), size: self.size)
            
            prevMonthDateIndex = prevMonthDatesLastIndex - (month.firstDayOfMonthWeekDay -  prevMonthIndex - 2)
            dateView.setDate(date: month.prevMonthDates[prevMonthDateIndex], isOtherMonth: true)
            dateView.isOtherMonth = true
            datesArea.addSubview(dateView)
            
            col = col + 1
            prevMonthIndex = prevMonthIndex + 1
        }
      
        for date in month.dates {
            
            let dateView = DateView(frame: NSRect(x: Int(datesBounds.minX) + col * cellWidth, y: Int(datesBounds.maxY) - (cellHeight + cellSpacing + row * cellHeight), width: cellWidth, height: cellHeight), size: self.size)
            
            dateView.setDate(date: date)
            datesArea.addSubview(dateView)
            col = col + 1
            if col >= 7 {
                col = 0
                row = row + 1
            }
        }
      
        var nextMonthIndex = 0
        while (col < 7) {
            
            let dateView = DateView(frame: NSRect(x: Int(datesBounds.minX) + col * cellWidth, y: Int(datesBounds.maxY) - (cellHeight + cellSpacing + row * cellHeight), width: cellWidth, height: cellHeight), size: self.size)
            
            dateView.setDate(date: month.nextMonthDates[nextMonthIndex], isOtherMonth: true)
            dateView.isOtherMonth = true
            datesArea.addSubview(dateView)
            col = col + 1
            nextMonthIndex = nextMonthIndex + 1
        }
    }
    
    func setConstraints() {
 
        self.translatesAutoresizingMaskIntoConstraints = true
        
    }
    
    func stackViewConstraints() {
        
        if let stackView = self.stackView {
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            stackView.topAnchor.constraint(equalTo: stackView.superview!.topAnchor, constant: 1).isActive = true
            
            stackView.bottomAnchor.constraint(equalTo: stackView.superview!.bottomAnchor, constant: -1).isActive = true
            stackView.leftAnchor.constraint(equalTo: stackView.superview!.leftAnchor, constant: 2).isActive = true
            stackView.rightAnchor.constraint(equalTo: stackView.superview!.rightAnchor, constant: 2).isActive = true
   
        }
    }
 
    // MARK:-  Actions
    
    @IBAction func showNextMonth(sender: NSButton) {
        
        print("Next Month")
        
    }
    
    @IBAction func showPrevMonth(sender: NSButton) {
        
        print("Previous Month")
        
    }
    @IBAction func showToday(sender: NSButton) {
        
        print("Show Today")
        
    }
    
}
