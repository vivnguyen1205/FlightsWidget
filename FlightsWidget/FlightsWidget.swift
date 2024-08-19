//
//  FlightsWidget.swift
//  FlightsWidget
//
//  Created by Vivian Nguyen on 2024-08-17.
//

import WidgetKit
import SwiftUI

// Define the structure for the flight data fetched from the API
struct FlightData: Decodable {
    let pointA: String
    let pointB: String
    let flightNumber: String
}

// Define the timeline provider to manage the widget's timeline
struct Provider: TimelineProvider {
    
    // Placeholder data for the widget when no data is available
    func placeholder(in context: Context) -> LocationDetails {
        LocationDetails(date: Date(), emoji: "😀", pointA: "LAX", pointB: "SGN", flightNumber: "UA 265")
    }

    // Fetch flight data from the API
    func fetchFlightData(completion: @escaping (FlightData?) -> Void) {
        guard let url = URL(string: "https://fake-json-api.mock.beeceptor.com/users") else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let flightData = try decoder.decode(FlightData.self, from: data)
                completion(flightData)
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }

    // Provide a snapshot of the current widget state
    func getSnapshot(in context: Context, completion: @escaping (LocationDetails) -> ()) {
        fetchFlightData { flightData in
            let entry: LocationDetails
            if let data = flightData {
                entry = LocationDetails(date: Date(), emoji: "😀", pointA: data.pointA, pointB: data.pointB, flightNumber: data.flightNumber)
            } else {
                entry = LocationDetails(date: Date(), emoji: "😀", pointA: "LAX", pointB: "SGN", flightNumber: "UA 265")
            }
            completion(entry)
        }
    }

    // Generate the timeline entries for the widget
    func getTimeline(in context: Context, completion: @escaping (Timeline<LocationDetails>) -> ()) {
        fetchFlightData { flightData in
            var entries: [LocationDetails] = []
            let currentDate = Date()

            for hourOffset in 0 ..< 5 {
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                let entry: LocationDetails
                if let data = flightData {
                    entry = LocationDetails(date: entryDate, emoji: "😀", pointA: data.pointA, pointB: data.pointB, flightNumber: data.flightNumber)
                } else {
                    entry = LocationDetails(date: entryDate, emoji: "😀", pointA: "LAX", pointB: "SGN", flightNumber: "UA 265")
                }
                entries.append(entry)
            }

            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

// Define the data model for the widget entries
struct LocationDetails: TimelineEntry {
    let date: Date
    let emoji: String
    let pointA: String
    let pointB: String
    let flightNumber: String
}

// Define the view that displays the widget
struct FlightsWidgetEntryView: View {
    var entry: LocationDetails

    var body: some View {
        VStack {
            HStack {
                Text(entry.pointA).font(.title3)
                Text("→").font(.title3)
                Text(entry.pointB).font(.title3)
            }
            HStack {
                Text(entry.flightNumber).font(.subheadline)
            }
            Spacer()
            HStack {
                Text("Departure")
            }
        }
    }
}

// Define the widget configuration
struct FlightsWidget: Widget {
    let kind: String = "FlightsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                FlightsWidgetEntryView(entry: entry)
                    .containerBackground(.white.gradient, for: .widget)
            } else {
                FlightsWidgetEntryView(entry: entry)
            }
        }
        .configurationDisplayName("Flight Info Widget")
        .description("Displays the latest flight information.")
    }
}

// Preview the widget in different states
#Preview(as: .systemSmall) {
    FlightsWidget()
} timeline: {
    LocationDetails(date: .now, emoji: "😀", pointA: "LAX", pointB: "SGN", flightNumber: "UA 265")
    LocationDetails(date: .now, emoji: "🤩", pointA: "LAX", pointB: "SGN", flightNumber: "UA 265")
}

