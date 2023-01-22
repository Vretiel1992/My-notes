//
//  BlankNotePresenter.swift
//  TestTaskCFT
//
//  Created by Антон Денисюк on 26.12.2022.
//

import Foundation

protocol BlankNoteViewPresenterProtocol: AnyObject {
    init(view: BlankNoteViewProtocol, router: RouterProtocol, note: Note?)
    func viewDidLoad()
    func didTapCompleteButton(title: String, subtitle: String, existingNote: Note?)
}

final class BlankNotePresenter: BlankNoteViewPresenterProtocol {
    
    // MARK: - Public Properties

    weak var view: BlankNoteViewProtocol?
    var router: RouterProtocol?

    // MARK: - Private Properties

    private var receivedNote: Note?
    private var createdNote: Note?

    // MARK: - Protocol Methods

    required init(view: BlankNoteViewProtocol, router: RouterProtocol, note: Note?) {
        self.view = view
        self.router = router
        self.receivedNote = note
    }

    func viewDidLoad() {
        getNote()
    }

    func didTapCompleteButton(title: String, subtitle: String, existingNote: Note?) {
        tappedCompleteButton(title: title, subtitle: subtitle, existingNote: existingNote)
    }

    // MARK: - Private Methods

    private func getNote() {
        view?.loadNote(note: receivedNote)
    }

    private func tappedCompleteButton(title: String, subtitle: String, existingNote: Note?) {
        if existingNote != nil
            && existingNote!.title == title
            && existingNote!.subtitle == subtitle {
            view?.hideReadyButton()
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
            view?.hideReadyButton()
        } else if title != "" && subtitle != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constants.Text.dateFormat
            let currentDate = dateFormatter.string(from: Date())
            let newNote = Note(
                title: title,
                subtitle: subtitle,
                date: currentDate
            )
            createdNote = newNote
            view?.hideReadyButton()
            StorageManager.shared.saveToFile(with: newNote)
        } else {
            view?.showAlert()
            view?.hideReadyButton()
        }
    }
}
