//
//  TankModel.swift
//  Riego Automatico
//
//  Created by Daniel Suárez Souto on 2/10/17.
//  Copyright © 2017 UPM. All rights reserved.
//

import Foundation

class TankModel {
    /* Radio del tanque de agua */
    var radiusTank=0.3{
        didSet{
            update()
        }
    }
    /* Radio de la tuberia por la que sale el agua */
    var
    radiusPipe = 0.025{
        didSet{
            update()
        }
    }

    /* Altura inicial de agua en el tanque */
    var initialWaterHeight = 0.5{
        didSet{
            update()
        }
    }
    /* Constante de la gravedad */
    private let g = 9.8
    /* Area del tanque */
    private var areaTank : Double
     /* Area de la tuberia */
    private var areaPipe : Double
    /* Constantes usadas frecuentemente */
    private var at2ap2m1 : Double
    private var ap2at2m1 : Double
    /* Tiempo que falta para vaciarse */
    var timeToEmpty : Double
    
    init() {
        /* Caracteristicas del tanque y la tuberia */
        areaTank = Double.pi*pow(radiusTank,2)
        areaPipe = Double.pi*pow(radiusPipe,2)
        at2ap2m1 = pow(areaTank/areaPipe, 2)-1
        ap2at2m1 = pow(areaPipe/areaTank, 2)-1
        timeToEmpty = sqrt(2*initialWaterHeight*at2ap2m1/g)
       /* print("Radio del tanque: \(radiusTank)")
        print("Area del tanque: \(areaTank)")
        print("Area de la tuberia: \(areaPipe)")
        print("Tiempo para Vaciarse: \(timeToEmpty)")*/
    }
    
    private func update(){
        /* Caracteristicas del tanque y la tuberia */
        areaTank = Double.pi*pow(radiusTank,2)
        areaPipe = Double.pi*pow(radiusPipe,2)
        at2ap2m1 = pow(areaTank/areaPipe, 2)-1
        ap2at2m1 = pow(areaPipe/areaTank, 2)-1
        timeToEmpty = sqrt(2*initialWaterHeight*at2ap2m1/g)
      /*  print("Radio del tanque: \(radiusTank)")
        print("Area del tanque: \(areaTank)")
        print("Area de la tuberia: \(areaPipe)")
        print("Tiempo para Vaciarse: \(timeToEmpty)")*/
    }

    /* Velocidad de la salida del agua en funcion de la altura */
    func waterOutputSpeed(waterHeight h: Double) -> Double {
        let v = sqrt(-2*g*h/ap2at2m1)
        
        return max(0, v)
    }
    
    /* Velocidad de bajada del nivel de agua en el deposito en funcion de la altura */
    func waterHeightSpeed(waterHeight h: Double) -> Double {
        let v = sqrt(2*g*h/at2ap2m1)
        return max(0,v)
        
    }
    
    /* Altura del agua en el tanque en funcion del tiempo */
    func waterHeightAt(time t: Double) -> Double {
        
        if(t>timeToEmpty){
            return 0
        }
        
        let h1=t*sqrt(2*g*initialWaterHeight/at2ap2m1)
        
        if(h1.isNaN){
            return 0
        }
        let h2=pow(t,2)*g/(2*at2ap2m1)
        let h = initialWaterHeight - h1 + h2
        return h
    }
}
