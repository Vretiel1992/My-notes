//
//  MainPresenter.swift
//  TestTaskCFT
//
//  Created by Антон Денисюк on 24.12.2022.
//
import Foundation

protocol MainViewPresenterProtocol: AnyObject {
    init(view: MainViewProtocol, router: RouterProtocol)
    func viewWillAppear()
    func addTapped(at index: Int?)
    func deleteSelected(for indexPath: IndexPath)
}

final class MainPresenter: MainViewPresenterProtocol {

    // MARK: - Public Properties

    weak var view: MainViewProtocol?
    var router: RouterProtocol?

    // MARK: - Private Properties

    private var notes: [Note] = []

    // MARK: - Protocol Methods

    required init(view: MainViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router 
    }
    
    func viewWillAppear() {
        notes = StorageManager.shared.fetchFromFile()
        getNotes()
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
