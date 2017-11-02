//
//  ParametricGrView.swift
//  Riego Automatico
//
//  Created by Daniel Suárez Souto on 21/9/17.
//  Copyright © 2017 UPM. All rights reserved.
//

import UIKit

struct FunctionPoint {
   var x = 0.0
   var y = 0.0
    
}
protocol ParametricGrViewDataSource {
    
    func startFor(_ pfgv: ParametricGrView ) -> Double
    func endFor(_ pfgv: ParametricGrView ) -> Double
    
    func  parametricGrView(_ pfgv: ParametricGrView, pointAt index:Double) -> FunctionPoint
    
    func parametricImportantPoint(_ pfgv: ParametricGrView) -> FunctionPoint
    
}
@IBDesignable
class ParametricGrView: UIView {

    
    @IBInspectable
    var lineWidth : Double = 3.0
    
    @IBInspectable
    var colorTrajectory : UIColor = .red
    
    @IBInspectable
    var textX : String = "eje x"
    
    @IBInspectable
    var textY : String = "eje y"
    
    @IBInspectable
    var scaleX : Double = 1.0
    
    @IBInspectable
    var scaleY : Double = 1.0
    
    #if TARGET_INTERFACE_BUILDER
        var dataSource: ParametricGrViewDataSource!
    #else
        var dataSource: ParametricGrViewDataSource!
    #endif
    
  
    override func prepareForInterfaceBuilder() {
        class FakeParametricGrViewDataSource: ParametricGrViewDataSource{
            
            func startFor(_ pfgv: ParametricGrView) -> Double {return 0.0}

            func endFor(_ pfgv: ParametricGrView) -> Double {return 10.0}
            
            func parametricGrView(_ pfgv: ParametricGrView, pointAt index: Double) -> FunctionPoint {
                return FunctionPoint(x: index,y:index)
            }
            func parametricImportantPoint(_ pfgv: ParametricGrView) -> FunctionPoint {
                return FunctionPoint(x:Double(pfgv.bounds.width/2),y:Double(pfgv.bounds.height/2))
            }
        }
        
        dataSource=FakeParametricGrViewDataSource()
    }
    
    
    override func awakeFromNib() {
        isUserInteractionEnabled = true
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(recognizerPinch))
        self.addGestureRecognizer(pinch)
    }
  
    @objc func recognizerPinch(_ sender : UIPinchGestureRecognizer ){
        let f = sender.scale
        self.scaleX *= Double(f)
        self.scaleY *= Double(f)
        sender.scale = 1
        self.setNeedsDisplay()
    }
    override func draw(_ rect: CGRect) {
        // Drawing code
            drawAxis()
            drawTrajectory()
            drawImportantPoint()
        
    }
    
    private func drawAxis(){
        
        let w = bounds.width
        let h = bounds.height
        let pathY = UIBezierPath()
        
        pathY.move(to: CGPoint(x: w/2, y:0))
        pathY.addLine(to: CGPoint(x: w/2,y: h))
        pathY.lineWidth=2
        UIColor.black.setStroke()
        pathY.stroke()
        
        let pathX = UIBezierPath()
        
        pathX.move(to: CGPoint(x: 0, y:h/2))
        pathX.addLine(to: CGPoint(x: w,y: h/2))
        pathX.lineWidth=2
        UIColor.black.setStroke()
        pathX.stroke()

    
    }
    
    private func drawTrajectory(){
        
    
            let path = UIBezierPath()
            
            let p0 = dataSource.startFor(self)
            let pf = dataSource.endFor(self)
            let dp = (pf-p0) / 100
            
            let v0 = dataSource.parametricGrView(self, pointAt: p0)
        
            let ptX0 = pointForX(v0.x)
            let ptY0 = pointForY(v0.y)
            
            path.move(to: CGPoint(x: ptX0, y: ptY0))
        
            if(pf==0 && p0==0){
                let v = dataSource.parametricGrView(self, pointAt: p0)
                
                let ptX = pointForX(v.x)
                let ptY = pointForY(v.y)
                
                path.addLine(to: CGPoint(x: ptX,y: ptY))
                path.lineWidth = CGFloat(self.lineWidth)
                self.colorTrajectory.set()
                
                path.stroke()
                return
            }
        
            for p in stride(from: p0, to: pf, by: dp) {
                
                let v = dataSource.parametricGrView(self, pointAt: p)
                
                let ptX = pointForX(v.x)
                let ptY = pointForY(v.y)

                path.addLine(to: CGPoint(x: ptX,y: ptY))
            }
            
        
            path.lineWidth = CGFloat(self.lineWidth)
            self.colorTrajectory.set()
            
            path.stroke()
            
    }
    private func drawImportantPoint() {
        
        let punto = dataSource.parametricImportantPoint(self)
        let punto_x = pointForX(punto.x)
        let punto_y = pointForY(punto.y)
        
        let p1 = CGRect(x: punto_x-3, y: punto_y-3, width: 5.0, height: 5.0)
        let point1 = UIBezierPath(ovalIn: p1)
        UIColor.blue.setStroke()
        point1.stroke()
        UIColor.blue.setFill()
        point1.fill()
    
    }
    private func pointForX (_ x: Double) -> CGFloat{
        let width = bounds.width
        return width/2 + CGFloat(x*scaleX)
    }
    
    private func pointForY (_ y: Double) -> CGFloat{
        let height = bounds.height
        return height/2 - CGFloat(y*scaleY)
    }


}
