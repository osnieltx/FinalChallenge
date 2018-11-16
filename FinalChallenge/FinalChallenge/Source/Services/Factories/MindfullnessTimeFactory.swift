//
//  MindfullnessTimeFactory.swift
//  FinalChallenge
//
//  Created by Guilherme Paciulli on 16/11/18.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import Foundation

class MindfullnessTimeFactory {
    
    static let shared = MindfullnessTimeFactory()
    
    private init() {}
    
    func generateMindfullnessTime(from: Date, to: Date, striding: Int, stridingType: Calendar.Component, completion: @escaping (MindfullnessTimeDTO?, DataAccessError?) -> ()) {
        
        if to < from || striding <= 0 {
            fatalError()
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        
        var plots: [MindfullnessTimeChartPlot] = []
        
        var shouldContinue = true
        let workingDate = to
        while true {
            var isLast = false
            var fromDate = Calendar.current.date(byAdding: stridingType, value: -1 * striding, to: workingDate)!
            
            if fromDate < from {
                fromDate = from
                isLast = true
            }
            
            HealthKitManager.shared.retrieveMindfullness(from: fromDate, to: workingDate, completion: { fetchedTime, err in
                guard let time = fetchedTime, err == nil else {
                    shouldContinue = false
                    completion(nil, err)
                    return
                }
                let dateString = formatter.string(from: workingDate)
                plots.append(MindfullnessTimeChartPlot(value: time, label: dateString, date: workingDate))
                
                if isLast && shouldContinue {
                    plots.sort(by: { $0.date <= $1.date })
                    completion(MindfullnessTimeDTO(values: plots), nil)
                }
            })
            
        }
        
    }
    
}
