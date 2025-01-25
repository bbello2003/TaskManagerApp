//
//  AddTaskView.swift
//  TaskManager
//
//  Created by Pasika Pongsawaluk on 25/1/2568 BE.
//

import Foundation
import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: TaskViewModel
    @Binding var taskToEdit: Task?

    @State private var name = ""
    @State private var deadline = Date()

    var body: some View {
        NavigationView {
            Form {
                TextField("Task Name", text: $name)
                DatePicker("Deadline", selection: $deadline, displayedComponents: [.date, .hourAndMinute])
            }
            .navigationTitle(taskToEdit == nil ? "Add Task" : "Edit Task")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let task = taskToEdit {
                            viewModel.updateTask(task: task, newName: name, newDeadline: deadline)
                        } else {
                            viewModel.addTask(name: name, deadline: deadline)
                        }
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
        .onAppear {
            if let task = taskToEdit {
                name = task.name
                deadline = task.deadline
            }
        }
    }
}
