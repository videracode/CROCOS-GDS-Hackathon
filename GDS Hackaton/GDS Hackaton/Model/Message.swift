//
//  Message.swift
//  GDS Hackaton
//
//  Created by Abylaykhan Myrzakhanov on 21.04.2024.
//

import Foundation

struct Message: Identifiable {
    var id = UUID()
    var text: String
    var isUser: Bool
}
