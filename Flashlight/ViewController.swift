//
//  ViewController.swift
//  Flashlight
//
//  Created by hyejeong seo on 2018. 7. 13..
//  Copyright © 2018년 hyejeong seo. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var flashImageView: UIImageView!
    
    var isOn = false
    var soundPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareSound()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func prepareSound() {
        let path = Bundle.main.path(forResource: "switch.wav", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: url)
            soundPlayer?.prepareToPlay()
        } catch {
            // couldn't load file :(
        }
    }
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
    @IBAction func switchTapped(_ sender: Any) {
        isOn = !isOn
        
        soundPlayer?.play()
        toggleTorch(on: isOn)
        
        flashImageView.image = isOn ? #imageLiteral(resourceName: "onBG") : #imageLiteral(resourceName: "offBG")
        switchButton.setImage(isOn ? #imageLiteral(resourceName: "onSwitch") : #imageLiteral(resourceName: "offSwitch"), for: .normal)
    }
    
}

