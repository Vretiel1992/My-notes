//
//  NoteModel.swift
//  TestTaskCFT
//
//  Created by Антон Денисюк on 24.12.2022.
//

import Foundation

struct Note: Codable {
    let title, subtitle, date: String
}

extension Note {
    static func getFirstNote() -> [Note] {
        [
            Note(
                title: "Моя первая заметка",
                subtitle: "В данной заметке содержится определенный текст",
                date: "24.12.2022 15:45"
            )
        ]
    }
}
