//
//  MainCustomTableViewCell.swift
//  TestTaskCFT
//
//  Created by Антон Денисюк on 24.12.2022.
//

import UIKit

class MainCustomTableViewCell: UITableViewCell {

    // MARK: - Private Properties

    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.backgroundSecondary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.systemFont18Bold
        label.textAlignment = .left
        label.textColor = .label
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.systemFont16Regular
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.systemFont16Regular
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        return label
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override Methods

    override func prepareForReuse() {
        titleLabel.text = nil
        subtitleLabel.text = nil
        dateLabel.text = nil
    }

    // MARK: - Public Methods

    func configure(with note: Note) {
        titleLabel.text = note.title
        subtitleLabel.text = note.subtitle
        dateLabel.text = note.date
    }

    // MARK: - Private Methods

    private func setupViews() {
        backgroundColor = Constants.Colors.backgroundPrimary
        contentView.backgroundColor = Constants.Colors.backgroundPrimary
        contentView.addSubview(backView)
        backView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(dateLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            stackView.topAnchor.constraint(
                equalTo: backView.topAnchor,
                constant: Constants.Constraint.indent5
            ),
            stackView.bottomAnchor.constraint(
                equalTo: backView.bottomAnchor,
                constant: -Constants.Constraint.indent5
            ),
            stackView.leadingAnchor.constraint(
                equalTo: backView.leadingAnchor,
                constant: Constants.Constraint.indent16
            ),
            stackView.trailingAnchor.constraint(
                equalTo: backView.trailingAnchor,
                constant: -Constants.Constraint.indent16
            )
        ])
    }
}
