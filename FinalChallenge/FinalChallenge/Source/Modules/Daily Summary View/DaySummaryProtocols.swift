//
//  DaySummaryProtocols.swift
//  FinalChallenge
//
//  Created by Guilherme Paciulli on 24/10/18.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Router
protocol DaySummaryRouterProtocol: class {
    func present(with viewController: UIViewController)
    func presentAsRoot(window: UIWindow)
    
    func presentCalendar()
    func presentAnswerQuestion()
}

// MARK: - Interactor
protocol DaySummaryInteractorInputProtocol {
    func fetchMoodTypes()
    func fetchMoods(forDate date: Date)
    func fetchAnswers(forDate date: Date)
}

protocol DaySummaryInteractorOutputProtocol: class {
    func handleSuccessFetchedMoodTypes(with results: [MoodType])
    func handleFailureFetchedMoodTypes(with message: String)
    
    func handleSuccessFetchedMood(with results: [MoodInput])
    func handleFailureFetchedMood(with message: String)
    
    func handleSuccessFetchedAnwsers(with results: [Answer])
    func handleFailureFetchedAnwsers(with message: String)
}

// MARK: - Presenter
protocol DaySummaryPresenterInputProtocol: class {
    func loadTodayEntries()
    
    func numberOfSections() -> Int
    func numberOfEntries(in section: Int) -> Int
    func item(at indexPath: Int) -> Any
    
    func didTapInsert(mood index: Int)
    func didTapInsertQuestion()
}

// MARK: - View
protocol DaySummaryPresenterOutputProtocol: class {
    func showLoading(_ loading: Bool)
    func showError(message: String)
    func reloadData()
}
