//
//  SpeakViewController.swift
//  NewMleadsEnterprise
//
//  Created by MAC on 22/03/21.
//  Copyright © 2021 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import Speech
import AVKit

class SpeakViewController: UIViewController {

    @IBOutlet weak var viewMircophoneMain: UIView!
    
    @IBOutlet weak var imgMicrophone: UIImageView!
    
    @IBOutlet weak var viewSpeakMain: UIView!
    @IBOutlet weak var viewSpeakSubview: UIView!
    
    @IBOutlet weak var viewMicrophone: UIView!
    @IBOutlet weak var imgMicroPhone: UIImageView!
    
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtDomain: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    
    
    
    
    
    let speechRecognizer        = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    var recognitionRequest      : SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask         : SFSpeechRecognitionTask?
    let audioEngine             = AVAudioEngine()

    var strSpeechText = ""
    var selectedIndex = 0
    var gifTimer = Timer()
    var imgTag = 1
    
    // MARK: - ------------------------------------------------------------------------------

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "ADD Lead"
        viewMircophoneMain.layer.cornerRadius = viewMircophoneMain.frame.size.width/2
        viewMircophoneMain.layer.borderWidth = 2
        viewMircophoneMain.layer.borderColor = UIColor.black.cgColor
        imgMicrophone.layer.cornerRadius = imgMicrophone.frame.size.width/2
        imgMicrophone.layer.borderWidth = 2
        imgMicrophone.layer.borderColor = UIColor.black.cgColor
        
        viewSpeakSubview.layer.cornerRadius = 10
        viewMicrophone.layer.cornerRadius =  viewMicrophone.frame.size.width/2
        imgMicroPhone.layer.cornerRadius =  imgMicroPhone.frame.size.width/2
        imgMicroPhone.layer.borderWidth = 1
        imgMicroPhone.layer.borderColor = UIColor.gray.cgColor
        
        setupSpeech()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.audioEngine.stop()
        self.recognitionRequest?.endAudio()
        viewSpeakMain.isHidden = true
    }
    
    
    // MARK: - ------------------------------------------------------------------------------

    
    @IBAction func btnSpeakClicked(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            print("0")
        case 1:
            print("1")
        case 2:
            print("2")
        case 3:
            print("3")
        default:
            print("1")
        }
        self.view.endEditing(true)
        selectedIndex = sender.tag
        startRecording()
        viewSpeakMain.isHidden = false
        gifTimer = Timer.scheduledTimer(timeInterval: 0.5, target:self, selector:#selector(self.changeRecordImages), userInfo:nil, repeats:true)

    }
    
    @IBAction func btnContinueCancelClicked(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            print("0")
            let strEmail = (txtEmail.text! + "@" + txtDomain.text!).trimmingCharacters(in: .whitespaces)
            let strPhone = txtPhone.text!.trimmingCharacters(in: .whitespaces)
            let strFirstName = txtFirstName.text!.trimmingCharacters(in: .whitespaces)
            print(strPhone)
            print(strFirstName)
            print(strEmail)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScanBusinessLeadViewController") as! ScanBusinessLeadViewController
            vc.strLeadType = "1"
            vc.strName = strFirstName
            vc.strEmail = strEmail
            vc.strPhone = strPhone
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            print("1")
        default:
            print("1")
        }
    }
    
    
    @IBAction func btnOkSpeakClicked(_ sender: Any) {
        self.audioEngine.stop()
        self.recognitionRequest?.endAudio()
        viewSpeakMain.isHidden = true
        gifTimer.invalidate()
        imgMicroPhone.image = UIImage(named: "speak_icon_non_movment")
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
            switch self.selectedIndex {
            case 0:
                self.txtFirstName.text = self.strSpeechText
                print("0")
            case 1:
                self.txtEmail.text = self.strSpeechText
                print("1")
            case 2:
                self.txtDomain.text = self.strSpeechText
                print("2")
            case 3:
                self.txtPhone.text = self.strSpeechText
                print("3")
            default:
                print("1")
            }
        }
        
        
        
    }
    
    @IBAction func btnCancelSpeakClicked(_ sender: Any) {
        self.audioEngine.stop()
        self.recognitionRequest?.endAudio()
        viewSpeakMain.isHidden = true
        gifTimer.invalidate()
        imgMicroPhone.image = UIImage(named: "speak_icon_non_movment")
    }
    
    @IBAction func btnStartSpeechToText(_ sender: UIButton) {

            if audioEngine.isRunning {
                self.audioEngine.stop()
                self.recognitionRequest?.endAudio()
                print("Start Recording")
//                self.btnStart.isEnabled = false
//                self.btnStart.setTitle("Start Recording", for: .normal)
            } else {
                self.startRecording()
                print("Stop Recording")
//                self.btnStart.setTitle("Stop Recording", for: .normal)
            }
        }

    
    // MARK: - ------------------------------------------------------------------------------

    
    func setupSpeech() {

//            self.btnStart.isEnabled = false
            self.speechRecognizer?.delegate = self

            SFSpeechRecognizer.requestAuthorization { (authStatus) in

                var isButtonEnabled = false

                switch authStatus {
                case .authorized:
                    isButtonEnabled = true
                    print("Autherized user for speech")
                case .denied:
                    isButtonEnabled = false
                    print("User denied access to speech recognition")

                case .restricted:
                    isButtonEnabled = false
                    print("Speech recognition restricted on this device")

                case .notDetermined:
                    isButtonEnabled = false
                    print("Speech recognition not yet authorized")
                }

                OperationQueue.main.addOperation() {
//                    self.btnStart.isEnabled = isButtonEnabled
                }
            }
        }

        //------------------------------------------------------------------------------

        func startRecording() {

            // Clear all previous session data and cancel task
            if recognitionTask != nil {
                recognitionTask?.cancel()
                recognitionTask = nil
            }

            // Create instance of audio session to record voice
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.measurement, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
                try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            } catch {
                print("audioSession properties weren't set because of an error.")
            }

            self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

            let inputNode = audioEngine.inputNode

            guard let recognitionRequest = recognitionRequest else {
                fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
            }

            recognitionRequest.shouldReportPartialResults = true

            self.recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in

                var isFinal = false

                if result != nil {
                    self.strSpeechText = result?.bestTranscription.formattedString ?? ""
                    print("Recording Result : \(result?.bestTranscription.formattedString)")
//                    self.lblText.text =
                    isFinal = (result?.isFinal)!
                }

                if error != nil || isFinal {

                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)

                    self.recognitionRequest = nil
                    self.recognitionTask = nil

//                    self.btnStart.isEnabled = true
                }
            })

            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
                self.recognitionRequest?.append(buffer)
            }

            self.audioEngine.prepare()

            do {
                try self.audioEngine.start()
            } catch {
                print("audioEngine couldn't start because of an error.")
            }

            print("Say something, I'm listening!")
        }

    
    @objc func changeRecordImages() {
        
        switch imgTag {
        case 1:
            imgMicroPhone.image = UIImage(named: "speak_m_icon_1")
            imgTag = 2
        case 2:
            imgMicroPhone.image = UIImage(named: "speak_m_icon_2")
            imgTag = 3
        case 3:
            imgMicroPhone.image = UIImage(named: "speak_m_icon_3")
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

extension SpeakViewController: SFSpeechRecognizerDelegate {

    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            print("speechRecognizer Available")
//            self.btnStart.isEnabled = true
        } else {
            print("speechRecognizer Not Available")
//            self.btnStart.isEnabled = false
        }
    }
}
