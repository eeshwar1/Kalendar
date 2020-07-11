//
//  ViewController.swift
//  Kalendar
//
//  Created by Venkateswaran Venkatakrishnan on 7/3/20.
//

import Cocoa

class ViewController: NSViewController {

    var scrollView: NSScrollView?
    var stackView: NSStackView?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let normalCalendarView = CalendarView(size: .normal)
        let smallCalendarView = CalendarView(size: .small)
        let largeCalendarView = CalendarView(size: .large)
        
        self.stackView = NSStackView()
        
        if let stackView = self.stackView  {
            
     
        stackView.orientation = .vertical
            stackView.distribution = .equalCentering
        stackView.spacing = 10

        stackView.addArrangedSubview(normalCalendarView)
        stackView.addArrangedSubview(largeCalendarView)
        stackView.addArrangedSubview(smallCalendarView)
        
        self.view.addSubview(stackView)
        stackViewConstraints()
        
        
        }
        
        // self.view.addSubview(normalCalendarView)
        // self.view.addSubview(smallCalendarView)
        
        
    }

    func stackViewConstraints() {
        
        if let stackView = self.stackView {
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            stackView.topAnchor.constraint(equalTo: stackView.superview!.topAnchor, constant: 20).isActive = true
            
            stackView.bottomAnchor.constraint(equalTo: stackView.superview!.bottomAnchor, constant: -20).isActive = true
            stackView.leftAnchor.constraint(equalTo: stackView.superview!.leftAnchor, constant: 20).isActive = true
            stackView.rightAnchor.constraint(equalTo: stackView.superview!.rightAnchor, constant: 20).isActive = true
   
        }
    }
    
    func scrollViewConstraints() {
        
        if let scrollView = self.scrollView {
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
            
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 20).isActive = true
            scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
            scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 20).isActive = true
   
        }
    }
}

