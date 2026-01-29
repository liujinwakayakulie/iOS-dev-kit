import UIKit

@MainActor
final class FEATUREViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: FEATUREViewModel
    private let contentView: FEATUREView

    // MARK: - Initialization

    init(viewModel: FEATUREViewModel) {
        self.viewModel = viewModel
        self.contentView = FEATUREView()
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        bindViewModel()
    }

    // MARK: - Setup

    private func setupView() {
        title = "TITLE"
        view.addSubview(contentView)
        view.backgroundColor = .systemBackground
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func bindViewModel() {
        // Bind to viewModel updates
    }

    // MARK: - Actions

    @objc private func actionButtonTapped() {
        Task {
            await viewModel.performAction()
        }
    }
}
