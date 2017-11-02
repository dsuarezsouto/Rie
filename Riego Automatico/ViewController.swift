//
//  ViewController.swift
//  Riego Automatico
//
//  Created by Daniel Suárez Souto on 21/9/17.
//  Copyright © 2017 UPM. All rights reserved.
//

import UIKit
class ViewController: UIViewController, ParametricGrViewDataSource{
    
    var tankModel = TankModel()
    let trajectoryModel = TrajectoryModel()
    
    @IBOutlet weak var graficaVelSalidaTiempo: ParametricGrView!
    
   
    @IBOutlet weak var graficaVelDescensoAgua: ParametricGrView!
    
    @IBOutlet weak var graficaNivelAguaTiempo: ParametricGrView!
    
    @IBOutlet weak var graficaTrayectoria: ParametricGrView!
    
    
    
    @IBOutlet weak var sliderTiempo: UISlider!
        
    @IBOutlet weak var sliderRadioTanque: UISlider!
    
    @IBOutlet weak var sliderRadioTuberia: UISlider!
    
    @IBOutlet weak var labelTiempo1: UILabel!
    
    @IBOutlet weak var labelTiempo2: UILabel!
    
    @IBOutlet weak var labelVelSalida: UILabel!
    
    @IBOutlet weak var labelVelDescenso: UILabel!
    
    @IBOutlet weak var labelNivelAgua: UILabel!
    
    @IBOutlet weak var labelRadioTanque: UILabel!
    
    @IBOutlet weak var labelRadioTuberia: UILabel!
    
    /*  */
    var trajectoryTime : Double = 0.0 {
        
        didSet{
           graficaVelSalidaTiempo.setNeedsDisplay()
           graficaVelDescensoAgua.setNeedsDisplay()
           graficaNivelAguaTiempo.setNeedsDisplay()
           graficaTrayectoria.setNeedsDisplay()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        graficaVelSalidaTiempo.dataSource = self
        graficaVelSalidaTiempo.scaleX=2
        graficaVelSalidaTiempo.scaleY=6
        
        
        
        graficaVelDescensoAgua.dataSource = self
        graficaVelDescensoAgua.scaleX=150
        graficaVelDescensoAgua.scaleY=800
        
        graficaNivelAguaTiempo.dataSource = self
        graficaNivelAguaTiempo.scaleX=2
        graficaNivelAguaTiempo.scaleY=50

        graficaTrayectoria.dataSource = self
        graficaTrayectoria.scaleX=100
        graficaTrayectoria.scaleY=10
        
        /* Inicializamos las posiciones de la maceta y regadera */
        trajectoryModel.originPos = (0,2)
        trajectoryModel.targetPos = (2,0)
        /* Valor maximo del slider de tiempo */
        sliderTiempo.maximumValue = Float(tankModel.timeToEmpty)
       /* Dimensiono los sliders de los radios */
        sliderRadioTanque.value = Float(tankModel.radiusTank)
        sliderRadioTuberia.value = Float(tankModel.radiusPipe)
        sliderRadioTanque.maximumValue = 0.6
        sliderRadioTanque.minimumValue = 0.2
        sliderRadioTuberia.maximumValue = 0.1
        sliderRadioTuberia.minimumValue = 0.01
        /* Inicializo los labels de los radios de la tuberia y el tanque */
        labelRadioTanque.text = "Radio del tanque: \(String(format: "%.2f",tankModel.radiusTank)) m"
        labelRadioTuberia.text = "Radio de la tuberia: \(String(format: "%.2f",tankModel.radiusPipe)) m"
        
        sliderTiempo.sendActions(for: .valueChanged)

        
      

       
    }
    
 

    @IBAction func recognizerSwipeUp(_ sender: UISwipeGestureRecognizer) {
        tankModel.initialWaterHeight += 0.1
        let h = tankModel.waterHeightAt(time: trajectoryTime)
        let velSalida = tankModel.waterOutputSpeed(waterHeight: h)
        let velDescenso = tankModel.waterHeightSpeed(waterHeight: h)
        labelVelSalida.text = "Vel Salida: \(String(format: "%.2f",velSalida)) m/s"
        labelVelDescenso.text = "Vel Descenso: \(String(format: "%.2f",velDescenso)) m/s"
        labelNivelAgua.text = "Nivel de Agua: \(String(format: "%.2f",h)) m"
        /* Actualizamos el valor maximo del slider de tiempo */
        sliderTiempo.maximumValue = Float(tankModel.timeToEmpty)
        graficaVelSalidaTiempo.setNeedsDisplay()
        graficaVelDescensoAgua.setNeedsDisplay()
        graficaNivelAguaTiempo.setNeedsDisplay()
        graficaTrayectoria.setNeedsDisplay()
    }
    
    @IBAction func recognizerSwipeDown(_ sender: UISwipeGestureRecognizer) {
        tankModel.initialWaterHeight -= 0.1
        let h = tankModel.waterHeightAt(time: trajectoryTime)
        let velSalida = tankModel.waterOutputSpeed(waterHeight: h)
        let velDescenso = tankModel.waterHeightSpeed(waterHeight: h)
        labelVelSalida.text = "Vel Salida: \(String(format: "%.2f",velSalida)) m/s"
        labelVelDescenso.text = "Vel Descenso: \(String(format: "%.2f",velDescenso)) m/s"
        labelNivelAgua.text = "Nivel de Agua: \(String(format: "%.2f",h)) m"
        /* Actualizamos el valor maximo del slider de tiempo */
        sliderTiempo.maximumValue = Float(tankModel.timeToEmpty)
        graficaVelSalidaTiempo.setNeedsDisplay()
        graficaVelDescensoAgua.setNeedsDisplay()
        graficaNivelAguaTiempo.setNeedsDisplay()
        graficaTrayectoria.setNeedsDisplay()
    }
    @IBAction func sliderTime(_ sender: UISlider) {

        trajectoryTime = Double(sender.value)
        labelTiempo1.text = "Tiempo: \(String(format: "%.2f",sender.value)) s"
        labelTiempo2.text = "Tiempo: \(String(format: "%.2f",sender.value)) s"
        let h = tankModel.waterHeightAt(time: trajectoryTime)
        let velSalida = tankModel.waterOutputSpeed(waterHeight: h)
        let velDescenso = tankModel.waterHeightSpeed(waterHeight: h)
        labelVelSalida.text = "Vel Salida: \(String(format: "%.2f",velSalida)) m/s"
        labelVelDescenso.text = "Vel Descenso: \(String(format: "%.2f",velDescenso)) m/s"
        labelNivelAgua.text = "Nivel de Agua: \(String(format: "%.2f",h)) m"

    }
    
    @IBAction func sliderRadioTanque(_ sender: UISlider) {
        
        tankModel.radiusTank = Double(sender.value)
        /* Actualizamos el label del radio del tanque */
         labelRadioTanque.text = "Radio del tanque: \(String(format: "%.2f",tankModel.radiusTank)) m"
        let h = tankModel.waterHeightAt(time: trajectoryTime)
        let velSalida = tankModel.waterOutputSpeed(waterHeight: h)
        let velDescenso = tankModel.waterHeightSpeed(waterHeight: h)
        labelVelSalida.text = "Vel Salida: \(String(format: "%.2f",velSalida)) m/s"
        labelVelDescenso.text = "Vel Descenso: \(String(format: "%.2f",velDescenso)) m/s"
        labelNivelAgua.text = "Nivel de Agua: \(String(format: "%.2f",h)) m"
        /* Actualizamos el valor maximo del slider de tiempo */
        sliderTiempo.maximumValue = Float(tankModel.timeToEmpty)
        graficaVelSalidaTiempo.setNeedsDisplay()
        graficaVelDescensoAgua.setNeedsDisplay()
        graficaNivelAguaTiempo.setNeedsDisplay()
        graficaTrayectoria.setNeedsDisplay()
        
        
    }
    
    @IBAction func sliderRadioTuberia(_ sender: UISlider) {
        
        tankModel.radiusPipe = Double(sender.value)
        /* Actualizamos el label del radio de la tuberia */
        
        labelRadioTuberia.text = "Radio de la tuberia: \(String(format: "%.2f",tankModel.radiusPipe)) m"
        let h = tankModel.waterHeightAt(time: trajectoryTime)
        let velSalida = tankModel.waterOutputSpeed(waterHeight: h)
        let velDescenso = tankModel.waterHeightSpeed(waterHeight: h)
        labelVelSalida.text = "Vel Salida: \(String(format: "%.2f",velSalida)) m/s"
        labelVelDescenso.text = "Vel Descenso: \(String(format: "%.2f",velDescenso)) m/s"
        labelNivelAgua.text = "Nivel de Agua: \(String(format: "%.2f",h)) m"
        /* Actualizamos el valor maximo del slider de tiempo */
        sliderTiempo.maximumValue = Float(tankModel.timeToEmpty)
        graficaVelSalidaTiempo.setNeedsDisplay()
        graficaVelDescensoAgua.setNeedsDisplay()
        graficaNivelAguaTiempo.setNeedsDisplay()
        graficaTrayectoria.setNeedsDisplay()
        
    }

   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startFor(_ pfgv: ParametricGrView ) -> Double {
        if(pfgv == graficaVelSalidaTiempo){
            return 0.0
        }else if (pfgv == graficaVelDescensoAgua){
            return 0.0
        }else if (pfgv == graficaNivelAguaTiempo){
            return 0.0
        }else if (pfgv == graficaTrayectoria){
            return 0.0
        }else{
            return 0.0
        }
    }
    
    func endFor(_ pfgv: ParametricGrView ) -> Double {
        //print(tankModel.timeToEmpty)
        switch pfgv {
        case graficaVelSalidaTiempo:
            return tankModel.timeToEmpty
        case graficaVelDescensoAgua:
            return tankModel.initialWaterHeight
        case graficaNivelAguaTiempo:
            return tankModel.timeToEmpty
        case graficaTrayectoria:
            
            let h = tankModel.waterHeightAt(time: trajectoryTime)
            let v = tankModel.waterOutputSpeed(waterHeight: h)
            trajectoryModel.speed=v
        
            let timeToTarget = trajectoryModel.timeToTarget()
           
            if(timeToTarget != nil){
                return min(timeToTarget!, trajectoryTime)
            }else{
                return 0
            }
            
        default:
            return 150
        }
        
    }
    
    func parametricGrView(_ pfgv: ParametricGrView, pointAt index:Double) -> FunctionPoint {
        
      
        
        switch pfgv {
        case graficaVelSalidaTiempo:
            /* Tiempo */
            let t=index
            /* Nivel del agua */
            let h = tankModel.waterHeightAt(time: t)
            let y = tankModel.waterOutputSpeed(waterHeight: h)
            
            return FunctionPoint(x: t,y: y)
            
        case graficaVelDescensoAgua:
            
            
            let y = tankModel.waterHeightSpeed(waterHeight: index)
            //print("Altura: \(index); Velocidad: \(y)")
            return FunctionPoint(x: index,y: y)
            
        case graficaNivelAguaTiempo:
            /* Tiempo */
            let t=index
            /* Nivel del agua */
            let h = tankModel.waterHeightAt(time: t)
    
            return FunctionPoint(x: t,y: h)
            
        case graficaTrayectoria:
            let t = index
          
            let h = tankModel.waterHeightAt(time: t)
            let v = tankModel.waterOutputSpeed(waterHeight: h)
            trajectoryModel.speed = v
      

            let trayectoria_x = trajectoryModel.positionAt(time: t).x
            let trayectoria_y = trajectoryModel.positionAt(time: t).y
            //print("trayectoria_x: \(trayectoria_x)")
            //print("trayectoria_y: \(trayectoria_y)")
            return FunctionPoint(x:trayectoria_x,y:trayectoria_y)
        default:
            return FunctionPoint(x: 0,y: 0)
      

        }
        

    }
    
    func parametricImportantPoint(_ pfgv: ParametricGrView) -> FunctionPoint {
        /* Tiempo */
        let t = trajectoryTime
        /* Nivel del agua */
        let h = tankModel.waterHeightAt(time: t)
        

        switch pfgv {
        case graficaVelSalidaTiempo:
            
            let y = tankModel.waterOutputSpeed(waterHeight: h)
            //print("TrajectoryTime: \(t); Velocidad: \(y)")
            return FunctionPoint(x: t,y: y)
            
        case graficaVelDescensoAgua:
            
            let y = tankModel.waterHeightSpeed(waterHeight: h)
            //print("Altura: \(h); Velocidad: \(y)")
            return FunctionPoint(x: h,y: y)
            
        case graficaNivelAguaTiempo:
            
            return FunctionPoint(x: t,y: h)
            
        case graficaTrayectoria:
            
            let trayectoria_x = trajectoryModel.positionAt(time: t).x
            let trayectoria_y = trajectoryModel.positionAt(time: t).y
            
            return FunctionPoint(x:trayectoria_x,y:trayectoria_y)
        default:
            return FunctionPoint(x: 0,y: 0)
            
            
        }
        

    }

}

