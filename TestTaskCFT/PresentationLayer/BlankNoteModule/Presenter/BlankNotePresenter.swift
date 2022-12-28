//
//  BlankNotePresenter.swift
//  TestTaskCFT
//
//  Created by Антон Денисюк on 26.12.2022.
//

import Foundation

protocol BlankNoteViewPresenterProtocol: AnyObject {
    init(view: BlankNoteViewProtocol, router: RouterProtocol, note: Note?)
    func tapComplete(title: String, subtitle: String, existingNote: Note?)
    func viewDidLoad()
}

class BlankNotePresenter: BlankNoteViewPresenterProtocol {
    
    // MARK: - Public Properties

    weak var view: BlankNoteViewProtocol?
    var router: RouterProtocol?

    // MARK: - Private Properties

    private var note: Note?

    // MARK: - Protocol Methods

    required init(view: BlankNoteViewProtocol, router: RouterProtocol, note: Note?) {
        self.view = view
        self.router = router
        self.note = note
    }

    func viewDidLoad() {
        getNote()
    }

    func tapComplete(title: String, subtitle: String, existingNote: Note?) {
        if existingNote != nil
            && existingNote!.title == title
            && existingNote!.subtitle == subtitle {
            router?.initialViewController(note: nil)
        } else if existingNote != nil
                    && title != ""
                    && subtitle != ""
                    && (existingNote!.title != title
                        || existingNote!.subtitle != subtitle) {
            let modifiedNote = Note(
                title: title,
                subtitle: subtitle,
                date: existingNote!.date
            )
            let notes = StorageManager.shared.fetchFromFile()
            if let index = notes.firstIndex(where: { $0 == existingNote }) {
                StorageManager.shared.deleteFromFile(at: index)
                StorageManager.shared.saveToFileByIndex(with: modifiedNote, at: index)
            }
            router?.initialViewController(note: nil)
        } else {
            if title != "" && subtitle != "" {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
                let currentDate = dateFormatter.string(from: Date())
                let newNote = Note(
                    title: title,
                    subtitle: subtitle,
                    date: currentDate
                )
                router?.initialViewController(note: newNote)
            }
        }
    }

    // MARK: - Private Methods

    private func getNote() {
        view?.loadNote(note: note)
    }
}
