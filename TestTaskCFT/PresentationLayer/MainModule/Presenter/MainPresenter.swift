//
//  MainPresenter.swift
//  TestTaskCFT
//
//  Created by Антон Денисюк on 24.12.2022.
//
import Foundation

protocol MainViewPresenterProtocol: AnyObject {
    init(view: MainViewProtocol)
    func viewDidLoad()
    func addTapped(with note: Note)
    func deleteSelected(for indexPath: IndexPath)
}

class MainPresenter: MainViewPresenterProtocol {

    // MARK: - Public Properties

    weak var view: MainViewProtocol?

    // MARK: - Private Properties

    private var notes: [Note] = []
//    private var notes: Result<[Note], Error>?

    // MARK: - Protocol Methods

    required init(view: MainViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        getNotes()
    }
    
    func addTapped(with note: Note) {
        addNote(note: note)
    }
    
    func deleteSelected(for indexPath: IndexPath) {
        deleteNote(at: indexPath)
    }

    // MARK: - Private Methods

    private func getNotes() {
        notes = Note.getFirstNote()
        // когда будет БД, если будет возникать ошибка добавления объекта
//        view?.noteAddFailure(message: error?.localizedDescription)
        view?.notesLoad(notes: notes)
    }

    private func addNote(note: Note) {
        let newNote = note
        notes.append(newNote)
        view?.noteAddSuccess(note: newNote)
    }

    private func deleteNote(at indexPath: IndexPath) {
        let index = indexPath.row
        notes.remove(at: index)
        view?.noteDeletion(indexPath: indexPath)
    }
}
