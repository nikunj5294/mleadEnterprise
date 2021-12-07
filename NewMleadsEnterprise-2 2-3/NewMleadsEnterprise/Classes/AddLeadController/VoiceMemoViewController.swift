//
//  VoiceMemoViewController.swift
//  NewMleadsEnterprise
//
//  Created by MAC on 25/04/21.
//  Copyright © 2021 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import AVFoundation

protocol passLeadVoiceMemoDelegate {
    func passVoiceMemo(data:Data)
}

class VoiceMemoViewController: UIViewController {

    @IBOutlet weak var viewRoundedObj: UIView!
    @IBOutlet weak var imgVoiceRecording: UIImageView!
    @IBOutlet weak var imgSpeakPlay: UIImageView!

    var audioPlayer : AVAudioPlayer?

    var delegateVoiceMemo:passLeadVoiceMemoDelegate?
    
    var dataAudioObj = Data()

    //Variables
       var audioRecorder: AVAudioRecorder!
       var meterTimer:Timer!
       var gifTimer = Timer()
        var imgTag = 1
       var isAudioRecordingGranted: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAudioSettings()
    
        DispatchQueue.main.async {
            self.shaddowSet()
        }
        self.navigationItem.title = "Voice Memo"

        // Do any additional setup after loading the view.
    }
    
    func shaddowSet() {

        viewRoundedObj.layer.masksToBounds = false
        viewRoundedObj.layer.cornerRadius = 10
        viewRoundedObj.layer.shadowColor = UIColor.black.cgColor
        viewRoundedObj.layer.shadowPath = UIBezierPath(roundedRect: viewRoundedObj.bounds, cornerRadius: viewRoundedObj.layer.cornerRadius).cgPath
        viewRoundedObj.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        viewRoundedObj.layer.shadowOpacity = 0.5
        viewRoundedObj.layer.shadowRadius = 5.0
        
    }
    
    func setupAudioSettings() {
        
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
                   isAudioRecordingGranted = true
                   break
        case AVAudioSession.RecordPermission.denied:
                   isAudioRecordingGranted = false
                   break
        case AVAudioSession.RecordPermission.undetermined:
                   AVAudioSession.sharedInstance().requestRecordPermission() { [unowned self] allowed in
                       DispatchQueue.main.async {
                           if allowed {
                               self.isAudioRecordingGranted = true
                           } else {
                               self.isAudioRecordingGranted = false
                           }
                       }
                   }
                   break
               default:
                   break
               }
        
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        delegateVoiceMemo?.passVoiceMemo(data: self.dataAudioObj)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func playAudioRecorderAction(_ sender: UIButton) {
        
        if audioRecorder?.isRecording == false{
             imgSpeakPlay.image = UIImage(named: "speak_play_icon33")
                var error : NSError?
                
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: (audioRecorder?.url)!)
                } catch {
                    print(error)
                }
                
                audioPlayer?.delegate = self
                
                if let err = error{
                    print("audioPlayer error: \(err.localizedDescription)")
                }else{
                    audioPlayer?.play()
                }
                
            }
        }
        
        @IBAction func audioRecorderAction(_ sender: UIButton) {
            playAudioClicked()
        }
        
        func playAudioClicked()  {
            
            if isAudioRecordingGranted {
                
                if audioRecorder?.isRecording == true{
                    audioRecorder?.stop()
                    meterTimer.invalidate()
                    gifTimer.invalidate()
                    imgVoiceRecording.image = UIImage(named: "speak_icon_non_movment")
                    
                    DispatchQueue.main.async {
                            do {
                                let imageData = try Data(contentsOf: self.audioRecorder.url)
                                self.dataAudioObj = imageData
                                print("Audio Data : \(imageData)")
                            } catch {
                                print("Unable to load data: \(error)")
                            }
                        
                        
                    }
                    
                }else{
                    //Create the session.
                    imgTag = 1
                    gifTimer = Timer.scheduledTimer(timeInterval: 0.5, target:self, selector:#selector(self.changeRecordImages), userInfo:nil, repeats:true)
                    
                    let session = AVAudioSession.sharedInstance()
                    
                    do {
                        //Configure the session for recording and playback.
                        try session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
                        try session.setActive(true)
                        //Set up a high-quality recording session.
                        let settings = [
                            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                            AVSampleRateKey: 44100,
                            AVNumberOfChannelsKey: 2,
                            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                        ]
                        //Create audio file name URL
                        let audioFilename = getDocumentsDirectory().appendingPathComponent("audioRecording.m4a")
                        //Create the audio recording, and assign ourselves as the delegate
                        audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
                        audioRecorder.delegate = self
                        audioRecorder.isMeteringEnabled = true
                        audioRecorder.record()
                        meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
                    }
                    catch let error {
                        print("Error for start audio recording: \(error.localizedDescription)")
                    }
                }
            }
            
        }
        
        @objc func changeRecordImages() {
            
            switch imgTag {
            case 1:
                imgVoiceRecording.image = UIImage(named: "speak_m_icon_1")
                imgTag = 2
            case 2:
                imgVoiceRecording.image = UIImage(named: "speak_m_icon_2")
                imgTag = 3
            case 3:
                imgVoiceRecording.image = UIImage(named: "speak_m_icon_3")
                imgTag = 1
            default:
                print("")
            }
            
            
        }
        
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
    }


extension VoiceMemoViewController : AVAudioRecorderDelegate, AVAudioPlayerDelegate{
    
    
    func finishAudioRecording(success: Bool) {

           audioRecorder.stop()
           audioRecorder = nil
           meterTimer.invalidate()

           if success {
               print("Recording finished successfully.")
           } else {
               print("Recording failed :(")
           }
       }

    @objc func updateAudioMeter(timer: Timer) {

           if audioRecorder.isRecording {
               let hr = Int((audioRecorder.currentTime / 60) / 60)
               let min = Int(audioRecorder.currentTime / 60)
               let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
               let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
                print(totalTimeString)
//               recordingTimeLabel.text = totalTimeString
               audioRecorder.updateMeters()
           }
       }

       func getDocumentsDirectory() -> URL {

           let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
           let documentsDirectory = paths[0]
           return documentsDirectory
       }

       //MARK:- Audio recoder delegate methods
       func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {

           if !flag {
               finishAudioRecording(success: false)
           }
       }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        audioPlayer?.stop()
        imgSpeakPlay.image = UIImage(named: "speak_play_icon3-Recovered")
    }
    
}
