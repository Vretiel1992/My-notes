//
//  BlankNoteViewController.swift
//  TestTaskCFT
//
//  Created by Антон Денисюк on 26.12.2022.
//

import UIKit

protocol BlankNoteViewProtocol: AnyObject {
    func loadNote(note: Note?)
    func showAlert()
    func hideReadyButton()
}

final class BlankNoteViewController: UIViewController {

    // MARK: - Public Properties

    var presenter: BlankNoteViewPresenterProtocol?

    // MARK: - Private Properties

    private var note: Note?

    private lazy var addNewNoteBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem( 
            title: Constants.Text.readyNewNoteBarButtonItem,
            style: .plain,
            target: self,
            action: #selector(addNewNoteTapped)
        )
        return item
    }()

    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.text = Constants.Text.titleLabelBlankNoteVC
        label.textAlignment = .center
        return label
    }()

    lazy var titleTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        textView.backgroundColor = Constants.Colors.backgroundSecondary
        textView.layer.cornerRadius = 8
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.isSelectable = true
        textView.delegate = self
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.showsHorizontalScrollIndicator = false
        textView.showsVerticalScrollIndicator = true
        textView.font = Constants.Fonts.systemFont16Regular
        return textView
    }()

    private lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.text = Constants.Text.descriptionLabelBlankNoteVC
        label.textAlignment = .center
        return label
    }()

    lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        textView.backgroundColor = Constants.Colors.backgroundSecondary
        textView.layer.cornerRadius = 8
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.isSelectable = true
        textView.delegate = self
        textView.dataDetectorTypes = .link
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.showsHorizontalScrollIndicator = false
        textView.showsVerticalScrollIndicator = true
        textView.font = Constants.Fonts.systemFont16Regular
        return textView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        subscribeToKeyboardNotification()
        setupConstraints()
        presenter?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    // MARK: - Private Methods

    private func setupViews() {
        view.backgroundColor = Constants.Colors.backgroundPrimary
        view.addSubview(titleStackView)
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(titleTextView)
        view.addSubview(descriptionStackView)
        descriptionStackView.addArrangedSubview(descriptionLabel)
        descriptionStackView.addArrangedSubview(descriptionTextView)
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    private func subscribeToKeyboardNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(adjustForKeyboard),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(adjustForKeyboard),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Constants.Constraint.indent5
            ),
            titleStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.Constraint.indent16
            ),
            titleStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Constants.Constraint.indent16
            ),
            titleStackView.heightAnchor.constraint(
                equalToConstant: 80
            ),

            descriptionStackView.topAnchor.constraint(
                equalTo: titleStackView.bottomAnchor,
                constant: Constants.Constraint.indent16
            ),
            descriptionStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.Constraint.indent16
            ),
            descriptionStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Constants.Constraint.indent16
            ),
            descriptionStackView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            )
        ])
    }

    // MARK: - Object Methods

    @objc func addNewNoteTapped() {
        titleTextView.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
        if note == nil {
            presenter?.didTapCompleteButton(
                title: titleTextView.text,
                subtitle: descriptionTextView.text,
                existingNote: nil
            )
        } else {
            presenter?.didTapCompleteButton(
                title: titleTextView.text,
                subtitle: descriptionTextView.text,
                existingNote: note
            )
        }
    }

    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[
            UIResponder.keyboardFrameEndUserInfoKey
        ] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            descriptionTextView.contentInset = .zero
        } else {
            descriptionTextView.contentInset = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: keyboardViewEndFrame.height - 30,
                right: 0
            )
        }
        descriptionTextView.scrollIndicatorInsets = descriptionTextView.contentInset
        descriptionTextView.scrollRangeToVisible(descriptionTextView.selectedRange)
    }
}

// MARK: - CreateViewProtocol

extension BlankNoteViewController: BlankNoteViewProtocol {
    func loadNote(note: Note?) {
        if let receivedNote = note {
            self.note = receivedNote
            titleTextView.text = receivedNote.title
            descriptionTextView.text = receivedNote.subtitle
        }
    }

    func showAlert() {
        let alert = UIAlertController(title: Constants.Text.alertTitleEmptyFields,
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.Text.alertOK, style: .cancel))
        present(alert, animated: true, completion: nil)
    }

    func hideReadyButton() {
        navigationItem.setRightBarButton(nil, animated: true)
    }
}

extension BlankNoteViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        navigationItem.setRightBarButton(addNewNoteBarButtonItem, animated: true)
        return true
    }
}
