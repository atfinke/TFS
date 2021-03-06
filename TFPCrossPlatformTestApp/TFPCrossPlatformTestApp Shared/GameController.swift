//
//  GameController.swift
//  TFPCrossPlatformTestApp Shared
//
//  Created by Andrew Finke on 10/13/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import SceneKit

#if os(macOS)
    typealias SCNColor = NSColor
#else
    typealias SCNColor = UIColor
#endif

class GameController: NSObject, SCNSceneRendererDelegate {

    let scene: SCNScene
    let sceneRenderer: SCNSceneRenderer
    
    init(sceneRenderer renderer: SCNSceneRenderer) {
        sceneRenderer = renderer
        scene = SCNScene(named: "Art.scnassets/ship.scn")!
        
        super.init()
        
        sceneRenderer.delegate = self

        sceneRenderer.scene = scene



        Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { _ in

            let trailProperties = TrailProperties(particleColor: Color.blue, particleAnimations: [], duration: 5.0, particleLifeSpan: 1.0, particleBirthRate: 10, particleImage: #imageLiteral(resourceName: "spark.png"))
            let explosionProperties = ExplosionProperties(particleColor: Color.blue, particleAnimations: [], duration: 2.0, particleLifeSpan: 1.0, particleBirthRate: 100, particleImage: #imageLiteral(resourceName: "spark.png"))
            let firework = Firework(trail: trailProperties, explosion: explosionProperties)
            self.scene.rootNode.addChildNode(firework)
            firework.position = SCNVector3(x: 0, y: 0, z: 1)
            firework.launch(to: SCNVector3(x: CGFloat((arc4random() % 2) + 5), y: CGFloat((arc4random() % 10) + 5), z: CGFloat((arc4random() % 2) + 5)))


//            let node = SCNNode(geometry: SCNSphere(radius: 0.5))
//
//            let trailDuration = 2.0
//            let trailParticleDuration = 0.5
//
//
//            let trailSystem = SCNParticleSystem()
//            trailSystem.particleImage = #imageLiteral(resourceName: "star.png")
//            trailSystem.birthRate = 30
//            trailSystem.particleLifeSpan = CGFloat(trailParticleDuration)
//
//
//            trailSystem.particleColor = SCNColor.yellow
//
//            let scaleAnimation = CAKeyframeAnimation(keyPath: nil)
//            let values: [NSNumber] = [
//                NSNumber(value: Double(0.5)),
//                NSNumber(value: 0.1)
//            ]
//            scaleAnimation.values = values
//
//            scaleAnimation.duration = trailParticleDuration
//            scaleAnimation.keyTimes = [0, 1]
//
//            let scaleController = SCNParticlePropertyController(animation: scaleAnimation)
//
//            let controllers: [SCNParticleSystem.ParticleProperty: SCNParticlePropertyController] = [
//                .size: scaleController
//            ]
//           trailSystem.propertyControllers = controllers
//
//            node.addParticleSystem(trailSystem)
//            self.scene.rootNode.addChildNode(node)
//
//           node.runAction(SCNAction.moveBy(x: 0, y: 10, z: 1, duration: trailDuration))
//
//            Timer.scheduledTimer(withTimeInterval: trailDuration, repeats: false, block: { _ in
//                let explosionSystem = SCNParticleSystem()
//                explosionSystem.particleImage = #imageLiteral(resourceName: "star.png")
//                explosionSystem.birthRate = 30
//                explosionSystem.particleLifeSpan = CGFloat(5)
//                explosionSystem.birthLocation = .vertex
//                explosionSystem.birthDirection = .random
//                explosionSystem.particleAngleVariation = 360
//              //  explosionSystem.emitterShape
//node.addParticleSystem(explosionSystem)
//
//            })
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // Called before each frame is rendered
    }

}
