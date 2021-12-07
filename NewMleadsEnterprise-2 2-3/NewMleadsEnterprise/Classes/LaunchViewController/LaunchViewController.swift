//
//  LaunchViewController.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 31/05/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBOutlet var imgView: UIImageView!
    @IBOutlet var btnSkip: UIButton!
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var pgSlidePage: UIPageControl!
    
    var arrayWithLaunchImage : NSMutableArray!
    var currentSwipeCount : Int = 0
    
    var appDelegate : AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayWithLaunchImage = NSMutableArray()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        self.getImageListing()
        pgSlidePage.currentPage = currentSwipeCount
        imgView.image = UIImage(named: arrayWithLaunchImage.object(at: currentSwipeCount)as! String)
        print(imgView)
    }
    @IBAction func btnSkip(_ sender: Any) {
        self.redirectTOLoginViewController()
    }
    
    @IBAction func btnNext(_ sender: Any) {
        let gesture = UISwipeGestureRecognizer()
        gesture.direction = .left
        self.swipeLeft(gesture)
    }
    
    @objc func swipeRight(_ recognizer: UIGestureRecognizer){
        if currentSwipeCount > 0 {
            currentSwipeCount -= 1
            imgView.image =  nil
            
            let perviousImg = UIImage(named: arrayWithLaunchImage.object(at: currentSwipeCount)as! String)
            imgView.image = perviousImg
            pgSlidePage.currentPage = currentSwipeCount
            
            let transition = CATransition()
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            imgView.layer.contents  = perviousImg?.cgImage
            imgView.layer.add(transition, forKey: "transition")
            
            if currentSwipeCount == arrayWithLaunchImage.count - 2 {
                self.btnSkip.isHidden = false
                self.btnNext.setTitle(nil, for: .normal)
                self.btnNext.setImage((UIImage(named: "LeftArrow.png")), for: .normal)
            }
        }
    }
    @objc func swipeLeft(_ recognizer : UIGestureRecognizer) {
        
        if currentSwipeCount < arrayWithLaunchImage.count - 1 {
            currentSwipeCount += 1;
            imgView.image = nil;
            let nextImg = UIImage(named: arrayWithLaunchImage.object(at: currentSwipeCount) as! String )
            imgView.image = nextImg
            pgSlidePage.currentPage = currentSwipeCount
            let transition = CATransition()
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            imgView.layer.contents = nextImg?.cgImage
            imgView.layer.add(transition, forKey: "transition")
            
            if currentSwipeCount == arrayWithLaunchImage.count - 1 {
                btnSkip.isHidden = true
                btnNext.setTitle("Done", for: .normal)
                btnNext.setImage(nil, for: .normal)
            }
        }
        else
        {
            self.redirectTOLoginViewController()
        }
    }
    
    func redirectTOLoginViewController() {
        UIView.transition(with:appDelegate.window!, duration: 0.5, options: .transitionFlipFromRight, animations:{
            let rvc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.appDelegate.window?.rootViewController = rvc
        } , completion: nil)
    }
    
    func getImageListing()  {
        
        arrayWithLaunchImage.removeAllObjects()
        let bundleRoot = Bundle.main.bundlePath
        var dirContents : NSArray!
        do
        {
            dirContents =
                try FileManager.default.contentsOfDirectory(atPath: bundleRoot) as NSArray
        }
        catch
        {
            
        }
        for i  in 0...dirContents.count - 1 {
            
            let tstring : NSString = dirContents.object(at: i) as! NSString
            if tstring.hasPrefix("Launch") && tstring.hasSuffix(".jpg") {
                arrayWithLaunchImage.add(tstring)
            }
        }
    }
}
