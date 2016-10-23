//
//  GameScene.swift
//  LastArcher
//
//  Created by Alexander Makhnyov on 22.10.16.
//  Copyright © 2016 AAAR. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    //TODO: remove after debug
    var chargeTime = TimeInterval(0.0)
    var shootVector = CGVector.zero
    var currentVector = CGVector.zero
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    //TODO: remove archer spawn by coordinates
    let positionArcher = CGPoint(x:-10, y:-400)
    var archer = Archer()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    let setJoystickStickImageBtn = SKLabelNode(), setJoystickSubstrateImageBtn = SKLabelNode()
    
    let moveAnalogStick =  🕹(diameter: 110)
    let shootAnalogStick = AnalogJoystick(diameter: 90)

    override func sceneDidLoad() {
        
        archer = Archer.createArcher(scene: self, position: positionArcher)
        
        self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        
        moveAnalogStick.position = CGPoint(x: moveAnalogStick.radius + 15, y: moveAnalogStick.radius + 15)
        addChild(moveAnalogStick)
        
        shootAnalogStick.position = CGPoint(x: self.frame.maxX - shootAnalogStick.radius - 15, y:shootAnalogStick.radius + 15)
        addChild(shootAnalogStick)
        
        moveAnalogStick.stick.color = .gray
        shootAnalogStick.stick.color = .gray
        
        func shootStartHandler() {
            self.chargeTime = NSDate.timeIntervalSinceReferenceDate
        }
        
        func shootTrackingHandler(data: AnalogJoystickData) {
            self.currentVector = CGVector(dx: sin(data.angular), dy: -1 * cos(data.angular))
        }
        
        func shootStopHandler() {
            self.chargeTime = NSDate.timeIntervalSinceReferenceDate - self.chargeTime
            let arrow = BasicArrow.createArrow(scene: self, configuration: LongBowArrow())
            arrow.shoot(position: self.archer.position, direction: self.currentVector, chargeTime: self.chargeTime)
        }
        
        shootAnalogStick.startHandler = shootStartHandler
        shootAnalogStick.trackingHandler = shootTrackingHandler
        shootAnalogStick.stopHandler = shootStopHandler


    }
    

    
    func touchDown(atPoint pos : CGPoint) {
        shootVector = CGVector(point: pos)
        chargeTime = NSDate.timeIntervalSinceReferenceDate
        
        print(pos)
    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {
        shootVector = shootVector.difference(vector: CGVector(point: pos))
        chargeTime = NSDate.timeIntervalSinceReferenceDate - chargeTime
        let arrow = BasicArrow.createArrow(scene: self, configuration: LongBowArrow())
        arrow.shoot(position: archer.position, direction: shootVector,chargeTime: chargeTime)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
    
    class func level(levelNum: Int) -> GameScene? {
        let scene = GameScene(fileNamed: "Level\(levelNum)")!
        scene.scaleMode = .aspectFill
        return scene
    }
}
