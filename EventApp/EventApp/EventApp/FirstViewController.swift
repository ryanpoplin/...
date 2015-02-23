//
//  FirstViewController.swift
//  EventApp
//
//  Created by Byrdann Fox on 2/23/15.
//  Copyright (c) 2015 lycan.io. All rights reserved.
//

import UIKit
import EventKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var reminderText: UITextField!

    @IBOutlet weak var setReminder: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var appDelegate: AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func setReminder(sender: UIButton) {
    
        appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
    
        if appDelegate!.eventStore == nil {
            
            appDelegate!.eventStore = EKEventStore()
            
            appDelegate!.eventStore!.requestAccessToEntityType(
                EKEntityTypeReminder, completion: {(granted, error) in
            
                    if !granted {
                    
                        println("Access to store not granted")
                        
                        println(error.localizedDescription)
                    
                    } else {
                    
                        println("Access granted")
                    
                    }
            })
        
        }
        
        if (appDelegate!.eventStore != nil) {
            
            self.createReminder()
        
        }
        
    }
    
    func createReminder() {
        
        let reminder = EKReminder(eventStore: appDelegate!.eventStore)
        
        reminder.title = reminderText.text
        
        reminder.calendar =
            appDelegate!.eventStore!.defaultCalendarForNewReminders()
        
        let date = datePicker.date
        
        let alarm = EKAlarm(absoluteDate: date)
        
        reminder.addAlarm(alarm)
        
        var error: NSError?
        
        appDelegate!.eventStore!.saveReminder(reminder,
            commit: true, error: &error)
        
        if error != nil {
        
            println("Reminder failed with error \(error?.localizedDescription)")
        
        }
    
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        reminderText.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}