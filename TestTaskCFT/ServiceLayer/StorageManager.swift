//
//  StorageManager.swift
//  TestTaskCFT
//
//  Created by Антон Денисюк on 27.12.2022.
//

import Foundation

final class StorageManager {

    // MARK: - Static Properties
    static let shared = StorageManager()

    private let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let archiveURL: URL

    // MARK: - Initializers

    init() {
        archiveURL = documentDirectory.appendingPathComponent("Notes").appendingPathExtension("plist")
    }

    // MARK: - Public Methods

    func saveToFile(with note: Note) {
        var notes = fetchFromFile()
        notes.append(note)
        guard let data = try? PropertyListEncoder().encode(notes) else { return }
        try? data .write(to: archiveURL, options: .noFileProtection)
    }

    func saveToFileByIndex(with note: Note, at index: Int) {
        var notes = fetchFromFile()
        notes.insert(note, at: index)
        guard let data = try? PropertyListEncoder().encode(notes) else { return }
        try? data .write(to: archiveURL, options: .noFileProtection)
    }

    func fetchFromFile() -> [Note] {
        guard let data = try? Data(contentsOf: archiveURL) else { return [] }
        guard let notes = try? PropertyListDecoder().decode([Note].self, from: data) else { return [] }
        return notes
    }

    func deleteFromFile(at index: Int) {
        var notes = fetchFromFile()
        notes.remove(at: index)
        guard let data = try? PropertyListEncoder().encode(notes) else { return }
        try? data .write(to: archiveURL, options: .noFileProtection)
    }
}
