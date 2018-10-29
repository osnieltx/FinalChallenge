//
//  MainRouter.swift
//  FinalChallenge
//
//  Created Guilherme Paciulli on 29/10/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class MainRouter: NSObject, MainRouterProtocol {

	// MARK: - Constants
	private let storyBoardName = "Main"
	private let viewIdentifier = "MainView"

	// MARK: - Viper Module Properties
	weak var view: MainView!

	// MARK: - Constructors
	override init() {
		super.init()

		let view = self.viewControllerFromStoryboard()
		let presenter = MainPresenter()

		presenter.router = self
		presenter.view = view

		view.presenter = presenter

		self.view = view
	}

    // MARK: - MainRouterProtocol
    func presentAsRoot(window: UIWindow) {
        window.rootViewController = self.view
    }

	// MARK: - Private methods
	private func viewControllerFromStoryboard() -> MainView {
		let storyboard = UIStoryboard(name: self.storyBoardName, bundle: nil)
		let viewController = storyboard.instantiateViewController(withIdentifier: self.viewIdentifier) as! MainView
        
        let daySummaryViewRouter = DaySummaryRouter()
        daySummaryViewRouter.view.tabBarItem = UITabBarItem.init(tabBarSystemItem: .bookmarks, tag: 0)
        
        viewController.viewControllers = [daySummaryViewRouter.view]

		return viewController
	}
}