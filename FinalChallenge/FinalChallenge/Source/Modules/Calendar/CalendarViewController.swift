//
//  CalendarViewController.swift
//  FinalChallenge
//
//  Created by Osniel Lopes Teixeira on 02/10/18.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - IBOutlets
    @IBOutlet weak var weekdays: UIStackView!
    @IBOutlet weak var weekDaysTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var firstWeekdayLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var daysColletionView: UICollectionView!
    
    
    // MARK: - Properties
    
    var previousMonthLabel: UILabel!
    var currentMonthLabel: UILabel!
    var nextMonthLabel: UILabel!
    
    var previousMonthLabelLeadingConstraint: NSLayoutConstraint!
    var currentMonthLabelLeadingConstraint: NSLayoutConstraint!
    var nextMonthLabelLeadingConstraint: NSLayoutConstraint!
    
    var largeCalendarView = true
    var referenceDay = Date()
    var currentMonthLabelInitialFrame: CGRect!
    var originalMonthDays: [Date?] = []
    var currentMonthDays: [Date?] = []
    var calendar = Calendar(identifier: .gregorian)
    var summaryView: DailySummaryViewController?
    var horizontalTranslationLength: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        referenceDay = calendar.date(byAdding: .day, value: 14, to: referenceDay)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt_BR")
        dateFormatter.dateFormat = "MMMM"
        
        let safeAreaLayout = self.view.safeAreaLayoutGuide
        let firstDayOfTheWeekLabelExtraMargin = (firstWeekdayLabelWidthConstraint.constant/2)-weekdays.arrangedSubviews.first!.intrinsicContentSize.width/2
        
        currentMonthLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        currentMonthLabel.text = dateFormatter.string(from: referenceDay)
        currentMonthLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        self.view.addSubview(currentMonthLabel)
        currentMonthLabel.translatesAutoresizingMaskIntoConstraints = false
        currentMonthLabelLeadingConstraint = currentMonthLabel.leadingAnchor.constraint(equalTo: safeAreaLayout.leadingAnchor, constant: 30 + firstDayOfTheWeekLabelExtraMargin)
        currentMonthLabelLeadingConstraint.isActive = true
        currentMonthLabel.topAnchor.constraint(equalTo: safeAreaLayout.topAnchor, constant: 30).isActive = true
        
        nextMonthLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        nextMonthLabel.text = dateFormatter.string(from: calendar.date(byAdding: .month, value: 1, to: referenceDay)!)
        nextMonthLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        nextMonthLabel.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        self.view.addSubview(nextMonthLabel)
        nextMonthLabel.translatesAutoresizingMaskIntoConstraints = false
        nextMonthLabelLeadingConstraint = nextMonthLabel.leadingAnchor.constraint(equalTo: safeAreaLayout.leadingAnchor, constant: self.view.frame.width-nextMonthLabel.intrinsicContentSize.width/2)
        nextMonthLabelLeadingConstraint.isActive = true
        nextMonthLabel.topAnchor.constraint(equalTo: safeAreaLayout.topAnchor, constant: 30).isActive = true
        
        previousMonthLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        previousMonthLabel.text = dateFormatter.string(from: calendar.date(byAdding: .month, value: -1, to: referenceDay)!)
        previousMonthLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        self.view.addSubview(previousMonthLabel)
        previousMonthLabel.translatesAutoresizingMaskIntoConstraints = false
        let distanceBetweenCurrentAndNextMonth = nextMonthLabelLeadingConstraint.constant - currentMonthLabelLeadingConstraint.constant
        previousMonthLabelLeadingConstraint = previousMonthLabel.leadingAnchor.constraint(equalTo: safeAreaLayout.leadingAnchor, constant:  -distanceBetweenCurrentAndNextMonth)
        previousMonthLabelLeadingConstraint.isActive = true
        previousMonthLabel.topAnchor.constraint(equalTo: safeAreaLayout.topAnchor, constant: 30).isActive = true
        
        
        firstWeekdayLabelWidthConstraint.constant = (self.view.frame.width - 60) / 7
        //FIXME: horizontalTranslationLength ESTA ERRADO precisa ser a distancia entre as labels
        horizontalTranslationLength = daysColletionView.frame.width
        
        daysColletionView.dataSource = self
        daysColletionView.delegate = self
        daysColletionView.allowsSelection = true
        daysColletionView.allowsMultipleSelection = true
        
        let daysRange = calendar.range(of: .day, in: .month, for: referenceDay)
        let currentDay = calendar.component(.day, from: Date())
        currentMonthDays.append(contentsOf: Array(repeating: nil, count: calendar.component(.weekday, from: calendar.date(byAdding: .day, value: -currentDay+1, to: Date())!)-1))
        for i in -currentDay+1...daysRange!.count-currentDay {
            currentMonthDays.append(calendar.date(byAdding: .day, value: i, to: Date()))
        }
        originalMonthDays = currentMonthDays
        daysColletionView.collectionViewLayout = CalendarUICollectionViewFlowLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        for case let cell as CalendarCollectionViewCell in daysColletionView.visibleCells {
            guard cell.day != nil else { continue }
            let isToday = calendar.component(.year, from: Date()) == calendar.component(.year, from: cell.day) && calendar.component(.month, from: Date()) == calendar.component(.month, from: cell.day) && calendar.component(.day, from: Date()) == calendar.component(.day, from: cell.day)
            if isToday {
                daysColletionView.selectItem(at: daysColletionView.indexPath(for: cell), animated: false, scrollPosition: .centeredHorizontally)
            }
        }
    }
    
    //MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell else { return false }
        return cell.day != nil
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for cell in collectionView.visibleCells {
            if collectionView.indexPath(for: cell) == indexPath {
                cell.isSelected = true
            } else {
                collectionView.deselectItem(at: collectionView.indexPath(for: cell)!, animated: true)
            }
        }
        self.summaryView?.reloadSummary(forDate: self.getCurrentDate())
    }

    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return !collectionView.indexPathsForSelectedItems!.contains(indexPath)
    }

    //MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentMonthDays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "day", for: indexPath) as! CalendarCollectionViewCell
        cell.day = originalMonthDays[indexPath.row]
        cell.background.layer.cornerRadius = cell.bounds.height/2
        return cell
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightPerItem = collectionView.bounds.height/6
        return CGSize(width: (firstWeekdayLabelWidthConstraint.constant)-0.00001, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //MARK: - IBActions
    
    @IBAction func changeTheCalendarStatus() {
        
        return
        
        let weekOfCurrentDay = calendar.component(.weekOfMonth, from: (daysColletionView.cellForItem(at: daysColletionView.indexPathsForSelectedItems!.first!) as! CalendarCollectionViewCell).day)
        (daysColletionView.collectionViewLayout as! CalendarUICollectionViewFlowLayout).expanding = !largeCalendarView
        
        if largeCalendarView {
            
            var indexOfItemsToBeRemoved: [Int] = []
            for i in 0..<currentMonthDays.count {
                if i < (weekOfCurrentDay-1)*7 || i >= weekOfCurrentDay*7 {
                    indexOfItemsToBeRemoved.append(i)
                }
            }
            
            let indexPathOfItemsToBeRemoved = indexOfItemsToBeRemoved.map { (i) -> IndexPath in
                return IndexPath(item: i, section: 0)
            }
            
            for indexPath in daysColletionView!.indexPathsForSelectedItems! {
                if indexPathOfItemsToBeRemoved.contains(indexPath) {
                    fatalError("Trying to remove a selected item.")
                }
            }
            
            indexOfItemsToBeRemoved.reverse()
            for index in indexOfItemsToBeRemoved {
                currentMonthDays.remove(at: index)
            }

            (daysColletionView.collectionViewLayout as! CalendarUICollectionViewFlowLayout).weekOfCurrentDay = weekOfCurrentDay
            
            UIView.animate(withDuration: 1) {
                self.currentMonthLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.nextMonthLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.nextMonthLabel.alpha = 0
                self.weekDaysTopConstraint.constant -= self.currentMonthLabelInitialFrame.height/2
                self.view.layoutIfNeeded()
                self.daysColletionView.deleteItems(at: indexPathOfItemsToBeRemoved)
            }
            
        } else {
            
            var indexPathOfItemsToBeAdded: [IndexPath] = []
            for i in 0..<originalMonthDays.count {
                if i < (weekOfCurrentDay-1)*7 || i >= weekOfCurrentDay*7 {
                    indexPathOfItemsToBeAdded.append(IndexPath(item: i, section: 0))
                    currentMonthDays.insert(originalMonthDays[i], at: i)
                }
            }
            
            UIView.animate(withDuration: 1) {
                self.currentMonthLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.nextMonthLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.nextMonthLabel.alpha = 1
                self.weekDaysTopConstraint.constant += self.currentMonthLabelInitialFrame.height/2
                self.view.layoutIfNeeded()
                self.daysColletionView.insertItems(at: indexPathOfItemsToBeAdded)
                
            }
            //            daysColletionView.insertItems(at: [IndexPath(row: 0, section: 0)])
        }
        
        largeCalendarView = !largeCalendarView
    }
    
    // MARK: Animation Variables
    var changingMonthAnimation: UIViewPropertyAnimator!
    
    @IBAction func handlePan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        let horizontalPan = abs(Double(translation.x))
        // let percentageComplete = CGFloat((verticalPan - startPoint) / swipeLength) usar um valor definido para startPoint impediria o usuário de começar uma transição não solicitada
        let percentageComplete = CGFloat(horizontalPan/Double(horizontalTranslationLength))
        print(percentageComplete)
        switch sender.state {
        case .began:
            print("BEGAN")
            changingMonthAnimation = UIViewPropertyAnimator(duration: 2, curve: .linear, animations: {
                self.previousMonthLabelLeadingConstraint.constant = self.currentMonthLabelLeadingConstraint.constant
                self.currentMonthLabelLeadingConstraint.constant = self.view.frame.width - self.currentMonthLabel.intrinsicContentSize.width/2
                self.currentMonthLabel.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                self.nextMonthLabelLeadingConstraint.constant += self.view.frame.width
                self.view.layoutIfNeeded()
            })
            changingMonthAnimation.addCompletion { (animationPosition) in
                
                let placeholderLabel = self.nextMonthLabel
                self.nextMonthLabel = self.currentMonthLabel
                self.currentMonthLabel = self.previousMonthLabel
                self.previousMonthLabel = placeholderLabel
                
                let placeholderConstraint = self.nextMonthLabelLeadingConstraint
                self.nextMonthLabelLeadingConstraint = self.currentMonthLabelLeadingConstraint
                self.currentMonthLabelLeadingConstraint = self.previousMonthLabelLeadingConstraint
                self.previousMonthLabelLeadingConstraint = placeholderConstraint
            }
        
//            changingMonthAnimation.startAnimation()
            changingMonthAnimation.pauseAnimation()
        case .changed:
            print("DRAG CHANGED")
            print(changingMonthAnimation.fractionComplete)
            DispatchQueue.main.async {
                self.changingMonthAnimation.fractionComplete = percentageComplete
            }
            
        
        case .ended, .cancelled:
            print("ENDED OR CANCELLED")
            if percentageComplete > 0.3 {
                changingMonthAnimation.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            }
            
        default:
            break
        }
       
    }
    
    
    
    
     // MARK: - Auxiliar Functions
    func getCurrentDate() -> Date {
        let currentDay = (daysColletionView.cellForItem(at: (daysColletionView.indexPathsForSelectedItems?.first)!) as! CalendarCollectionViewCell).day
        return currentDay!
    }
 
    
    
    
}
