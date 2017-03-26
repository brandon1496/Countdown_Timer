//
//  ViewController.swift
//  Countdown_Timer
//
//  Created by Brandon Innis on 3/22/17.
//  Copyright © 2017 Brandon Innis. All rights reserved.
//
// importing the standard lib 
// import AV Foundation to use sound for my app
// import UserNotifications to be able to use The Notifications system of the Iphone
import UIKit
import AVFoundation
import UserNotifications

class ViewController: UIViewController {
    // 30 seconds are the default value
    var seconds = 30
    // Creates the Timer() object
    var timer = Timer()
    // creating sound object
    var audioPlayer = AVAudioPlayer()
    // value for slider
    var number = "30"
   
    // button is connected to the Start button
    @IBOutlet weak var start_outlet: UIButton!
    // button is connected to the slider
    @IBOutlet weak var slider_outlet: UISlider!
    // button is connected to the label that displays the current seconds
    @IBOutlet weak var number_lbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Ask the user for permission to allow notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in})
        // Checks to see if the sound is available        
        do
        {
            let audiopath = Bundle.main.path(forResource: "sound", ofType: ".mp3")
            try audioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audiopath!))
        }
        // IF theres no sound
        catch {
            print("NO SOUND")
            
        }
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // func handles when the user use the slider on the main screen
    @IBAction func Slider(_ sender: UISlider) {
        seconds = Int(sender.value)
        // what ever value the slider is on, it will be displayed on the top label
        number_lbl.text = String(seconds) + " Seconds"
        }
    
    // func handles when the user clicks on the start button
    @IBAction func Start_btn(_ sender: Any) {
        number = String(Int(slider_outlet.value))
      // The timer object handles the process of when the slider would countdown
        // It also calls the func action that handles waht happens when it reaches zero
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.action), userInfo: nil, repeats: true)
        // the start button disappears
        start_outlet.isHidden = true
        // the slider button disappears        
        slider_outlet.isHidden = true
        
        
    }
    
    // func handles what happens when the slider reaches zero
    func action(){
        seconds -= 1
        number_lbl.text = String(seconds) + " Seconds"
        // What happens when the seconds == 0
        if (seconds == 0){
            timer.invalidate()
            // Sets the slider back to zero
            slider_outlet.setValue(30, animated: true)
            number_lbl.text = "30 Seconds"
            // The Start button is now visible
            start_outlet.isHidden = false
            // The Slider button is now visible
            slider_outlet.isHidden = false
            // the sound plays
            audioPlayer.play()
            // the notification gets sent to the phone one second after the timer reaches zero
            // alert is also its own func
            alert(inSeconds: 1)
        }
    }
    
        // Creates the Notification
        func alert(inSeconds: TimeInterval) {
        let info = UNMutableNotificationContent()
        // creates the title of the notification
        info.title = "The " + number + " seconds are up!"
        // creates the body of the notification
        info.body = "Your Done"
        // the number that displays on top of the app
        info.badge = 1
        // creates the trigger that causes the notification
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
        // creates the object of the notification
        let request = UNNotificationRequest(identifier: "TimerDone", content: info, trigger: trigger)
        // sends the object to the NotificationCenter of the User Iphone
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    // func handles when user clicks the stop button
    @IBAction func Stop_Btn(_ sender: Any) {
        // the timer stops
        timer.invalidate()
        seconds = 30
        // the sound stops
        audioPlayer.stop()
        // set the value back to 30
        slider_outlet.setValue(30, animated: true)
        // the label is set to 30 seconds
        number_lbl.text = "30 Seconds"
        // the start button is now visible
        start_outlet.isHidden = false
        // the slider button is now visible
        slider_outlet.isHidden = false
    }
}

