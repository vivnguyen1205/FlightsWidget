//
//  FlightsWidget.swift
//  FlightsWidget
//
//  Created by Vivian Nguyen on 2024-08-17.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider { // type that tells te widget when to display 
    func placeholder(in context: Context) -> LocationDetails { // dummy view - what it will show when there is no data
        LocationDetails(date: Date(), emoji: "😀", pointA: "LAX", pointB: "SGN", flightNumber: "UA 265")
    }

    func getSnapshot(in context: Context, completion: @escaping (LocationDetails) -> ()) { // what the actual widget looks right now with the latest data
        let entry = LocationDetails(date: Date(), emoji: "😀",pointA: "LAX", pointB: "SGN", flightNumber: "UA 265")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // timeline - array of entries (data)
        var entries: [LocationDetails] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = LocationDetails(date: entryDate, emoji: "😀",pointA: "LAX", pointB: "SGN", flightNumber: "UA 265")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct LocationDetails: TimelineEntry {
    // data model
    // this is the data
    let date: Date
    let emoji: String
    let pointA: String
    let pointB: String
    let flightNumber: String
}

struct FlightsWidgetEntryView : View {
    // the view: the swiftUI
    var entry: LocationDetails

    var body: some View {
        VStack{
            HStack{
                Text(entry.pointA).font(.title3)
                Text("→").font(.title3)
                Text(entry.pointB).font(.title3)
                
            }
            HStack{
                Text(entry.flightNumber).font(.subheadline)
                Text("           ")
                
            }
            Spacer()
        }
        HStack{
            Text("depature")
        }
    }
}

struct FlightsWidget: Widget {
     
    let kind: String = "FlightsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                FlightsWidgetEntryView(entry: entry)
                    .containerBackground(.indigo.gradient, for: .widget)
            } else {
                FlightsWidgetEntryView(entry: entry)
                // .padding()
                .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }

}

#Preview(as: .systemSmall) {
    FlightsWidget()
} timeline: {
    LocationDetails(date: .now, emoji: "😀", pointA: "LAX", pointB: "SGN", flightNumber: "UA 265")
    LocationDetails(date: .now, emoji: "🤩", pointA: "LAX", pointB: "SGN", flightNumber: "UA 265")
}
//extension FlightInfo{
//    
//    var locationFormat: String{
//
//    }
