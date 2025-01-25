//
//  TaskListView.swift
//  TaskManager
//
//  Created by Pasika Pongsawaluk on 25/1/2568 BE.
//

import Foundation
import SwiftUI

struct TaskListView: View {
    @StateObject private var viewModel = TaskViewModel()
    @State private var showAddTaskView = false
    @State private var selectedTask: Task? = nil

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.tasks) { task in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(task.name).font(.headline)
                            Text(task.deadline, style: .date).font(.subheadline).foregroundColor(.gray)
                            Text(task.deadline, style: .time).font(.subheadline).foregroundColor(.gray)
                        }

                        Spacer()

                        Button(action: {
                            viewModel.toggleTaskCompletion(task: task)
                        }) {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(task.isCompleted ? .green : .gray)
                        }
                    }
                    .onTapGesture {
                        selectedTask = task
                        showAddTaskView.toggle()
                    }
                }
                .onDelete(perform: viewModel.deleteTask)
            }
            .navigationTitle("Task Manager")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        selectedTask = nil
                        showAddTaskView.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddTaskView) {
                AddTaskView(viewModel: viewModel, taskToEdit: $selectedTask)
            }
        }
    }
}
