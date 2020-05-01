//
//  FetchVC.swift
//  Notes App
//
//  Created by Aaryan Kothari on 01/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import CoreData
import FirebaseDatabase

class FetchVC: UIViewController {
    
    let database = firebaseNetworking.shared
    
    let shapeLayer = CAShapeLayer()
    var pulsatingLayer = CAShapeLayer()


    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("Fetch view loaded")
        addLayers()
        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        database.getNotes()
        animateLayers()
        perform(#selector(goToNotes), with: nil, afterDelay: 4.0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Fetch IS ABOUT TO DISSAPPEAR")
    }
    
    @objc func goToNotes(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
           let vc = storyboard.instantiateViewController(withIdentifier: "NotesVC") as! NotesVC
           let navController = UINavigationController(rootViewController: vc)
           navController.modalPresentationStyle = .fullScreen
         self.present(navController, animated:true, completion: nil)
    }
    
         
     func addLayers(){
         
         //MARK: - Center
        let center = view.center
         
         //MARK:- shapeLayer to be blurred
         let radius = (103/896)*view.frame.height
        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi/2, endAngle: -CGFloat.pi/2 + (CGFloat.pi*2) , clockwise: true)
         shapeLayer.path = circularPath.cgPath
         shapeLayer.strokeColor=UIColor(displayP3Red: 35/255.0, green: 78/255.0, blue: 249/255.0, alpha: 1.0).cgColor
         shapeLayer.lineWidth=(20/896)*view.frame.height
         shapeLayer.lineCap=CAShapeLayerLineCap.round
         shapeLayer.fillColor=UIColor.clear.cgColor
         shapeLayer.strokeEnd=0
         view.layer.addSublayer(shapeLayer)
        
        let pathForPulsatingLayer = UIBezierPath(arcCenter: .zero, radius: 90, startAngle: -CGFloat.pi/2, endAngle: 2*CGFloat.pi , clockwise: true)
        pulsatingLayer.path = pathForPulsatingLayer.cgPath
        pulsatingLayer.strokeColor=UIColor.clear.cgColor
        pulsatingLayer.lineWidth=15
        pulsatingLayer.lineCap=CAShapeLayerLineCap.round
        pulsatingLayer.fillColor=UIColor(displayP3Red: 193/255.0, green: 255/255.0, blue: 244/255.0, alpha: 0.5).cgColor
        pulsatingLayer.position = view.center
        view.layer.addSublayer(pulsatingLayer)
     }
    
    func animateLayers(){
        //MARK:- animation
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 4
        basicAnimation.fillMode=CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey:"hey")
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.5
        animation.duration=1
        animation.timingFunction=CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeOut)
        animation.autoreverses=true
        animation.repeatCount = Float.infinity
        pulsatingLayer.add(animation, forKey:"abcd")
    }
}
