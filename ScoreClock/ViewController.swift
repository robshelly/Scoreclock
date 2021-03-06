//
//  ViewController.swift
//  ScoreClock
//
//  Created by admin on 12/04/2018.
//  Copyright © 2018 WIT. All rights reserved.
//


//Turorials used:
// Basic Stopwatch funtionality
// https://medium.com/ios-os-x-development/build-an-stopwatch-with-swift-3-0-c7040818a10f
// Sending Tweets
// https://www.youtube.com/watch?v=B_x-ccc8Iuc
// Segue
// https://www.youtube.com/watch?v=XjBqKaGiZws
// https://stackoverflow.com/a/42856839

import UIKit
import AVFoundation

var game: Game!
var gameTime:TimeInterval = 1200
var gameClock:Timer = Timer()
var isPlaying:Bool = false
var currentPeriod:String = "1"
var soundsEffect: AVAudioPlayer?
var sounds:Bool = false
var periods:[String] = ["1", "2", "3", "OT"]
var goalBtns:[UIButton]!

var homePenaltyOneTime: TimeInterval = 0
var homePenaltyTwoTime: TimeInterval = 0
var awayPenaltyOneTime: TimeInterval = 0
var awayPenaltyTwoTime: TimeInterval = 0


class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var timeLabel: UIButton!
    
    @IBOutlet weak var homeGoalLabel: UIButton!
    @IBOutlet weak var awayGoalLabel: UIButton!
    
    @IBOutlet weak var homePenaltyOne: UIButton!
    @IBOutlet weak var homePenaltyTwo: UIButton!
    @IBOutlet weak var awayPenaltyOne: UIButton!
    @IBOutlet weak var awayPenaltyTwo: UIButton!
    
    @IBOutlet weak var periodPicker: UIPickerView!
    @IBOutlet weak var sound: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialise Game
        game = Game()
        
        // Format Game clock
        timeLabel.setTitle(Utilities.timeString(time: gameTime), for: .normal)
        
        // Initialise Penalties
        intialisePenalties()
        
        // Format some UI elements
        formatBtnLabels()
        updateGoalLabels()
        
        // Add actions for tap and hold to buttons
        addButtonActions()

        periodPicker.delegate = self
        periodPicker.dataSource = self
        sound.setImage(UIImage(named:"soundOff.png"), for: .normal)

        
        goalBtns = [homeGoalLabel, awayGoalLabel]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        periodPicker.backgroundColor = UIColor.black
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return periods[row]
    }
    
    // Customiszing Pickerview
    // https://stackoverflow.com/a/47073330
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view {
            label = v as! UILabel
        }
        label.font = UIFont (name: "Digital-7", size: 64)
        label.textColor = UIColor.yellow
        label.text =  periods[row]
        label.textAlignment = .center
        return label
    }
    
    //Change pickerview line size
    // https://makeapppie.com/2014/10/21/swift-swift-formatting-a-uipickerview/
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 64.0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentPeriod = periods[row]
    }
    
    func addButtonActions() {
        // Single button with two actions for tap and hold
        // https://stackoverflow.com/a/30859297
        // https://stackoverflow.com/a/36160191
        // Execute only once on long press
        // https://www.ioscreator.com/tutorials/long-press-gesture-ios-tutorial-ios11
        
        addHomeGoalActions()
        addAwayGoalActions()
        addHomePenaltyOneActions()
        addHomePenaltyTwoActions()
        addAwayPenaltyOneActions()
        addAwayPenaltyTwoActions()
        addTimeActions()
    }
    
    func addHomeGoalActions() {
        let tapHomeGoal = UITapGestureRecognizer(target: self, action: #selector(self.scoreHomeGoal))
        let holdHomeGoal = UILongPressGestureRecognizer(target: self, action: #selector(self.deleteHomeGoal))
        homeGoalLabel.addGestureRecognizer(tapHomeGoal)
        homeGoalLabel.addGestureRecognizer(holdHomeGoal)
    }
    
    func addAwayGoalActions() {
        let tapAwayGoal = UITapGestureRecognizer(target: self, action: #selector(self.scoreAwayGoal))
        let holdAwayGoal = UILongPressGestureRecognizer(target: self, action: #selector(self.deleteAwayGoal))
        awayGoalLabel.addGestureRecognizer(tapAwayGoal)
        awayGoalLabel.addGestureRecognizer(holdAwayGoal)
    }
    
    func addTimeActions() {
        let tapTime = UITapGestureRecognizer(target: self, action: #selector(self.toggleClock))
        let holdTime = UILongPressGestureRecognizer(target: self, action: #selector(self.setClock))
        timeLabel.addGestureRecognizer(tapTime)
        timeLabel.addGestureRecognizer(holdTime)
    }
    
    func addHomePenaltyOneActions() {
        let tapHomePenaltyOne = UITapGestureRecognizer(target: self, action: #selector(self.addHomePenaltyOne))
        let holdHomePenaltyOne = UILongPressGestureRecognizer(target: self, action: #selector(self.deleteHomePenaltyOne))
        homePenaltyOne.addGestureRecognizer(tapHomePenaltyOne)
        homePenaltyOne.addGestureRecognizer(holdHomePenaltyOne)
    }
    
    func addHomePenaltyTwoActions() {
        let tapHomePenaltyTwo = UITapGestureRecognizer(target: self, action: #selector(self.addHomePenaltyTwo))
        let holdHomePenaltyTwo = UILongPressGestureRecognizer(target: self, action: #selector(self.deleteHomePenaltyTwo))
        homePenaltyTwo.addGestureRecognizer(tapHomePenaltyTwo)
        homePenaltyTwo.addGestureRecognizer(holdHomePenaltyTwo)
    }
    
    func addAwayPenaltyOneActions() {
        let tapAwayPenaltyOne = UITapGestureRecognizer(target: self, action: #selector(self.addAwayPenaltyOne))
        let holdAwayPenaltyOne = UILongPressGestureRecognizer(target: self, action: #selector(self.deleteAwayPenaltyOne))
        awayPenaltyOne.addGestureRecognizer(tapAwayPenaltyOne)
        awayPenaltyOne.addGestureRecognizer(holdAwayPenaltyOne)
    }
    
    func addAwayPenaltyTwoActions() {
        let tapAwayPenaltyTwo = UITapGestureRecognizer(target: self, action: #selector(self.addAwayPenaltyTwo))
        let holdAwayPenaltyTwo = UILongPressGestureRecognizer(target: self, action: #selector(self.deleteAwayPenaltyTwo))
        awayPenaltyTwo.addGestureRecognizer(tapAwayPenaltyTwo)
        awayPenaltyTwo.addGestureRecognizer(holdAwayPenaltyTwo)
    }
    
    @objc func addHomePenaltyOne() {
        let alert = UIAlertController(title: "Set Penalty Minutes", message: "Set period time (minutes)", preferredStyle: .alert)
        
        alert.addTextField { (minutes) in
            minutes.text = "2"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let minutes = alert?.textFields![0].text // Force unwrapping because we know it exists.
            // Gettings Doubl from optional string
            // https://stackoverflow.com/a/46989179
            guard let minutesString = minutes else { return }
            let mins = Double(minutesString)
            if (mins != nil) {
                homePenaltyOneTime = mins! * 60
                self.homePenaltyOne.setTitle(Utilities.timeString(time: homePenaltyOneTime), for: .normal)
            } else {
                print("Invalid input")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            // Do nothing if cancelled
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func addHomePenaltyTwo() {
        let alert = UIAlertController(title: "Set Penalty Minutes", message: "Set period time (minutes)", preferredStyle: .alert)
        
        alert.addTextField { (minutes) in
            minutes.text = "2"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let minutes = alert?.textFields![0].text // Force unwrapping because we know it exists.
            // Gettings Doubl from optional string
            // https://stackoverflow.com/a/46989179
            guard let minutesString = minutes else { return }
            let mins = Double(minutesString)
            if (mins != nil) {
                homePenaltyTwoTime = mins! * 60
                self.homePenaltyTwo.setTitle(Utilities.timeString(time: homePenaltyTwoTime), for: .normal)
            } else {
                print("Invalid input")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            // Do nothing if cancelled
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func addAwayPenaltyOne() {
        let alert = UIAlertController(title: "Set Penalty Minutes", message: "Set period time (minutes)", preferredStyle: .alert)
        
        alert.addTextField { (minutes) in
            minutes.text = "2"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let minutes = alert?.textFields![0].text // Force unwrapping because we know it exists.
            // Gettings Doubl from optional string
            // https://stackoverflow.com/a/46989179
            guard let minutesString = minutes else { return }
            let mins = Double(minutesString)
            if (mins != nil) {
                awayPenaltyOneTime = mins! * 60
                self.awayPenaltyOne.setTitle(Utilities.timeString(time: awayPenaltyOneTime), for: .normal)
            } else {
                print("Invalid input")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            // Do nothing if cancelled
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func addAwayPenaltyTwo() {
        let alert = UIAlertController(title: "Set Penalty Minutes", message: "Set period time (minutes)", preferredStyle: .alert)
        
        alert.addTextField { (minutes) in
            minutes.text = "2"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let minutes = alert?.textFields![0].text // Force unwrapping because we know it exists.
            // Gettings Doubl from optional string
            // https://stackoverflow.com/a/46989179
            guard let minutesString = minutes else { return }
            let mins = Double(minutesString)
            if (mins != nil) {
                awayPenaltyTwoTime = mins! * 60
                self.awayPenaltyTwo.setTitle(Utilities.timeString(time: awayPenaltyTwoTime), for: .normal)
            } else {
                print("Invalid input")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            // Do nothing if cancelled
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func deleteHomePenaltyOne() {
        homePenaltyOneTime = 0
        homePenaltyOne.setTitle(Utilities.timeString(time: homePenaltyOneTime), for: .normal)
    }
    
    @objc func deleteHomePenaltyTwo() {
        homePenaltyTwoTime = 0
        homePenaltyTwo.setTitle(Utilities.timeString(time: homePenaltyTwoTime), for: .normal)
    }
    
    @objc func deleteAwayPenaltyOne() {
        awayPenaltyOneTime = 0
        awayPenaltyOne.setTitle(Utilities.timeString(time: awayPenaltyOneTime), for: .normal)
    }
    
    @objc func deleteAwayPenaltyTwo() {
        awayPenaltyTwoTime = 0
        awayPenaltyTwo.setTitle(Utilities.timeString(time: awayPenaltyTwoTime), for: .normal)
    }
    
    @objc func scoreHomeGoal() {
        if sounds { playGoalHorn() }
        performSegue(withIdentifier: "goal", sender: homeGoalLabel)
    }
    
    @objc func deleteHomeGoal(gesture: UILongPressGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.began {
            deleteGoal(team: "home")
        }
    }
    
    @objc func scoreAwayGoal() {
        if sounds { playGoalHorn() }
        performSegue(withIdentifier: "goal", sender: awayGoalLabel)
    }
    
    @objc func deleteAwayGoal(gesture: UILongPressGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.began {
            deleteGoal(team: "away")
        }
    }
    
    func deleteGoal(team: String) {
        if team == "home" {
            if game.homeGoals.count > 0 { game.homeGoals.removeLast() }
        } else {
            if game.awayGoals.count > 0 { game.awayGoals.removeLast() }
        }
        updateGoalLabels()
    }
    
    @objc func setClock(gesture: UILongPressGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.began {
            // User input from alert box
            // https://stackoverflow.com/a/26567485
            let alert = UIAlertController(title: "Set Time", message: "Set period time (minutes)", preferredStyle: .alert)

            alert.addTextField { (minutes) in
                minutes.text = "20"
            }
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let minutes = alert?.textFields![0].text // Force unwrapping because we know it exists.
                // Gettings Doubl from optional string
                // https://stackoverflow.com/a/46989179
                guard let minutesString = minutes else { return }
                let mins = Double(minutesString)
                if (mins != nil) {
                    self.setGameClock(time: mins!)
                } else {
                    print("Invalid input")
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func toggleClock() {
        if isPlaying {
            gameClock.invalidate()
            isPlaying = false
        } else {
            gameClock = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
            isPlaying = true
        }
    }
    
    func setBorderColours() {
        // Can't set border colour of buttons in User Defined Attributes so set here instead
        // See https://stackoverflow.com/a/15010440
        // Other border attributes set in User Defined Runtime Attributes
        // https://stackoverflow.com/a/30091664
        for btn in [
            timeLabel,
            homeGoalLabel,
            awayGoalLabel,
            homePenaltyOne,
            homePenaltyTwo,
            awayPenaltyOne,
            awayPenaltyTwo
        ] {
            btn?.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    func formatBtnLabels() {
        let btnLabels:[UILabel] = [
            timeLabel.titleLabel!,
            homeGoalLabel.titleLabel!,
            awayGoalLabel.titleLabel!,
            homePenaltyOne.titleLabel!,
            homePenaltyTwo.titleLabel!,
            awayPenaltyOne.titleLabel!,
            awayPenaltyTwo.titleLabel!
        ]
        for lbl in btnLabels {
            lbl.numberOfLines = 1
            lbl.adjustsFontSizeToFitWidth = true
            lbl.baselineAdjustment = .alignCenters
            lbl.lineBreakMode = NSLineBreakMode.byClipping;
            // set font very big and it will be scaled down to fit
            // if it's set smaller (therefore already fits) it won't scale up
            lbl.font = UIFont(name:"Digital-7Mono", size: 200)
        }
        setBorderColours()
    }
    
    func updateGoalLabels() {
        homeGoalLabel.setTitle(String(format: "%02d", game.homeGoals.count), for: .normal)
        awayGoalLabel.setTitle(String(format: "%02d", game.awayGoals.count), for: .normal)
    }
    
    func setGameClock(time: TimeInterval) {
        gameClock.invalidate()
        gameTime = time * 60
        timeLabel.setTitle(Utilities.timeString(time: gameTime), for: .normal)
    }
    
    func intialisePenalties() {
        homePenaltyOne.setTitle(Utilities.timeString(time: 0), for: UIControlState.normal)
        homePenaltyTwo.setTitle(Utilities.timeString(time: 0), for: UIControlState.normal)
        awayPenaltyOne.setTitle(Utilities.timeString(time: 0), for: UIControlState.normal)
        awayPenaltyTwo.setTitle(Utilities.timeString(time: 0), for: UIControlState.normal)
    }
    
    func playPeriodEndHorn() {
        // Play Sounds with AVFoundation
        // https://www.hackingwithswift.com/example-code/media/how-to-play-sounds-using-avaudioplayer
        let path = Bundle.main.path(forResource: "PeriodHorn.m4a", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        do {
            soundsEffect = try AVAudioPlayer(contentsOf: url)
            soundsEffect?.play()
        } catch {
            // No file... ok just no sounds
        }
    }
    
    func playGoalHorn() {
        // Play Sounds with AVFoundation
        // https://www.hackingwithswift.com/example-code/media/how-to-play-sounds-using-avaudioplayer
        let path = Bundle.main.path(forResource: "GoalHorn.m4a", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        do {
            soundsEffect = try AVAudioPlayer(contentsOf: url)
            soundsEffect?.play()
        } catch {
            // No file... ok just no sounds
        }
    }
    
    @objc func UpdateTimer() {
        gameTime -= 1
        
        if (homePenaltyOneTime > 0) { updateHomePenaltyOneTime() }
        if (homePenaltyTwoTime > 0) { updateHomePenaltyTwoTime() }
        if (awayPenaltyOneTime > 0) { updateAwayPenaltyOneTime() }
        if (awayPenaltyTwoTime > 0) { updateAwayPenaltyTwoTime() }
        
        
        if gameTime == 0 {
            gameClock.invalidate()
            if sounds { playPeriodEndHorn() }
        }
        
        // Prevent button flashing when text updates
        // https://stackoverflow.com/a/39071660
        UIView.performWithoutAnimation {
            timeLabel.setTitle(Utilities.timeString(time: gameTime), for: .normal)
            timeLabel.layoutIfNeeded()
        }
    }
    
    func updateHomePenaltyOneTime() {
        homePenaltyOneTime -= 1
        UIView.performWithoutAnimation {
            homePenaltyOne.setTitle(Utilities.timeString(time: homePenaltyOneTime), for: .normal)
            homePenaltyOne.layoutIfNeeded()
        }
    }
    
    func updateHomePenaltyTwoTime() {
        homePenaltyTwoTime -= 1
        UIView.performWithoutAnimation {
            homePenaltyTwo.setTitle(Utilities.timeString(time: homePenaltyTwoTime), for: .normal)
            homePenaltyTwo.layoutIfNeeded()
        }
    }
    
    func updateAwayPenaltyOneTime() {
        awayPenaltyOneTime -= 1
        UIView.performWithoutAnimation {
            awayPenaltyOne.setTitle(Utilities.timeString(time: awayPenaltyOneTime), for: .normal)
            awayPenaltyOne.layoutIfNeeded()
        }
    }
    
    func updateAwayPenaltyTwoTime() {
        awayPenaltyTwoTime -= 1
        UIView.performWithoutAnimation {
            awayPenaltyTwo.setTitle(Utilities.timeString(time: awayPenaltyTwoTime), for: .normal)
            awayPenaltyTwo.layoutIfNeeded()
        }
    }
    
    @IBAction func newGame(_ sender: Any) {
        game = Game()
        gameClock.invalidate()
        setGameClock(time: 20)
        updateGoalLabels()
        periodPicker.selectRow(0, inComponent: 0, animated: false)
        
        homePenaltyOneTime = 0
        homePenaltyTwoTime = 0
        awayPenaltyOneTime = 0
        awayPenaltyTwoTime = 0
        
        homePenaltyOne.setTitle(Utilities.timeString(time: homePenaltyOneTime), for: .normal)
        homePenaltyTwo.setTitle(Utilities.timeString(time: homePenaltyTwoTime), for: .normal)
        awayPenaltyOne.setTitle(Utilities.timeString(time: awayPenaltyOneTime), for: .normal)
        awayPenaltyTwo.setTitle(Utilities.timeString(time: awayPenaltyTwoTime), for: .normal)
    }
    
    @IBAction func toggleSound(_ sender: Any) {
        sounds = !sounds
        if sounds {
            sound.setImage(UIImage(named:"soundOn.png"), for: .normal)
        } else {
            sound.setImage(UIImage(named:"soundOff.png"), for: .normal)
        }
        print("Sound on: \(sounds)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let goalVC = segue.destination as? GoalVC else { return }
        goalVC.scoringTeam = "home"
        if (sender as! UIButton) == self.homeGoalLabel {
            goalVC.scoringTeam = "home"
        } else {
            goalVC.scoringTeam = "away"
        }
    }
    
    @IBAction func didUnwindFromGoalVc(_ sender: UIStoryboardSegue) {
        updateGoalLabels()
    }
}


