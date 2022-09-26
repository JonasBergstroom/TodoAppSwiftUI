//
//  ContentView.swift
//  TodoAppSwiftUI
//
//  Created by Jonas Bergström on 2022-09-22.
//

import SwiftUI

enum Priority: String, Identifiable, CaseIterable {
    
    var id: UUID {
        return UUID()
    }
    
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

extension Priority {
    
    var title: String {
        switch self {
        case .low:
            return "Low"
        case .medium:
            return "Medium"
        case .high:
            return "High"
        }
    }
}

struct ContentView: View {
    
    @State private var title: String = ""
    @State private var selectedPriority: Priority = .medium
    @Environment(\.managedObjectContext) private var ViewContext
    
    @FetchRequest(entity: Task.entity(), sortDescriptors:
                    [NSSortDescriptor(key: "dateCreated", ascending: false)]) private
    var allTasks: FetchedResults<Task>
    
    
    private func saveTask() {
        
        do {
            let task = Task(context: ViewContext)
            task.title = title
            task.priority = selectedPriority.rawValue
            task.dateCreated = Date()
            try ViewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func styleForPriority(_ value: String) -> Color {
        let priority = Priority(rawValue: value)
        
        switch priority {
        case .low:
            return Color.green
        case .medium:
            return Color.orange
        case .high:
            return Color.red
        default:
            return Color.black
        }
    }
    
    private func updateTask(_ task: Task) {
        
        task.isDone = !task.isDone
        
        do {
            try ViewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func deleteTask(at offsets: IndexSet) {
        offsets.forEach { index in
            let task = allTasks[index]
            ViewContext.delete(task)
            
            do {
                try ViewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func clearTextField() {
        title = ""
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter task", text: $title)
                    .textFieldStyle(.roundedBorder)
                Picker("Priority", selection: $selectedPriority) {
                    ForEach(Priority.allCases) { priority  in
                        Text(priority.title).tag(priority)
                    }
                }.pickerStyle(.segmented)
                Button("Add task") {
                    saveTask()
                    clearTextField()
                }
                .padding(10)
                .frame(maxWidth: 320)
                .background(Color(hue: 0.293, saturation: 0.761, brightness: 0.819, opacity: 0.966))
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10.0, style:
                        .continuous))
                
                List {
                    ForEach(allTasks) { task in
                        HStack {
                            Circle()
                                .fill(styleForPriority(task.priority!))
                                .frame(width: 15, height: 15)
                            Spacer().frame(width: 20)
                            Text(task.title ?? "")
                            Spacer()
                            Image(systemName: task.isDone ? "checkmark.circle.fill" : "checkmark.circle")
                                .foregroundColor(.green)
                                .onTapGesture {
                                    updateTask(task)
                                }
                        }
                    }.onDelete(perform: deleteTask)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("To do")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let persistedContainer = CoreDataManager.shared.persistentContainer
        ContentView().environment(\.managedObjectContext,persistedContainer.viewContext)
    }
}
