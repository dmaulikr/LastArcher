//
//  Joystick.swift
//  LastArcher
//
//  Created by Александр Абугалиев on 29.10.16.
//  Copyright © 2016 AAAR. All rights reserved.
//

import SpriteKit

class Joystick{
    let moveAnalogStick =  🕹(diameter: 150)
    let shootAnalogStick = AnalogJoystick(diameter: 150)
    let cameraZoomOutAction = SKAction.scale(to: 1.5, duration: 0.5)
    let cameraZoomInAction = SKAction.scale(to: 1, duration: 0.5)
 //   let chargeBowStringAction = SKAction.moveBy(x: <#T##CGFloat#>, y: <#T##CGFloat#>, duration: <#T##TimeInterval#>)
    
    var chargeTime = TimeInterval(0.0)
    var mainScene:GameScene
    var archer:Archer
    var camera:SKCameraNode
    var pullForce:CGFloat
    var cameraTriggered:Bool
    
    var chargeBar:Bar
    var pupsik:CGFloat = 10
    
    
    init(){
        self.mainScene = GameScene.mainScene!
        self.archer = mainScene.archer
        self.camera = mainScene.camera!
        self.pullForce = 0.0
        self.cameraTriggered = false
        self.chargeBar = mainScene.chargeBar
        
        moveAnalogStick.position = CGPoint(
            x: mainScene.frame.minX * 0.65,
            y: mainScene.frame.minY * 0.5)
        
        shootAnalogStick.position = CGPoint(
            x: mainScene.frame.maxX * 0.65,
            y: mainScene.frame.minY * 0.5)
        
        camera.addChild(moveAnalogStick)
        camera.addChild(shootAnalogStick)
        
        moveAnalogStick.stick.color = .gray
        shootAnalogStick.stick.color = .gray
        
        shootAnalogStick.startHandler = shootStartHandler
        shootAnalogStick.trackingHandler = shootTrackingHandler
        shootAnalogStick.stopHandler = shootStopHandler
        moveAnalogStick.trackingHandler = moveTrackingHandler
    }
    
    func shootStartHandler() {
        archer.pullBowstring()
        print(archer.chargeTime)

            }
    
    func shootStopHandler() {
        archer.releaseBowstring(pullForce: self.pullForce)
        camera.run(cameraZoomInAction)
        print(archer.chargeTime)
        cameraTriggered = false
        
        chargeBar.zPosition = -10
        pupsik = 0
    }
    
    func moveTrackingHandler(data: AnalogJoystickData) {
        archer.move(direction: data.velocity.normalize())
        if (!archer.isBowstring) {
            archer.turn(direction: data.velocity)
        }

    }
    
    func shootTrackingHandler(data: AnalogJoystickData) {

        pullForce = data.velocity.length()
        if (pullForce > archer.MIN_PULL_FORCE){
            archer.turn(direction: data.velocity.multiply(scalar: -1))

        }
        if (((NSDate.timeIntervalSinceReferenceDate - archer.chargeTime) > 0.7) && (cameraTriggered == false)){
            camera.run(cameraZoomOutAction)
            cameraTriggered = true
        }
        pupsik = pupsik + 10
        chargeBar.updateBar(progress: pupsik)
        chargeBar.zPosition = 111
    }
}
