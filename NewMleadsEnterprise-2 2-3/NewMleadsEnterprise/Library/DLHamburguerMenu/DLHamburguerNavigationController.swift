//
//  DLHamburguerNavigationController.swift
//  DLHamburguerMenu
//
//  Created by Nacho on 5/3/15.
//  Copyright (c) 2015 Ignacio Nieto Carvajal. All rights reserved.
//

import UIKit

class DLHamburguerNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.view.frame.size.height))
        self.view!.addSubview(gestView)
        gestView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(DLHamburguerNavigationController.panGestureRecognized(_:))))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func panGestureRecognized(_ sender: UIPanGestureRecognizer!) {
        // dismiss keyboard
        self.view.endEditing(true)
        self.findHamburguerViewController()?.view.endEditing(true)
        
        // pass gesture to hamburguer view controller.
        self.findHamburguerViewController()?.panGestureRecognized(sender)
    }
    
}
