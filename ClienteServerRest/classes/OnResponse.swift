import Foundation

protocol OnResponse {
    func onData(data: Data)
    func onDataError(message: String)
}
