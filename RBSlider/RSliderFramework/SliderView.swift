//
//  SliderView.swift
//  Slider
//
//  Created by ie07 on 01/11/22.
//

import UIKit

public protocol SliderViewDelegate {
    func sliderValueChange(valued: Float)
}

public enum Axis: String {
    case horizontal = "horizontal"
    case vertical = "vertical"
}

public class SliderView: UIView {
    
    public var delegate: SliderViewDelegate?
    var _axis: Axis = Axis.horizontal
    public var axis: Axis {
        get {
            return _axis
        }
        set {
            _axis = newValue
            setup()
            updateValue()
        }
    }
    private var currentSliderValue: Int = 0
    private var panGesture = UIPanGestureRecognizer()
    private var sliderValue: Int = 0
    private var progress: Float = 0.0
    private var _value: Int = 0
    public var value: Int {
        get {
            return _value
        }
        set {
            _value = newValue
            updateValue()
        }
    }
    
    private var barView: UIView = {
        let barView = UIView()
        barView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        return barView
    }()
    
    private var tintView: UIView = {
        let tintView = UIView()
        tintView.backgroundColor = .systemBlue
        return tintView
    }()
    
    private var circleView: UIView = {
        let circleView = UIView()
        circleView.backgroundColor = .systemGreen
        circleView.layer.cornerRadius = 12.5
        return circleView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        reposition()
        setup()
        
    }
    
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        self.barView.bringSubviewToFront(circleView)
        let translation = sender.translation(in: self)
        guard let currentAxis = Axis(rawValue: _axis.rawValue) else {
            return
        }
        switch currentAxis {
            
        case .horizontal:
            var position = (circleView.center.x + translation.x)
            if position < (barView.frame.minX + 12) {
                position = (barView.frame.minX + 12)
            }
            if position > (barView.frame.maxX - 12) {
                position = (barView.frame.maxX - 12)
            }
            else{
                circleView.center = CGPoint(x: position, y: circleView.center.y)
                sender.setTranslation(CGPoint.zero, in: self)
            }
            tintView.frame = CGRect(x: 0, y: 0, width: circleView.center.x, height: 4)
            progress = Float((circleView.center.x - 12) / (barView.frame.maxX - 24.5))
            sliderValue = Int(progress * 100)
            if sliderValue != currentSliderValue{
                currentSliderValue = sliderValue
                delegate?.sliderValueChange(valued: Float(sliderValue))
            }
            
            
        case .vertical:
            
            var position = (circleView.center.y + translation.y)
            if position < (barView.frame.minY + 12) {position = (barView.frame.minY + 12)}
            if position > (barView.frame.maxY - 12) {position = (barView.frame.maxY - 12)}
            else{
                circleView.center = CGPoint(x: circleView.center.x, y: position)
                sender.setTranslation(CGPoint.zero, in: self)
            }
            
            tintView.frame = CGRect(x: 0, y: barView.frame.height, width: 4, height: (circleView.center.y - barView.frame.height))
            progress = Float((circleView.center.y - 12) / (barView.frame.maxY - 23))
            sliderValue = Int(100 - (progress * 100))
            
            //            delegate?.sliderValueChange(valued: Float(sliderValue))
            if sliderValue != currentSliderValue{
                currentSliderValue = sliderValue
                delegate?.sliderValueChange(valued: Float(sliderValue))
            }
            
            
        }
        _value = sliderValue
    }
    
    private func updateValue() {
        
        guard let currentAxis = Axis(rawValue: _axis.rawValue) else {
            return
        }
        
        switch currentAxis {
            
        case .horizontal:
            
            if _value > 100 {_value = 100}
            if _value < 0 {_value = 0}
            else{
                circleView.frame = CGRect(x: (CGFloat(_value) * ((self.frame.width - 25) / 100.0)), y: 0, width: 25, height: 25)
                circleView.center.y = barView.center.y
                tintView.frame = CGRect(x: 0, y: 0, width: circleView.center.x, height: 4)
                sliderValue = _value
                if sliderValue > 100 { sliderValue = 100 }
                if sliderValue < 0 { sliderValue = 0 }
                //                delegate?.sliderValueChange(valued: Float(sliderValue))
                if sliderValue != currentSliderValue{
                    currentSliderValue = sliderValue
                    delegate?.sliderValueChange(valued: Float(sliderValue))
                }
                
            }
            
        case .vertical:
            //            print("Ritik")
            if _value > 100 {_value = 100}
            if _value < 0 {_value = 0}
            else{
                circleView.frame = CGRect(x: (self.frame.width / 2) - 12.5, y: ((self.frame.height - 25) - (CGFloat(_value) * ((self.frame.height - 25) / 100.0))), width: 25, height: 25)
                tintView.frame = CGRect(x: 0, y: self.frame.height, width: 4, height: (circleView.center.y - self.frame.height))
                sliderValue = _value
                if sliderValue > 100 { sliderValue = 100 }
                if sliderValue < 0 { sliderValue = 0 }
                //                delegate?.sliderValueChange(valued: Float(sliderValue))
                if sliderValue != currentSliderValue{
                    currentSliderValue = sliderValue
                    delegate?.sliderValueChange(valued: Float(sliderValue))
                }
            }
        }
    }
    
    func reposition() {
        
        guard let currentAxis = Axis(rawValue: _axis.rawValue) else {
            return
        }
        
        switch currentAxis {
            
        case .horizontal:
            barView.frame = CGRect(x: 0, y: (self.frame.height / 2) - 2, width: self.frame.width, height: 4)
            circleView.frame = CGRect(x: (CGFloat(_value) * ((self.frame.width - 25) / 100.0)), y: barView.center.y - 12.5, width: 25, height: 25)
            tintView.frame = CGRect(x: 0, y: 0, width: circleView.center.x, height: 4)
            
        case .vertical:
            barView.frame = CGRect(x: (self.frame.width / 2) - 2, y: 0, width: 4, height: self.frame.height)
            circleView.frame = CGRect(x: (self.frame.width / 2) - 12.5, y: ((self.frame.height - 25) - (CGFloat(_value) * ((self.frame.height - 25) / 100.0))), width: 25, height: 25)
            tintView.frame = CGRect(x: 0, y: self.frame.height, width: 4, height: (circleView.center.y - self.frame.height))
        }
    }
    
    func setup() {
        
        self.addSubview(barView)
        self.addSubview(circleView)
        self.barView.addSubview(tintView)
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedView(_:)))
        circleView.isUserInteractionEnabled = true
        circleView.addGestureRecognizer(panGesture)
        
    }
    
}
