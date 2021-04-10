//
//  Chronos_Widget.swift
//  Chronos Widget
//
//  Created by Nick Viscomi on 4/8/21.
//  Copyright © 2021 Nick Viscomi. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    typealias Entry = SimpleEntry
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), model: DataModel())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, model: DataModel())
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, model: DataModel())
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let model: DataModel
}

struct Chronos_WidgetEntryView : View {
    var entry: Provider.Entry

    @Environment(\.widgetFamily) var family
    var body: some View {
        switch family {
        case .systemSmall:
            SystemSmall()
        case .systemMedium:
            SystemMedium()
        case .systemLarge:
            SystemLarge()
        default:
            SystemSmall()
        }
    }
}

@main
struct Chronos_Widget: Widget {
    let kind: String = "Chronos_Widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            Chronos_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("STEM Chronos")
        .description("See the time left in the current period at a glance")
    }
}

struct Chronos_Widget_Previews: PreviewProvider {
    static var previews: some View {
        Chronos_WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), model: DataModel()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
