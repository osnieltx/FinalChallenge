//
//  InterfaceController.swift
//  Watch-App Extension
//
//  Created by Osniel Lopes Teixeira on 13/11/18.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var picker: WKInterfacePicker!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        var items: [WKPickerItem] = []
        for i in stride(from: 5, to: 1, by: -1) {
            let item = WKPickerItem()
            item.contentImage = WKImage(imageName: "mood\(i)-icon")
            item.title = "Mood \(i)"
            items.append(item)
        }
        picker.setItems(items)
        picker.focus()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func didTapSave() {
        self.presentAlert(withTitle: "Humor inserido com sucesso!", message: nil, preferredStyle: .alert, actions: [WKAlertAction(title: "Ok", style: .default, handler: {
            self.dismiss()
        })])
        print("Opa aqui a gente tem que implementar a rotina pra salvar o humor selecionado")
    }
    
}
