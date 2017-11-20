//
//  Firework.swift
//  TFPCrossPlatformTestApp
//
//  Created by Andrew Finke on 11/8/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//



import Foundation
import SceneKit

#if os(macOS)
    typealias Image = NSImage
    typealias Color = NSColor
#else
    typealias Image = UIImage
    typealias Color = UIColor
#endif

struct ParticleAnimation {
    let property: SCNParticleSystem.ParticleProperty
    let controller: SCNParticlePropertyController

    init(property: SCNParticleSystem.ParticleProperty, backingAnimation: CAAnimation) {
        self.property = property
        self.controller = SCNParticlePropertyController(animation: backingAnimation)
    }
}

protocol ParticleSystemProperties {
    var duration: CGFloat { get }

    var particleLifeSpan: CGFloat  { get }
    var particleBirthRate: CGFloat  { get }

    var particleImage: Image  { get }
    var particleColor: Color  { get }
    var particleAnimations: [ParticleAnimation] { get }
}

struct TrailProperties: ParticleSystemProperties {
    var particleColor: Color

    var particleAnimations: [ParticleAnimation]

    let duration: CGFloat

    let particleLifeSpan: CGFloat
    let particleBirthRate: CGFloat

    let particleImage: Image
}

struct ExplosionProperties: ParticleSystemProperties {
    var particleColor: Color

    var particleAnimations: [ParticleAnimation]

    let duration: CGFloat

    let particleLifeSpan: CGFloat
    let particleBirthRate: CGFloat

    let particleImage: Image
}


class Firework: SCNNode {

    let trailProperties: TrailProperties
    let explosionProperties: ExplosionProperties

    let trailParticleSystem: SCNParticleSystem
    let explosionParticleSystem: SCNParticleSystem

    init(trail: TrailProperties, explosion: ExplosionProperties) {
        self.trailProperties = trail
        self.explosionProperties = explosion

        self.trailParticleSystem = Firework.particleSystem(for: trail)
        self.explosionParticleSystem = Firework.particleSystem(for: explosion)

        super.init()

        self.geometry = SCNSphere(radius: 0.05)
        self.geometry?.firstMaterial?.diffuse.contents = Color.yellow
    }

    func launch(to position: SCNVector3) {
        let actions: [SCNAction] = [
            .move(to: position, duration: TimeInterval(trailProperties.duration)),
            .run({ _ in
                self.removeParticleSystem(self.trailParticleSystem)
                self.addParticleSystem(self.explosionParticleSystem)
            }),
            .wait(duration: TimeInterval(explosionProperties.duration)),
            .run({ _ in
                self.removeParticleSystem(self.explosionParticleSystem)
            }),
            .removeFromParentNode()
        ]
        runAction(.sequence(actions))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private static func particleSystem(for trail: TrailProperties) -> SCNParticleSystem {
        let system = baseParticleSystem(for: trail)
        return system
    }

    private static func particleSystem(for explosion: ExplosionProperties) -> SCNParticleSystem {
        let system = baseParticleSystem(for: explosion)
        return system
    }

    private static func baseParticleSystem(for properties: ParticleSystemProperties) -> SCNParticleSystem {
        let system = SCNParticleSystem()
        system.particleImage = properties.particleImage
        system.birthRate = properties.particleBirthRate
        system.particleLifeSpan = properties.particleLifeSpan
        system.particleColor = properties.particleColor
        system.propertyControllers = properties.particleAnimations.controllers()
        return system
    }
}

extension Array where Element == ParticleAnimation {
    func controllers() -> [SCNParticleSystem.ParticleProperty: SCNParticlePropertyController] {
        var controllers = [SCNParticleSystem.ParticleProperty: SCNParticlePropertyController]()
        for animation in self {
            controllers[animation.property] = animation.controller
        }
        return controllers
    }
}
