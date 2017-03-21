//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by admin on 9/6/16.
//  Copyright © 2016 Jett Raines. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var startRecordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View will appear called")
    }
    
    @IBAction func recordAudio(_ sender: AnyObject) {
        setUIState(isRecording: true, recordingText: recordingLabel.text!)
        prepareAudio()
    }
  
    @IBAction func haltAudio(_ sender: Any) {
        setUIState(isRecording: false, recordingText: recordingLabel.text!)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool){
        if flag {
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not sucessful")
        }
    }
    
    // Refactored Code from previous lines
    func setUIState(isRecording: Bool, recordingText: String){
        recordingLabel.text = (isRecording) ? "Recording in Progress" : "Tap to Record"
        startRecordingButton.isEnabled = !isRecording
        stopRecordingButton.isEnabled = isRecording
    }
    
    func prepareAudio(){
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print("\(filePath)")
        
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
}
// Segue Method
extension RecordSoundsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}
