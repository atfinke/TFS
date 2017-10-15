//
//  ViewController.swift
//  TFSCATests
//
//  Created by Andrew Finke on 10/15/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black

        // Do any additional setup after loading the view, typically from a nib.
    }



    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        createParticles()
    }
    func createParticles() {
        let particleEmitter = CAEmitterLayer()

        particleEmitter.emitterPosition = CGPoint(x: view.center.x, y: view.center.y)
        particleEmitter.emitterShape = kCAEmitterLayerSphere
        particleEmitter.emitterSize = CGSize(width: 1, height: 1)

        let red = makeEmitterCell(color: UIColor.red)
        let green = makeEmitterCell(color: UIColor.green)
        let blue = makeEmitterCell(color: UIColor.blue)
        particleEmitter.beginTime = CACurrentMediaTime()
        particleEmitter.emitterCells = [ blue]

        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false) { (_) in
            particleEmitter.birthRate = 0.0
        }

particleEmitter.seed = arc4random()
        view.layer.addSublayer(particleEmitter)
    }

    func makeEmitterCell(color: UIColor) -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 700
        cell.lifetime = 1
        cell.color = color.cgColor
        cell.velocity = 100
        cell.velocityRange = 5
        cell.emissionRange = CGFloat.pi * 2
        cell.scale = 0.10
        cell.scaleRange = 0.05
        cell.scaleSpeed = -0.1

        cell.yAcceleration = 50



        cell.emitterCells = [makeSubEmitterCell()]

        cell.contents = #imageLiteral(resourceName: "spark").cgImage
        
        return cell
    }

    func makeSubEmitterCell() -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 75
        cell.lifetime = 0.1
        cell.scale = 0.5
        cell.scaleRange = 0.1
        cell.scaleSpeed = -0.1
        cell.color = UIColor.white.cgColor


        cell.contents = #imageLiteral(resourceName: "spark").cgImage
        return cell
    }


}

