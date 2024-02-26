//
//  AppDelegate.swift
//  NativeiOSApp
//
//  Created by 児玉広樹 on 2020/05/14.
//  Copyright © 2020 unity. All rights reserved.
//

import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UnityFrameworkListener, NativeCallsProtocol {
    var window: UIWindow?
    var application: UIApplication?
    var storyboard: UIStoryboard?
    var hostViewController: HostViewController!
    var appLaunchOpts: [UIApplication.LaunchOptionsKey: Any]?
    var unityView: UnityUIView?
    var didQuit: Bool = false

    @objc var currentUnityController: UnityAppController!
    @objc var ufw: UnityFramework?

    func UnityFrameworkLoad() -> UnityFramework {
        let bundlePath = Bundle.main.bundlePath
        let frameworkPath = bundlePath + "/Frameworks/UnityFramework.framework"
        let bundle = Bundle(path: frameworkPath)!
        if !bundle.isLoaded {
            bundle.load()
        }
        let frameworkClass = bundle.principalClass as! UnityFramework.Type
        let ufw = frameworkClass.getInstance()!
        if ufw.appController() == nil {
            var header = _mh_execute_header
            ufw.setExecuteHeader(&header)
        }
        return ufw
    }

    func showAlert(_ title:String, _ msg:String) {
        let alert: UIAlertController = UIAlertController(title: title, message: msg, preferredStyle:  .alert)

        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
        })
        
        alert.addAction(defaultAction)
        window?.rootViewController?.present(alert, animated: true)
    }
    
    func unityIsInitialized()->Bool {
        return (self.ufw != nil && self.ufw?.appController() != nil)
    }

    //Unityのウインドウを表示する
    func showMainView() {
        if(!unityIsInitialized()) {
            showAlert("Unity is not initialized", "Initialize Unity first");
        } else {
            //Unityのウインドウを表示する
            self.ufw?.showUnityWindow();
        }
    }
    
    func showHostMainWindow() {
        self.showHostMainWindow("")
    }

    func showHostMainWindow(_ color: String!) {
        if(color == "blue") {
            self.hostViewController.unpauseBtn.backgroundColor = .blue
        } else if(color == "red") {
            self.hostViewController.unpauseBtn.backgroundColor = .red
        }else if(color == "yellow") {
            self.hostViewController.unpauseBtn.backgroundColor = .yellow
        }
        
        //windowを前面に
        window?.makeKeyAndVisible()
    }
    
    func sendMsgToUnity() {
    //ここでufwにメッセージを送信する
        self.ufw?.sendMessageToGO(withName: "Cube", functionName: "ChangeColor", message: "yellow");
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.application = application
        ufw = UnityFrameworkLoad()

        appLaunchOpts = launchOptions
        
        storyboard = UIStoryboard(name: "Main", bundle: .main)
        hostViewController = storyboard?.instantiateViewController(withIdentifier: "Host") as! HostViewController
        
        // Set root view controller and make windows visible
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.rootViewController = hostViewController;
        
        window?.makeKeyAndVisible()
        return true
    }

    func initUnity(){
        if(unityIsInitialized()) {
            showAlert("Unity already initialized", "Unload Unity first")
            return
        }
        
        if(didQuit) {
            showAlert("Unity cannot be initialized after quit", "Use unload instead")
            return
        }

        ufw?.register(self)
        FrameworkLibAPI.registerAPIforNativeCalls(self)
        ufw?.setDataBundleId("com.unity3d.framework")
        ufw?.runEmbedded(withArgc: CommandLine.argc, argv: CommandLine.unsafeArgv, appLaunchOpts: appLaunchOpts)
        
        // set quit handler to change default behavior of exit app
//        ufw.appController()?.quitHandler
        
        //ufwのUIView
        let view:UIView? = ufw?.appController()?.rootView;
        
        //各種ボタンが配置されていない場合にviewにボタンを再配置する
        if self.unityView == nil {
            self.unityView = UnityUIView()
            view?.addSubview(self.unityView as! UnityUIView)
        }
    }

    func unloadButtonTouched(_ sender: UIButton)
    {
        if(!unityIsInitialized()) {
            showAlert("Unity is not initialized", "Initialize Unity first")
        } else {
            UnityFrameworkLoad().unloadApplication()
        }
    }
    
    func quitButtonTouched(_ sender:UIButton)
    {
        if(!unityIsInitialized()) {
            showAlert("Unity is not initialized", "Initialize Unity first");
        } else {
            UnityFrameworkLoad().quitApplication(0)
        }
    }
    
    //UnityFramework.h にて　UnityFrameworkListenerとして宣言されている
    func unityDidUnload(notification: Notification)
    {
        print("unityDidUnload called")
        self.ufw?.unregisterFrameworkListener(self)
        self.ufw = nil
        self.showHostMainWindow("")
    }
    
    //UnityFramework.h にて　UnityFrameworkListenerとして宣言されている
    func unityDidQuit(notification: Notification)
    {
        print("unityDidQuit called")
        self.ufw?.unregisterFrameworkListener(self)
        self.ufw = nil
        self.didQuit = true
        self.showHostMainWindow("")
    }
}

// MARK: - private

private extension AppDelegate {

    func setRootVC() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = RootViewController()
        window?.makeKeyAndVisible()
    }
}


