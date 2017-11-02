//
//  TrajectoryModel.swift
//  Riego Automatico
//
//  Created by Daniel Suárez Souto on 2/10/17.
//  Copyright © 2017 UPM. All rights reserved.
//

import Foundation
class TrajectoryModel {
    
    /* Posicion de la tuberia */
    var originPos = (x:0.0, y:0.0) {
        didSet{
            update()
        }
    }
    /* Posicion del destino de disparo */
    var targetPos = (x:0.0, y:0.0){
        didSet{
            update()
        }
    }
    /* Velocidad inicial */
    var speed : Double = 0.0{
        didSet{
            update()
        }
    }
    /* Angulo inicial de disparo */
    private var angle : Double = 0.0
    /*Velocidad inicial en horizontal */
    private var speedX = 0.0
    /*Velocidad inicial en vertical */
    private var speedY = 0.0
    /* Constante de gravedad */
    private let g = 9.8
    
    /* Funcion que actualiza la trayectoria si cambia la posicion inical, destino o la velocidad inicial */
    private func update(){
        
        let xf = targetPos.x-originPos.x
        let yf = targetPos.y-originPos.y
        
        /*Expresiones para alcular el angulo*/
        let speed2=pow(speed, 2)
        let speed4=pow(speed, 4)
        let g2=pow(g, 2)
        let xf2 = pow(xf, 2)
        let raiz = sqrt(speed4-g2*xf2-2*g*yf*speed2)
        //print("raiz: \(raiz)")
        /*Angulo que hay que ajustar en la tuberia*/
        let angle = atan(speed2+raiz/(g*xf))
        if !angle.isNormal{
            speedX=0
            speedY=0
        }else{
            speedX = speed*cos(angle)
            speedY = speed*sin(angle)
        }
       
        
    }
    
    /* Funcion que devuelve el tiempo que se tarda en llegar al destino */
    func timeToTarget() -> Double? {
        //print("Target.x : \(targetPos.x) Origin.x: \(originPos.x) speedX: \(speedX)")
        let t = (targetPos.x-originPos.x)/speedX
        return t.isNormal ? t : nil
    }
    
    /* Posicion en un momento dado */
    func positionAt(time t: Double) -> (x:Double,y:Double) {
        let x = originPos.x+speedX*t
        let y = originPos.y+speedY*t-0.5*g*pow(t, 2)
    
        return (x,y)
        
        
        
        
        
    }
    
    
    
    
    
    
    
}
