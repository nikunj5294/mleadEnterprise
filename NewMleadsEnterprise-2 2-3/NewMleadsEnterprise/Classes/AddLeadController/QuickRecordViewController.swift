//
//  QuickRecordViewController.swift
//  NewMleadsEnterprise
//
//  Created by MAC on 24/03/21.
//  Copyright © 2021 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import AVFoundation
import NVActivityIndicatorView
import Alamofire

class QuickRecordViewController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var viewRoundedObj: UIView!
    @IBOutlet weak var imgVoiceRecording: UIImageView!
    @IBOutlet weak var imgSpeakPlay: UIImageView!
    @IBOutlet weak var lblTeamMember: UILabel!
    
    @IBOutlet weak var btnEventList: UIButton!
    
    
    var audioPlayer : AVAudioPlayer?
    
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    
    var arrTeamName = [String]()
    var arrTeamCreatedTiemStemp = [String]()
    var arrTempReportsTo = NSMutableArray()
    var arrEventList = NSMutableArray()
    var arrEventName = [String]()
    var dataAudioObj = Data()

    var selectedIndexForEventIndex = Int()


    //Variables
       var audioRecorder: AVAudioRecorder!
       var meterTimer:Timer!
       var gifTimer = Timer()
        var imgTag = 1
       var isAudioRecordingGranted: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Quick Record"
        
        setupAudioSettings()
    
        DispatchQueue.main.async {
            self.shaddowSet()
        }
        
        callWebService(TypeId: objLoginUserDetail.userId!, selectedId: "")

        // Do any additional setup after loading the view.
    }
    
    
    //MARK: Webservices Custom Function Call Method...
    func callWebService(TypeId:String,selectedId:String)
    {
        let param = ["userId": objLoginUserDetail.userId! as AnyObject,
                     "selectedId": "",
                     "typeId": ""] as [String : AnyObject]
        
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(GET_EVENTLIST_ENTERPISE_URL, params: param, key: "eventList", delegate: self)
    }
    
    //MARK: Webservices Custom Function Call Method...
    func callADDLeadWebService()
    {
     
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        let eventDataObj = arrEventList[0] as! [EventDetail]
        let eventDetailsObj = eventDataObj[selectedIndexForEventIndex]
        let timeStamp = Date.currentTimeStamp
        
        let parameters = ["userId": objLoginUserDetail.userId! as AnyObject,
                          "eventId": "\(eventDetailsObj.eventid!)",
                          "createdTimeStamp": "\(timeStamp)",
                          "addedLeadType": "7"] as [String : AnyObject]
        
        print(parameters)
        
        Alamofire.upload(
                multipartFormData: { MultipartFormData in
                //    multipartFormData.append(imageData, withName: "user", fileName: "user.jpg", mimeType: "image/jpeg")

                    for (key, value) in parameters {
                        MultipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
                    }

                MultipartFormData.append(self.dataAudioObj, withName: "recordSoundUrl", fileName: "demo.wav", mimeType: "audio/wav")


            }, to: WEBSERVICE_URL+ADD_LEAD_POST_URL) { (result) in

                switch result {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        print("response :", response)
                        if let JSON = response.result.value {
                            if let addleadData = (JSON as AnyObject).value(forKey: "addLead") as? [String:Any]{
                                if let statusData = addleadData["status"] as? String{
                                    if statusData == "YES"{
                                        self.stopAnimating()

                                        ShowAlert(title: "Mleads", message: "Lead Successfully Created", buttonTitle: "OK") {
                                            NotificationCenter.default.post(name: Notification.Name("callRefreshAPI"), object: nil, userInfo: nil)
                                            self.navigationController?.popViewController(animated: true)
                                        }
                                    }
                                }
                            }
                        }else{
                            self.stopAnimating()

                            ShowAlert(title: "Mleads", message: "Something went wrong, Please try again", buttonTitle: "OK") {
                            }
                        }
                    }

                case .failure(let encodingError): break
                    print(encodingError)
                }


            }
        
        /*
        let eventDetailObj = arrEventList[selectedIndexForEventIndex] as! EventDetail
        
        let param = ["userId": objLoginUserDetail.userId! as AnyObject,
                     "eventId": eventDetailObj.eventid,
                     "createdTimeStamp": "",
                     "addedLeadType": "7"] as [String : AnyObject]
        
        /*
         eventId = 1620566941
         createdTimeStamp = 1620574208
         updatedTimeStamp =
         addedLeadType = 7
         userId = 1620523277
         */
        
        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(ADD_LEAD_POST_URL, params: param, key: "eventList", delegate: self)*/
    }
    
    @IBAction func btnClickedEventList(_ sender: UIButton) {
        
        StringPickerPopOver.appearFrom(originView: sender as UIView, baseView: self.btnEventList, baseViewController: self, title: "Select Member", choices: arrEventName , initialRow:selectedIndexForEventIndex, doneAction: { selectedRow, selectedString in
            print("row \(selectedRow) : \(selectedString)")
            self.selectedIndexForEventIndex = selectedRow
            self.lblTeamMember.text = selectedString
            
            //self.callWebServiceForEventLeadList(TypeId: self.typeID)
            
            }, cancelAction:{print("cancel")})
        
        
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
        
        if arrEventList.count > 0{
            callADDLeadWebService()
        }
        
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


extension QuickRecordViewController : AVAudioRecorderDelegate, AVAudioPlayerDelegate{
    
    
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


extension QuickRecordViewController : WebServiceDelegate{
    
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
        
        if apiKey == GET_EVENTLIST_ENTERPISE_URL
        {
            let result = handleWebService.handleGetEventList(response)
            print(result.Status)
            print(result.arrEventL)
            //MARK: EVent And Group ....
            if arrEventList.count >= 1
            {
                arrEventList.removeAllObjects()
            }
            if result.Status{
                if result.arrEventL.count > 0{
                    for i in 0..<result.arrEventL.count{
                        let eventDetailObj =  result.arrEventL[i] as! EventDetail
                        arrEventName.append(eventDetailObj.eventName ?? "")
                    }
                    arrEventList.addObjects(from: [result.arrEventL])
                    lblTeamMember.text = arrEventName[selectedIndexForEventIndex]
                }
            }
            
            print(arrEventList)
            
            //arrEventList = result.arrEventL
            
            
        }
        
    }
    
    
    func webServiceResponceFailure(_ errorMessage: String) {
       self.stopAnimating()
        
        let alert = UIAlertController(title: "", message: errorMessage,  preferredStyle: .alert)
        let attributedString = Utilities.alertAttribute(titleString: "")
        alert.setValue(attributedString, forKey: "attributedTitle")
        let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        okAct.setValue(alertbtnColor, forKey: "titleTextColor")
        
        alert.addAction(okAct)
        present(alert,animated: true,completion: nil)
    }
}


extension Date {
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970)
    }
}
