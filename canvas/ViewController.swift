//
//  ViewController.swift
//  canvas
//
//  Created by Estella Lai on 11/3/16.
//  Copyright © 2016 Estella Lai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var trayView: UIView!
    @IBOutlet weak var excited: UIImageView!
    @IBOutlet weak var dead: UIImageView!
    @IBOutlet weak var tongue: UIImageView!
    @IBOutlet weak var wink: UIImageView!
    @IBOutlet weak var sadFace: UIImageView!
    @IBOutlet weak var happyFace: UIImageView!
    
    var newlyCreatedFace: UIImageView!
    var trayCenterWhenClosed: CGPoint!
    var trayOriginalCenter: CGPoint!
    var trayCenterWhenOpen: CGPoint!
    var originalCenter : CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let windowHeight = UIScreen.main.bounds.size.height
        let trayHeight = trayView.frame.height
        trayCenterWhenClosed = CGPoint(x: self.view.frame.midX, y: windowHeight - trayHeight + 240)
        trayCenterWhenOpen = CGPoint(x: self.view.frame.midX, y: windowHeight - (trayHeight/2))
        self.trayView.center = CGPoint(x: self.view.frame.midX, y: windowHeight - trayHeight + 240)

        excited.isUserInteractionEnabled = true
        dead.isUserInteractionEnabled = true
        tongue.isUserInteractionEnabled = true
        wink.isUserInteractionEnabled = true
        sadFace.isUserInteractionEnabled = true
        happyFace.isUserInteractionEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTrayPanGesture(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: parent?.view)
        if sender.state == .began {
            print("Gesture began at: \(point)")
            trayOriginalCenter = trayView.center
        } else if sender.state == .changed {
            print("Gesture changed at: \(point)")
//            let translation = sender.translation(in: self.view)
//            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
            let velocity = sender.velocity(in: parent?.view)
            UIView.animate(withDuration: 1, animations: {
                if (velocity.y > 0) {
                    self.trayView.center = CGPoint(x: self.trayCenterWhenClosed.x, y: self.trayCenterWhenClosed.y)
                } else {
                    self.trayView.center = CGPoint(x: self.trayCenterWhenOpen.x, y: self.trayCenterWhenOpen.y)
                    
                }
            })
            
        } else if sender.state == .ended {
            print("Gesture ended at: \(point)")
        }
    }
    
    func isInImageView(point: CGPoint) -> Bool {
        let views = [excited, dead, tongue, wink, sadFace, happyFace]
        for view in views {
            if (view?.frame.contains(point))! {
                return true;
            }
        }
        return false;
    }

    @IBAction func createSmiley(_ sender: UIPanGestureRecognizer) {

        if sender.state == .began {
            // Gesture recognizers know the view they are attached to
            let imageView = sender.view as! UIImageView
            
            // Create a new image view that has the same image as the one currently panning
            newlyCreatedFace = UIImageView(image: imageView.image)
            
            // Add the new face to the tray's parent view.
            self.view.addSubview(newlyCreatedFace)
            
            // Initialize the position of the new face.
            newlyCreatedFace.center = imageView.center
            
            // Since the original face is in the tray, but the new face is in the
            // main view, you have to offset the coordinates
            newlyCreatedFace.center.y += trayView.frame.origin.y
            
            originalCenter = newlyCreatedFace.center
            
        } else if sender.state == .changed {
            let translation = sender.translation(in: self.view)
            newlyCreatedFace.center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y + translation.y)

        }
        
    }
}

