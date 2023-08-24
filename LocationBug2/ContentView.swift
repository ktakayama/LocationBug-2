//
//  ContentView.swift
//  LocationBug2
//
//  Created by Kyosuke Takayama on 2023/07/11.
//

import SwiftUI
import EventKit
import EventKitUI

var globalEvent: EKEvent? = nil

struct ContentView: View {
    @State private var isShowingEventController = false
    @State private var isShowingEventEditController = false
    let eventStore = EKEventStore()

    var body: some View {
        VStack {
            Spacer()

            Text("To reproduce the bug, please follow these steps:")
            ScrollView {
                VStack(alignment: .leading, spacing: 6) {
                    Text("1. Tap the 'Create/Edit event' button below to open the event editing screen.")
                    Text("2. Select 'Location' and choose a place.")
                    Text("3. Manually enter 'Tokyo Tower.'")
                    Text("4. Select 'Tokyo Tower' from 'Map Locations.'")
                    Text("5. Save the event.")
                    Text("6. Tap 'Show event.' The bug will be reproduced.")
                }
            }
            .frame(maxHeight: 260)

            Button(action: {
                requestAccessToCalendar {
                    prepareEvent { event in
                        globalEvent = event
                        self.isShowingEventController = true
                    }
                }
            }) {
                Text("Create/Edit event")
            }
            .sheet(isPresented: $isShowingEventController, content: {
                EventEditViewControllerWrapper(event: globalEvent)
            })

            Spacer()

            Button(action: {
                requestAccessToCalendar {
                    prepareEvent { event in
                        globalEvent = event
                        self.isShowingEventEditController = true
                    }
                }
            }) {
                Text("Show event")
            }
            .sheet(isPresented: $isShowingEventEditController, content: {
                EventViewControllerWrapper(event: globalEvent)
            })

            Spacer()

        }
        .padding()
    }

    private func requestAccessToCalendar(completion: @escaping () -> Void) {
        eventStore.requestFullAccessToEvents { (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    completion()
                }
            } else if let error = error {
                print("Failed to request access: \(error)")
            }
        }
    }

    private func prepareEvent(completion: @escaping (EKEvent?) -> Void) {
        let predicate = eventStore.predicateForEvents(withStart: Date().addingTimeInterval(-3600*24*30),
                                                      end: Date().addingTimeInterval(3600*24*30),
                                                      calendars: [])
        let events = eventStore.events(matching: predicate)
        let event = events.filter({ $0.title == "LocationBug" }).first

        if(event == nil) {
            let e = EKEvent(eventStore: eventStore)
            e.title = "LocationBug"
            DispatchQueue.main.async {
                completion(e)
            }
        } else {
            DispatchQueue.main.async {
                completion(event)
            }
        }
    }
}

struct EventViewControllerWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = UINavigationController

    var event: EKEvent?

    func makeUIViewController(context: Context) -> UINavigationController {
        let eventController = EKEventViewController()
        eventController.event = event
        eventController.delegate = context.coordinator
        return UINavigationController(rootViewController: eventController)
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, EKEventViewDelegate {
        func eventViewController(_ controller: EKEventViewController, didCompleteWith action: EKEventViewAction) {
            controller.dismiss(animated: true)
        }
    }
}

struct EventEditViewControllerWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = UINavigationController

    var event: EKEvent?

    func makeUIViewController(context: Context) -> UINavigationController {
        let eventController = EKEventEditViewController()
        eventController.event = event
        eventController.editViewDelegate = context.coordinator
        return eventController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, EKEventEditViewDelegate {
        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            controller.dismiss(animated: true)
        }
    }
}
