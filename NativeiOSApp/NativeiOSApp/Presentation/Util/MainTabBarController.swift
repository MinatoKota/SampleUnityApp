//
//  MainTabBarController.swift
//  NativeiOSApp
//
//  Created by minato on 2024/02/26.
//  Copyright © 2024 unity. All rights reserved.
//

import UIKit

protocol Scrollable: AnyObject {
    func scrollToTop(_ tabBarController: MainTabBarController)
}

/// メインのタブを生成しているファイルです
final class MainTabBarController: UITabBarController {

    private var currentItemIndex = 0
    private var nextItemIndex = 0

    static let SEARCH_INDEX = 0
    static let MESSAGE_INDEX = 1
    static let TIMELINE_INDEX = 2
    static let BOARD_INDEX = 3
    static let MY_PAGE_INDEX = 4

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarLayout()
        delegate = self
        setViewControllers(createTabBarsVC(), animated: false)
    }

}

// MARK: - UITabBarControllerDelegate

extension MainTabBarController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        currentItemIndex = tabBarController.selectedIndex
        return true
    }

    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        nextItemIndex = tabBarController.selectedIndex
        guard currentItemIndex == nextItemIndex else { return }

        if let nav = viewController as? UINavigationController,
           let current = nav.visibleViewController,
           let scrollable = current as? Scrollable {
            scrollable.scrollToTop(self)
        }
    }

}

// MARK: - Private Extension

private extension MainTabBarController {

    func createTabBarsVC() -> [UIViewController] {
        var viewControllers: [UIViewController] = []

        // さがす画面
        let searchUserViewController = generateViewController(tabTitle: "さがす", vc: HostViewController(),
                                                              tabImage: UIImage(systemName: "magnifyingglass")!.withTintColor(.systemGray),
                                                              selectedImage: UIImage(systemName: "magnifyingglass")!.withTintColor(.black))

        viewControllers.append(searchUserViewController)

        // メッセージ一覧
        let messageViewController = generateViewController(tabTitle: "メッセージ", vc: ConversationListViewController(),
                                                           tabImage: UIImage(named: "chat")!.withTintColor(.systemGray),
                                                           selectedImage: UIImage(named: "chat")!.withTintColor(.black))
        viewControllers.append(messageViewController)

        // 掲示板
        let boardVC = BoardViewController()
        let boardViewController = generateViewController(tabTitle: "掲示板", vc: boardVC,
                                                         tabImage: UIImage(systemName: "note.text")!.withTintColor(.systemGray),
                                                         selectedImage: UIImage(systemName: "note.text")!.withTintColor(.black))
        viewControllers.append(boardViewController)


        // マイページタブ
        let myPageViewController = generateViewController(tabTitle: "マイページ", vc: MyPageViewController(),
                                                          tabImage: UIImage(systemName: "person")!.withTintColor(.systemGray),
                                                          selectedImage: UIImage(systemName: "person")!.withTintColor(.black))

        viewControllers.append(myPageViewController)
        return viewControllers
    }

    func generateViewController(tabTitle: String?, vc: UIViewController,
                                tabImage: UIImage, selectedImage: UIImage) -> UIViewController {
        let navigationController =  MainNavigationController(rootViewController: vc)
        navigationController.tabBarItem.image = tabImage.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let image = selectedImage.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        navigationController.tabBarItem.selectedImage = image
        navigationController.tabBarItem.title = tabTitle
        return navigationController
    }

    func configureTabBarLayout() {
        tabBar.backgroundColor = .clear
        UITabBar.appearance().tintColor = .black
        UITabBar.appearance().backgroundColor = .systemGray5
    }
}

