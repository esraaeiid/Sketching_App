//
//  Assembly.swift
//  Sketching_App
//
//  Created by Esraa on 23/06/2022.
//

import Foundation
import UIKit

protocol Assembly {
    func drawingController(_ router: Router?) -> UIViewController
    func historyController(_ router: Router?) -> UIViewController
}

class MainAssembly: Assembly {

    private let storyboard = UIStoryboard(name: StoryboardIdentifier.main.rawValue, bundle: nil)

    func drawingController(_ router: Router?) -> UIViewController  {
        guard let drawingViewController = storyboard.instantiateViewController(withIdentifier: StoryboardIdentifier.drawingVC.rawValue) as? DrawingViewController else {
                  return  UIViewController()
              }

        let presenter = DrawingPresenter(router, output: drawingViewController)
        let manager = DrawingManager(view: drawingViewController.view, canvasView: drawingViewController.canvasView)
        drawingViewController.setManager(manager)
        drawingViewController.setPresenter(presenter)

        return drawingViewController
    }


    func historyController(_ router: Router?) -> UIViewController {
        guard let historyViewController = storyboard.instantiateViewController(withIdentifier: StoryboardIdentifier.historyVC.rawValue) as? HistoryViewController else {
                  return UIViewController()
              }

        return historyViewController
    }

/// StoryboardIdentifier
    enum StoryboardIdentifier: String {
        case main = "Main"
        case drawingVC = "DrawingViewController"
        case historyVC = "HistoryViewController"
    }
}
