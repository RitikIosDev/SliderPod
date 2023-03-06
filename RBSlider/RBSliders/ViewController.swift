//
//  ViewController.swift
//  Slider
//
//  Created by ie07 on 01/11/22.
//

import UIKit
import RSliderFramework

class ViewController: UIViewController, SliderViewDelegate {
    
    @IBOutlet weak var primarySlider: SliderView!
    @IBOutlet weak var primaryStepper: UIStepper!
    @IBOutlet weak var primaryTextField: UITextField!
    @IBOutlet weak var primarySliderValueLabel: UILabel!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!

    let secondarySlider = SliderView(frame: CGRect(x: 50, y: 350, width: 50, height: 300))
    
    
    var _sliderValue:Int = 1
    var sliderValue:Int {
        get {
            return _sliderValue
        }
        set {
            _sliderValue = newValue
            primaryStepper.value = Double(sliderValue)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(secondarySlider)
        
        secondarySlider.backgroundColor = UIColor.clear
        secondarySlider.delegate = self
        secondarySlider.value = 20
        primarySlider.delegate = self
        primarySlider.value = 20
        primarySlider.axis = .horizontal
        secondarySlider.axis = .vertical
        
    }
    
    func sliderValueChange(valued: Float) {
        primarySliderValueLabel.text = "\(Int(valued))"
        sliderValue = Int(valued)
        primaryTextField.text = "\(Int(valued))"
        primarySlider.value = Int(valued)
        secondarySlider.value = Int(valued)
    }

    @IBAction func valueStepper(_ sender: UIStepper) {
        secondarySlider.value = Int(sender.value)
        primarySlider.value = Int(sender.value)
        primaryTextField.text = String(Int(sender.value))
        
    }
    
    @IBAction func valueTextField(_ sender: UITextField) {
        let numString = sender.text
        secondarySlider.value = Int(numString!) ?? 0
        primarySlider.value = Int(numString!) ?? 0
    }
  
    @IBAction private func changeSize(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            self.leadingConstraint.constant = self.leadingConstraint.constant == 20 ? 100 : 20
            self.trailingConstraint.constant = self.trailingConstraint.constant == 20 ? 100 : 20
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }, completion: nil)
//        primarySlider.setup()
    }
}

