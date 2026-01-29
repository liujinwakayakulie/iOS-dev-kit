import Foundation

@MainActor
final class FEATUREViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published private(set) var state: State = .idle

    // MARK: - Types

    enum State {
        case idle
        case loading
        case loaded(data: DataType)
        case error(Error)
    }

    // MARK: - Dependencies

    private let service: FEATUREService

    // MARK: - Initialization

    init(service: FEATUREService) {
        self.service = service
    }

    // MARK: - Public Methods

    func performAction() async {
        state = .loading

        do {
            let result = try await service.fetchData()
            state = .loaded(data: result)
        } catch {
            state = .error(error)
        }
    }
}
