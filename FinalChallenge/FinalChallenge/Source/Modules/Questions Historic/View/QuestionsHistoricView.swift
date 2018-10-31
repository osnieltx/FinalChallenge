//
//  QuestionsHistoricView.swift
//  FinalChallenge
//
//  Created Guilherme Paciulli on 31/10/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class QuestionsHistoricView: UIViewController, QuestionsHistoricPresenterOutputProtocol, UITableViewDataSource, UITableViewDelegate {

	// MARK: - Viper Module Properties
	var presenter: QuestionsHistoricPresenterInputProtocol!
    
    // MARK: - Properties
    @IBOutlet var tableView: UITableView!
    let reuseIdentifierCell = "questionsHistoricCell"
    let reuseIdentifierHeader = "questionsHistoricHeader"
    
    // MARK: - Override methods
	override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "QuestionsHistoricHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: self.reuseIdentifierHeader)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifierCell) as? QuestionsHistoricCell else {
            return UITableViewCell()
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: self.reuseIdentifierHeader) as? QuestionsHistoricHeaderView else {
            return UIView()
        }
        
        return header
    }
    
    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK: - QuestionsHistoricPresenterOutputProtocol
    
    func showLoading(_ loading: Bool) {
        //FIXME: add activity controll on view if loading is true, otherwise, remove loading
    }
    
    func showError(message: String) {
        //FIXME: present the error message on view!
    }
    
    func didFetchQuestions() {
        self.tableView.reloadData()
    }

	// MARK: - Private Methods

}