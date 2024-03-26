//
//  ArTextViewController.swift
//  NativeiOSApp
//
//  Created by minato on 2024/03/14.
//  Copyright © 2024 unity. All rights reserved.
//

import UIKit
import ARKit

class ArTextViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var isRotationInitialized = false // フラグを追加
    var northRotate: SCNVector4? // 北方向を保持する変数を追加

    @IBOutlet weak var ARView: ARSCNView!

    override func viewDidLoad() {
        super.viewDidLoad()
        ARView.session = ARSession()

        ARView.showsStatistics = true
        ARView.debugOptions = ARSCNDebugOptions.showFeaturePoints

        locationManager.delegate = self
        locationManager.startUpdatingHeading()
    }

    override func viewDidAppear(_ animated: Bool) {
        let configuration = ARWorldTrackingConfiguration()
        ARView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        ARView.session.pause()
    }

    @IBAction func handleTap(_ sender: Any) {
        guard let camera = ARView.pointOfView else { return }
        guard let rotation = northRotate else { return } // northRotateの初期化を確認

        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        let boxNode = SCNNode(geometry: box)

        let relativePosition = SCNVector3(x: 0, y: 0, z: -1)
        camera.rotation = rotation // カメラの回転を北に向ける
        boxNode.position = camera.convertPosition(relativePosition, to: nil)

        ARView.scene.rootNode.addChildNode(boxNode)
    }


    func locationManager(_ manager:CLLocationManager,didUpdateHeading newHeading:CLHeading){
       let nowHeading = newHeading.magneticHeading // 現在向いている方向を0度~359度で取得

       if !isRotationInitialized {
           // (x軸, y軸, z軸, 回転)で回転を表現
           // 回転はラジアンで受け付けるため度数を変換している
           northRotate = SCNVector4(0, 1, 0, (nowHeading / 180) * Double.pi)
           isRotationInitialized = true
       }
    }


}
