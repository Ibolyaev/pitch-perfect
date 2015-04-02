//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Игорь Боляев on 26.03.15.
//  Copyright (c) 2015 Igor Bolyaev. All rights reserved.
//

import UIKit
import AVFoundation


class PlaySoundsViewController: UIViewController {

    
    var audioPlayer: AVAudioPlayer!
    var playerNode: AVAudioNode!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    var audioPlayerForEcho:AVAudioPlayer!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        
        audioPlayerForEcho = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func slowButtonPressed(sender: UIButton) {
        
        stopAllPlayback()
        
        audioPlayer.enableRate = true
        audioPlayer.rate = 0.5
        audioPlayer.play()
        
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        
        playAudioWithVariablePitch(1000)
        
    }
    
    @IBAction func darthvaderAudio(sender: UIButton) {
        
        playAudioWithVariablePitch(-1000)
        
    }
    
    @IBAction func echoAudio(sender: UIButton) {
        
        stopAllPlayback()
        
        audioPlayer.play()
        
        let delay:NSTimeInterval = 0.2
        var playtime:NSTimeInterval
        playtime = audioPlayerForEcho.deviceCurrentTime + delay
        
        audioPlayerForEcho.volume = 0.8
        audioPlayerForEcho.playAtTime(playtime)
        
    }
    @IBAction func fastButtonPressed(sender: UIButton) {
        
        stopAllPlayback()
        
        audioPlayer.enableRate = true
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = 1.5
        audioPlayer.play()
    }

    @IBAction func stopButtonPressed(sender: UIButton) {
        stopAllPlayback()
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        
       
        stopAllPlayback()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    // Function stop all of audioEngine and audioplayer's to prevent overlaping
    func stopAllPlayback() {
        
        audioPlayerForEcho.stop()
        audioPlayerForEcho.currentTime = 0.0
        
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        
        audioEngine.stop()
        audioEngine.reset()
        
        
    }
    
    
    
}
