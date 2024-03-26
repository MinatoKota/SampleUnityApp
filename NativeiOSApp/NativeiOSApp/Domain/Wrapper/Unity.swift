//
//  Unity.swift
//  NativeiOSApp
//
//  Created by minato on 2024/02/26.
//  Copyright © 2024 unity. All rights reserved.
//

import Foundation

final class Unity: NSObject, UnityFrameworkListener {

    static let shared = Unity()
    private let unityFramework: UnityFramework

    override init() {
        let bundlePath = Bundle.main.bundlePath
        let frameworkPath = bundlePath + "/Frameworks/UnityFramework.framework"
        let bundle = Bundle(path: frameworkPath)!
        if !bundle.isLoaded {
            bundle.load()
        }
        let frameworkClass = bundle.principalClass as! UnityFramework.Type
        let framework = frameworkClass.getInstance()!
        if framework.appController() == nil {
            var header = _mh_execute_header
            framework.setExecuteHeader(&header)
        }
        unityFramework = framework
        super.init()
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) {
        unityFramework.register(self)
        unityFramework.setDataBundleId("com.unity3d.framework")
        unityFramework.runEmbedded(withArgc: CommandLine.argc,
                                   argv: CommandLine.unsafeArgv, appLaunchOpts: launchOptions)
    }

    var view: UIView {
        unityFramework.appController()!.rootView!
    }

    func stopUnity() {
        unityFramework.pause(true)
        print("🚀Unityを停止しました")
    }

    func showUnity() {
        unityFramework.showUnityWindow()
    }

    func sendMessageToUnity(objectName: String, functionName: String, argument: String) {
        unityFramework.sendMessageToGO(withName: objectName, functionName: functionName, message: argument)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        unityFramework.appController()?.applicationWillResignActive(application)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        unityFramework.appController()?.applicationDidEnterBackground(application)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        unityFramework.appController()?.applicationWillEnterForeground(application)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        unityFramework.appController()?.applicationDidBecomeActive(application)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        unityFramework.appController()?.applicationWillTerminate(application)
    }
}
