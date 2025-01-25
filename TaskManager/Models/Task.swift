//
//  Task.swift
//  TaskManager
//
//  Created by Pasika Pongsawaluk on 25/1/2568 BE.
//

import Foundation

struct Task: Identifiable, Codable {
    let id: UUID
    var name: String
    var deadline: Date
    var isCompleted: Bool

    init(name: String, deadline: Date, isCompleted: Bool = false) {
        self.id = UUID()
        self.name = name
        self.deadline = deadline
        self.isCompleted = isCompleted
    }
}
