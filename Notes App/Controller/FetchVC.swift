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
    let shapeLayer3 = CAShapeLayer()
    var pulsatingLayer = CAShapeLayer()
    var label : UILabel!

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
        perform(#selector(end), with: nil, afterDelay: 4.0)
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
    
  @objc  func end(){
        UIView.animate(withDuration: 2) {
            //self.pulsatingLayer.isHidden = true
            self.shapeLayer.lineWidth = 0
        }
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 0
        animation.duration=2
        animation.timingFunction=CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeOut)
        animation.autoreverses=false
        shapeLayer2.add(animation, forKey:"abcd")
    
    let animation2 = CABasicAnimation(keyPath: "transform.scale")
    animation2.toValue = 5
    animation2.duration=2
    animation2.timingFunction=CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeOut)
    
    pulsatingLayer.add(animation2, forKey:"abcd")
    
    label.layer.add(animation, forKey: "ok")
    
    perform(#selector(final), with: nil, afterDelay: 2.0)
    
    }
    
    @objc  func   final(){
        view.layer.addSublayer(shapeLayer3)
        let animation2 = CABasicAnimation(keyPath: "transform.scale")
        animation2.toValue = 5
        animation2.duration=0.5
        animation2.timingFunction=CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeOut)
        animation2.autoreverses = false
        animation2.isRemovedOnCompletion = false
        shapeLayer3.add(animation2, forKey:"abcd")
        
        goToNotes()
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
        let circularPath = UIBezierPath(arcCenter: .zero, radius: radius, startAngle: -CGFloat.pi/2, endAngle: -CGFloat.pi/2 + (CGFloat.pi*2) , clockwise: true)
           shapeLayer2.path = circularPath.cgPath
           shapeLayer2.strokeColor = #colorLiteral(red: 0.8392156863, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
           shapeLayer2.lineWidth=(20/896)*view.frame.height
           shapeLayer2.lineCap=CAShapeLayerLineCap.round
           shapeLayer2.fillColor = #colorLiteral(red: 1, green: 0.7058823529, blue: 0.7058823529, alpha: 1)
           shapeLayer2.strokeEnd=0
           shapeLayer2.position = view.center
           view.layer.addSublayer(shapeLayer2)
        
        
           shapeLayer3.path = circularPath.cgPath
           shapeLayer3.strokeColor = #colorLiteral(red: 0.8392156863, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
           shapeLayer3.lineWidth=(20/896)*view.frame.height
           shapeLayer3.lineCap=CAShapeLayerLineCap.round
           shapeLayer3.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
           shapeLayer3.strokeEnd=0
           shapeLayer3.position = view.center

        
         
         //MARK:- shapeLayer to be blurred
         shapeLayer.path = circularPath.cgPath
         shapeLayer.strokeColor=#colorLiteral(red: 0.8392156863, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
         shapeLayer.lineWidth=(25/896)*view.frame.height
         shapeLayer.lineCap=CAShapeLayerLineCap.round
         shapeLayer.fillColor=UIColor.clear.cgColor
         shapeLayer.strokeEnd=0
        shapeLayer.position = view.center

         view.layer.addSublayer(shapeLayer)
        
        //MARK:- percentage Label
        let lableDimension = (92/896)*view.frame.height
        label = UILabel(frame: CGRect(x: 0, y: 0, width: lableDimension+20, height: lableDimension))
        label.center = center
        label.textAlignment = .center
        label.text = "Fetching Data"
        label.font = label.font.withSize(36)
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
        animation.duration=0.5
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
