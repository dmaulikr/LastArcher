//
//  LongBow.swift
//  LastArcher
//
//  Created by Александр Абугалиев on 23.10.16.
//  Copyright © 2016 AAAR. All rights reserved.
//

import SpriteKit

class LongBow: WeaponConfiguration {
    var reloadTime = TimeInterval(0.7)
    var shellConfiguration = LongBowArrow() as ShellConfiguration
    
    var sprite: SKNode
    var moveAnimation: SKAction
    var shootAnimation: SKAction
    var standartTexture:SKTexture
    
    init(){
        sprite = SKSpriteNode(fileNamed: "StandartBow.sks")!.childNode(withName: "weapon")!
        standartTexture = SKTexture(imageNamed: "basic_bow_standart")
        moveAnimation = SKAction.sequence([SKAction.rotate(toAngle: 0, duration: 0),
                                           SKAction.repeatForever(SKAction.sequence([
                                            SKAction.rotate(byAngle: -0.2, duration: 0.8),
                                            SKAction.rotate(byAngle: 0.2, duration: 0.8)]))])
        
        
        shootAnimation = SKAction.animate(with: [SKTexture(imageNamed: "basic_bow_attack_1"),
                                                 SKTexture(imageNamed: "basic_bow_attack_2")], timePerFrame: shellConfiguration.maxChargeDuration/2)
    }
}
