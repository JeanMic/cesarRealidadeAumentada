//
//  ViewController.swift
//  ARTestingTemplate
//
//  Created by Rafael Lucena on 4/8/19.
//  Copyright © 2019 Rafael. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    let planePosition = SCNNode()
    
    var planDetected = false
    
    @IBOutlet weak var descricao: UILabel!
    
    var earthNode = SCNScene(named: "art.scnassets/Earth.dae")!.rootNode.childNode(withName: "Earth", recursively: true)
    
    var mantoNode = SCNScene(named: "art.scnassets/manto.dae")!.rootNode.childNode(withName: "manto", recursively: true)
    
    var nucleoNode = SCNScene(named: "art.scnassets/nucleo.dae")!.rootNode.childNode(withName: "nucleo", recursively: true)
    
    var CrostaEmExibicao = false
    var mantoEmExibicao = false
    var nucleoEmExibicao = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        self.descricao.layer.cornerRadius = 8
        descricao.layer.masksToBounds = true
        
    }
    
    @IBAction func showEarth(_ sender: UIButton) {
        
        if (CrostaEmExibicao) {
            self.CrostaEmExibicao = false
            self.earthNode!.runAction(SCNAction.fadeOut(duration: 1)){
                self.earthNode!.removeFromParentNode()
            }
            
            self.descricao.isHidden = true
            self.descricao.text = ""
            
        } else {

            self.descricao.isHidden = false
            self.descricao.text = "Esta e a terra!!"
            
            self.earthNode = SCNScene(named: "art.scnassets/Earth.dae")!.rootNode.childNode(withName: "Earth", recursively: true)
            self.CrostaEmExibicao = true
            
            self.earthNode!.position.x = planePosition.position.x
            self.earthNode!.position.y = -0.15045047
            self.earthNode!.position.z = planePosition.position.z
            
            self.sceneView.scene.rootNode.addChildNode(self.earthNode!)
            let repeteDenovo = SCNAction.repeatForever( SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi * 2), z: 0, duration: 20) )
            self.earthNode!.runAction(repeteDenovo)
        }
    }
    
    @IBAction func showManto(_ sender: UIButton) {
        
        if (mantoEmExibicao) {
            
            self.mantoEmExibicao = false
            self.mantoNode!.runAction(SCNAction.fadeOut(duration: 1)){
                self.mantoNode!.removeFromParentNode()
                
            }
            
            self.descricao.isHidden = true
            self.descricao.text = ""
            
        } else {
            
            self.descricao.isHidden = false
            self.descricao.text = "Este e o Manto da terra!!"
            
            self.mantoNode = SCNScene(named: "art.scnassets/manto.dae")!.rootNode.childNode(withName: "manto", recursively: true)
            self.mantoEmExibicao = true
            
            self.mantoNode!.position.x = planePosition.position.x
            self.mantoNode!.position.y = -0.15045047
            self.mantoNode!.position.z = planePosition.position.z
            
            self.sceneView.scene.rootNode.addChildNode(self.mantoNode!)
            let repeteDenovo = SCNAction.repeatForever( SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi * 2), z: 0, duration: 20) )
            self.mantoNode!.runAction(repeteDenovo)
        }
        
    }
    
    
    @IBAction func showNucleo(_ sender: UIButton) {
        
        if (nucleoEmExibicao) {
            
            self.nucleoEmExibicao = false
            self.nucleoNode!.runAction(SCNAction.fadeOut(duration: 1)){
                self.nucleoNode!.removeFromParentNode()
            }
            
            self.descricao.isHidden = true
            self.descricao.text = ""
            
        } else {
            
            self.descricao.isHidden = false
            self.descricao.text = "Este e o Nucleo da terra!!"

            self.nucleoNode = SCNScene(named: "art.scnassets/nucleo.dae")!.rootNode.childNode(withName: "nucleo", recursively: true)
            self.nucleoEmExibicao = true
            
            self.nucleoNode!.position.x = planePosition.position.x
            self.nucleoNode!.position.y = -0.15045047
            self.nucleoNode!.position.z = planePosition.position.z

            print("posicao do node")
            print(self.nucleoNode!.position)
            
            self.sceneView.scene.rootNode.addChildNode(self.nucleoNode!)
            let repeteDenovo = SCNAction.repeatForever( SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi * 2), z: 0, duration: 20) )
            self.nucleoNode!.runAction(repeteDenovo)
        }
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let anchor = anchor as? ARPlaneAnchor {
            createPlane(node: node, anchor: anchor)
        }
    }
    
    private func createPlane(node: SCNNode, anchor: ARPlaneAnchor) {
        let plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        
        let planeNode = SCNNode()
        planeNode.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
        
        if (!self.planDetected) {
            print("Plano Detectado")
            self.planePosition.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
            self.planDetected = true
        }
        
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.blue
        
        plane.materials = [material]
        planeNode.geometry = plane
        
        node.addChildNode(planeNode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        sceneView.session.pause()
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    

}
