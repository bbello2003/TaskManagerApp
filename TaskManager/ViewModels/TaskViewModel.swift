//
//  TaskViewModel.swift
//  TaskManager
//
//  Created by Pasika Pongsawaluk on 25/1/2568 BE.
//

import Foundation

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []

    private let fileName = "tasks.csv"

    init() {
        loadTasks()
    }

    func addTask(name: String, deadline: Date) {
        let newTask = Task(name: name, deadline: deadline)
        tasks.append(newTask)
        saveTasks()
    }

    func updateTask(task: Task, newName: String, newDeadline: Date) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].name = newName
            tasks[index].deadline = newDeadline
            saveTasks()
        }
    }

    func toggleTaskCompletion(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            saveTasks()
        }
    }

    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
        saveTasks()
    }

    private func saveTasks() {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        var csvText = "id,name,deadline,isCompleted\n"
        
        for task in tasks {
            let row = "\(task.id.uuidString),\(task.name),\(task.deadline.timeIntervalSince1970),\(task.isCompleted)\n"
            csvText += row
        }
        
        do {
            try csvText.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Error saving tasks: \(error)")
        }
    }

    private func loadTasks() {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        guard let data = try? String(contentsOf: fileURL, encoding: .utf8) else { return }

        let rows = data.components(separatedBy: "\n").dropFirst() // Skip header row

        tasks = rows.compactMap { row in
            let columns = row.components(separatedBy: ",")
            guard columns.count == 4,
                  let deadline = TimeInterval(columns[2]),
                  let isCompleted = Bool(columns[3]) else { return nil }

            return Task(
                name: columns[1],
                deadline: Date(timeIntervalSince1970: deadline),
                isCompleted: isCompleted
            )
        }
    }

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
