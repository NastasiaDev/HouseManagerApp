//
//  ObjectDataConverter.swift
//  HouseManagerApp
//
//  Created by Anastasia Larina on 06.02.2025.
//
import Foundation

final class ObjectDataConverter {
    static func groupObjectsByDate(_ data: [ObjectData]) -> [String: [String]] {
        var grouped: [String: [String]] = [:]

        for item in data {
            if let formattedDate = convertDate(dateString: item.date) {
                if grouped[formattedDate] == nil {
                    grouped[formattedDate] = []
                }
                grouped[formattedDate]?.append(contentsOf: item.objects)
            }
        }

        return grouped
    }

    private static func convertDate(dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }

        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
}
