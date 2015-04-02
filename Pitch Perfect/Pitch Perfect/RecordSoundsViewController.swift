//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Игорь Боляев on 23.03.15.
//  Copyright (c) 2015 Igor Bolyaev. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
   

    @IBOutlet weak var recordingLabel: UILabel!
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var micButton: UIButton!
   
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBOutlet weak var continueRecording: UIButton!
   
    
    var audioRecorder : AVAudioRecorder!
    var recordAudio: RecordedAudio!
    
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        micButton.enabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // function stop the recording and changes the label of the recording button
    @IBAction func stop(sender: UIButton) {
        
        self.recordingLabel.text = "Tap to Record"
        pauseButton.hidden =  true
        continueRecording.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }

   
    
    // Continue the recoring process after pause and changes buttons attributes to enable pause button and disable continue button
    @IBAction func continueRecordAudio(sender: AnyObject) {
        
        audioRecorder.prepareToRecord()
        
        audioRecorder.record()
        continueRecording.enabled = false
        pauseButton.enabled = true
        
    }
    // Pauses the curret recording process and changes buttons attributes to disable pause button and enable continue button
    @IBAction func pauseAudio(sender: UIButton) {
        
        audioRecorder.pause()
        continueRecording.enabled = true
        pauseButton.enabled = false
    }
    // Starts the recording process, creaate a file with name curret date and time, saves to default document directory
    // saves delegate to self for a future method call audioRecorderDidFinishRecording
    @IBAction func recordAudio(sender: UIButton) {
        
        
        recordingLabel.hidden = false
        self.recordingLabel.text = "Recording..."
        stopButton.hidden = false
        micButton.enabled = false
        pauseButton.hidden =  false
        continueRecording.hidden = false
        continueRecording.enabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
       
        audioRecorder.record()

    }
    // Starts according to audioRecorder delegate, when audioRecorder stop the recording process.
    // Saves url of created file to RecordAudio class and sends to another screen
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if flag{
        
            recordAudio = RecordedAudio(filePathUrl: recorder.url,title: recorder.url.lastPathComponent!)
    
            
                self.performSegueWithIdentifier("stopRecording", sender: recordAudio)
        }else
        {
            println("Recording was not succesfull")
            stopButton.hidden = true
            micButton.enabled = true
        }
        
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording")
        {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
            
        }
    }
    
    
}

