//
//  Router.swift
//  Sketching_App
//
//  Created by Esraa on 16/06/2022.
//

import UIKit
import Foundation


protocol Router {
    var tabBarController: UITabBarController { get set }
    func showDrawing(drawing: DrawingModel)

    init(n: UINavigationController, a: Assembly?)
}

class MainRouter:  NSObject,  Router {
    var tabBarController: UITabBarController
    var navigationController: UINavigationController

    private var a: Assembly?


    func initial() {
        guard let drawingViewController = a?.drawingController(self) else { return }
        guard let historyViewController = a?.historyController(self) else { return }

        let controllers = [drawingViewController, historyViewController]

        prepareTabBarController(withTabControllers: controllers)
    }

    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        navigationController.setNavigationBarHidden(false, animated: false)


        /// Set delegate for UITabBarController
        tabBarController.delegate = self
        /// Assign page's controllers
        tabBarController.setViewControllers(tabControllers, animated: true)
        /// Let set index
        tabBarController.selectedIndex = TabBarPage.drawing.pageOrderNumber()
        /// Styling
        tabBarController.tabBar.isTranslucent = false

       navigationController.viewControllers = [tabBarController]

    }



    private func getTabController(_ page: TabBarPage) -> UINavigationController {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        navigationController.setNavigationBarHidden(false, animated: false)

        navigationController.tabBarItem = UITabBarItem.init(title: page.pageTitleValue(),
                                                     image: nil,
                                                     tag: page.pageOrderNumber())

        switch page {

        case .drawing:

            guard let drawingViewController = storyboard.instantiateViewController(withIdentifier: "DrawingViewController") as? DrawingViewController else {
                      return navigationController
                  }
            navigationController.pushViewController(drawingViewController, animated: true)

        case .history:

            guard let historyViewController = storyboard.instantiateViewController(withIdentifier: "HistoryViewController") as? DrawingViewController else {
                      return navigationController
                  }
            navigationController.pushViewController(historyViewController, animated: true)

        }


        return navigationController

}

    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.pageOrderNumber()
    }


    func showDrawing(drawing: DrawingModel) {
        print("ana henaaaa")
    }


    required init(n: UINavigationController, a: Assembly?) {
        self.navigationController = n
        self.tabBarController = .init()
        self.a = a
    }
}


enum TabBarPage {
    case drawing
    case history


    init?(index: Int) {
        switch index {
        case 0:
            self = .drawing
        case 1:
            self = .history
        default:
            return nil
        }
    }

    func pageTitleValue() -> String {
        switch self {
        case .drawing:
            return "Drawing"
        case .history:
            return "History"

        }
    }

    func pageOrderNumber() -> Int {
        switch self {
        case .drawing:
            return 0
        case .history:
            return 1

        }
    }

    // Add tab icon value

    // Add tab icon selected / deselected color

    // etc
}


// MARK: - UITabBarControllerDelegate

extension MainRouter: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
}

}
