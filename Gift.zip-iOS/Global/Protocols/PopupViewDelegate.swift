//
//  PopupViewDelegate.swift
//  Gift.zip-iOS
//
//  Created by 이재용 on 2021/01/26.
//

import Foundation

protocol PopupViewDelegate: class {
    func sendDateButtonTapped(_ date: Date?)
    
    func sendIconDataButtonTapped(_ icon: String, _ name: String)
}

extension PopupViewDelegate {
    func sendDateButtonTapped(_ date: Date?) {}
    
    func sendIconDataButtonTapped(_ icon: String, _ name: String) {}
}
