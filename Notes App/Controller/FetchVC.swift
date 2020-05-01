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
    let shapeLayer2 = CAShapeLayer()
    var pulsatingLayer = CAShapeLayer()

    var percentage = 0.0{
        didSet{
            print(percentage)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("Fetch view loaded")
        addLayers()
        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        database.getNotes()
        animateLayers()
       // perform(#selector(goToNotes), with: nil, afterDelay: 4.0)
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
        
        let pathForPulsatingLayer = UIBezierPath(arcCenter: .zero, radius: 110, startAngle: -CGFloat.pi/2, endAngle: 2*CGFloat.pi , clockwise: true)
        pulsatingLayer.path = pathForPulsatingLayer.cgPath
        pulsatingLayer.strokeColor=UIColor.clear.cgColor
        pulsatingLayer.lineWidth=15
        pulsatingLayer.lineCap=CAShapeLayerLineCap.round
        pulsatingLayer.fillColor=UIColor.white.withAlphaComponent(0.4).cgColor
        pulsatingLayer.position = view.center
        view.layer.addSublayer(pulsatingLayer)
        
        //MARK:- shapeLayer to be blurred
          let radius = (130/896)*view.frame.height
          let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi/2, endAngle: -CGFloat.pi/2 + (CGFloat.pi*2) , clockwise: true)
           shapeLayer2.path = circularPath.cgPath
           shapeLayer2.strokeColor = #colorLiteral(red: 0.8392156863, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
           shapeLayer2.lineWidth=(20/896)*view.frame.height
           shapeLayer2.lineCap=CAShapeLayerLineCap.round
           shapeLayer2.fillColor = #colorLiteral(red: 1, green: 0.7058823529, blue: 0.7058823529, alpha: 1)
           shapeLayer2.strokeEnd=0
           view.layer.addSublayer(shapeLayer2)
        
         
         //MARK:- shapeLayer to be blurred
         shapeLayer.path = circularPath.cgPath
         shapeLayer.strokeColor=#colorLiteral(red: 0.8392156863, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
         shapeLayer.lineWidth=(25/896)*view.frame.height
         shapeLayer.lineCap=CAShapeLayerLineCap.round
         shapeLayer.fillColor=UIColor.clear.cgColor
         shapeLayer.strokeEnd=0
         view.layer.addSublayer(shapeLayer)
        
        //MARK:- percentage Label
        let lableDimension = (92/896)*view.frame.height
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: lableDimension, height: lableDimension))
        label.center = center
        label.textAlignment = .center
        label.text = "Fetching Data"
        label.font = label.font.withSize(24)
        label.textColor = .black
        label.clipsToBounds = true
        label.layer.cornerRadius = (46/896)*view.frame.height
        view.addSubview(label)
        label.countAnimation(upto: 100)

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

extension UILabel {
    func countAnimation(upto: Double, _ duration: Double = 4, suffix: String = "") {
        let from = text?.components(separatedBy: CharacterSet.init(charactersIn: "-0123456789.,").inverted).first.flatMap { Double($0) } ?? 0.0
        var interval = duration / ((from - upto) * 100)
        if interval < 0 { interval *= (-1) }
        var delay = 0.0
        if from > upto {
            for value in (Int(upto * 100)...Int(from * 100)).reversed() {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    self.text = "\(Int(value) / 100)\(suffix) %"
                }
                delay += interval
            }
        } else {
            for value in Int(from * 100)...Int(upto * 100) {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    self.text = "\(Int(value) / 100)\(suffix) %"
                }
                delay += interval
            }
        }

    }
}
