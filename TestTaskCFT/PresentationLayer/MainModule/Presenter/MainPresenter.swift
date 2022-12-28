//
//  MainPresenter.swift
//  TestTaskCFT
//
//  Created by Антон Денисюк on 24.12.2022.
//
import Foundation

protocol MainViewPresenterProtocol: AnyObject {
    init(view: MainViewProtocol, router: RouterProtocol, note: Note?)
    func viewDidLoad()
    func addTapped(at index: Int?)
    func deleteSelected(for indexPath: IndexPath)
}

class MainPresenter: MainViewPresenterProtocol {

    // MARK: - Public Properties

    weak var view: MainViewProtocol?
    var router: RouterProtocol?

    // MARK: - Private Properties

    private var notes: [Note] = []
    private var note: Note?

    // MARK: - Protocol Methods

    required init(view: MainViewProtocol, router: RouterProtocol, note: Note?) {
        self.view = view
        self.router = router
        self.note = note
    }
    
    func viewDidLoad() {
        notes = StorageManager.shared.fetchFromFile()
        getNotes()
        if let newNote = note {
            addNote(note: newNote)
        }
    }
    
    func addTapped(at index: Int?) {
        if let currentIndex = index {
            notes = StorageManager.shared.fetchFromFile()
            let currentNote = notes[currentIndex]
            router?.showBlankNewNote(note: currentNote)
        } else {
            router?.showBlankNewNote(note: nil)
        }
    }
    
    func deleteSelected(for indexPath: IndexPath) {
        deleteNote(at: indexPath)
    }

    // MARK: - Private Methods

    private func getNotes() {
        view?.notesLoad(notes: notes)
    }

    private func addNote(note: Note) {
        StorageManager.shared.saveToFile(with: note)
        view?.noteAddSuccess(note: note)
    }

    private func deleteNote(at indexPath: IndexPath) {
        let index = indexPath.row
        StorageManager.shared.deleteFromFile(at: index)
        view?.noteDeletion(indexPath: indexPath)
    }
}
