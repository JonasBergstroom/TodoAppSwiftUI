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

                }
                .padding(10)
                .frame(maxWidth: 320)
                .background(Color(hue: 0.293, saturation: 0.761, brightness: 0.819, opacity: 0.966))
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10.0, style:
                        .continuous))
                
                List {
                    
                    ForEach(allTasks) { task in
                        Text(task.title ?? "")
                    }
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
        ContentView()
    }
}
