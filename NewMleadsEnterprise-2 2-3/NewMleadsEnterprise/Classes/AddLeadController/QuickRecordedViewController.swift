//
//  QuickRecordedViewController.swift
//  NewMleadsEnterprise
//
//  Created by MAC on 16/09/21.
//  Copyright © 2021 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit
import AVFoundation
import NVActivityIndicatorView

class QuickRecordedViewController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var viewRoundedObj: UIView!
    @IBOutlet weak var imgVoiceRecording: UIImageView!
    @IBOutlet weak var imgSpeakPlay: UIImageView!
    
    var objLeadData = LeadList()
    var player = AVAudioPlayer()
    var playerObj = AVPlayer()
    
    let webService : WebService = WebService()
    var handleWebService : HandleWebService = HandleWebService()
    var appdelegate = AppDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Review Quick Record Lead"
        DispatchQueue.main.async {
            self.shaddowSet()
        }
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
   
    @IBAction func audioPlayStopAction(_ sender: UIButton) {
        
        if objLeadData.recordSoundUrl?.count ?? 0 > 0{
            
            if player.isPlaying{
                player.pause()
                imgSpeakPlay.image = UIImage(named: "speak_play_icon3-Recovered")

            }else{
                /*guard let url = URL(string: objLeadData.recordSoundUrl ?? "") else {
                    print("error to get the mp3 file")
                    return
                }
                do {
                    playerObj = try AVPlayer(url: url as URL)
                } catch {
                    print("audio file error")
                }
                playerObj.play()*/
                /*let soundURl = URL(string: objLeadData.recordSoundUrl ?? "")
                player = try! AVAudioPlayer(contentsOf: soundURl!)
                player.prepareToPlay()
                player.play()*/
                
                /*do {
                        let soundURl = URL(string: objLeadData.recordSoundUrl ?? "")
                    self.player = try AVAudioPlayer(contentsOf: soundURl!)
                        player.prepareToPlay()
                        player.volume = 1.0
                        player.play()
                    } catch let error as NSError {
                        //self.player = nil
                        print(error.localizedDescription)
                    } catch {
                        print("AVAudioPlayer init failed")
                    }*/
                
                imgSpeakPlay.image = UIImage(named: "speak_play_icon33")

                DispatchQueue.main.async {
                    let urlstring = self.objLeadData.recordSoundUrl ?? ""
                    let url = URL(string: urlstring)
                    let data = try! Data(contentsOf: url!)
                    self.player = try! AVAudioPlayer(data: data)
                    self.player.prepareToPlay()
                    self.player.volume = 1.0
                    self.player.play()
                }
            }
        }
        
    }
    
    @IBAction func btnDeleteClickedAction(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "", message: "Are you sure you want to delete this lead?",  preferredStyle: .alert)
        let attributedString = Utilities.alertAttribute(titleString: "")
        alert.setValue(attributedString, forKey: "attributedTitle")
        
        let okAct = UIAlertAction(title: "YES", style: .default) { handler in
            self.callWebService()
        }

        let noAct = UIAlertAction(title: "NO", style: .default) { handler in
            alert.dismiss(animated: true, completion: nil)
        }
        
        okAct.setValue(alertbtnColor, forKey: "titleTextColor")
        noAct.setValue(alertbtnColor, forKey: "titleTextColor")
        
        alert.addAction(okAct)
        alert.addAction(noAct)
        present(alert,animated: true,completion: nil)
    }
    
    //MARK:- Webservices Custom Function Call Method...
    func callWebService()
    {
        let param:[String : AnyObject] = ["leadId":objLeadData.leadId as AnyObject]

        //Progress Bar Loding...
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29))
        
        webService.doRequestPost(DELETE_LEAD_API_URL, params: param, key: "deleteLead", delegate: self)
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


//MARK:- Webservices Method...
extension QuickRecordedViewController:WebServiceDelegate{
    
    func webServiceResponceSuccess(_ response: Data, apiKey: String) {
        stopAnimating()
        
        if apiKey == DELETE_LEAD_API_URL
        {
            let json = JSON(data: response)
            print("json : ",json)
            if json["getDeleteLead"]["status"].string == "YES"{
                NotificationCenter.default.post(name: Notification.Name("callRefreshAPI"), object: nil, userInfo: nil)
                self.navigationController?.popViewController(animated: true)
            }else{
                let alert = UIAlertController(title: "", message: "Something went wrong, please try again" ,  preferredStyle: .alert)
                let attributedString = Utilities.alertAttribute(titleString: "")
                alert.setValue(attributedString, forKey: "attributedTitle")
                let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                okAct.setValue(alertbtnColor, forKey: "titleTextColor")
                
                alert.addAction(okAct)
                present(alert,animated: true,completion: nil)
            }
            

        }
    }
    func webServiceResponceFailure(_ errorMessage: String) {
        stopAnimating()
        
        let alert = UIAlertController(title: "", message: errorMessage,  preferredStyle: .alert)
        let attributedString = Utilities.alertAttribute(titleString: "")
        alert.setValue(attributedString, forKey: "attributedTitle")
        let okAct = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        okAct.setValue(alertbtnColor, forKey: "titleTextColor")
        
        alert.addAction(okAct)
        present(alert,animated: true,completion: nil)
    }
}
