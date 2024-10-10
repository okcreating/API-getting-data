import Foundation

// MARK: URL Creation

enum Paths: String {
    case dataForToday = "/intensity/date"
    case dataForSpecificDate = "/intensity/date/2023-08-12"
    case wrongURL = "/intensity/date/0000-08-12"
}

func createURL(path: Paths) -> URL? {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "api.carbonintensity.org.uk"
    components.path = path.rawValue
    return components.url
}

// MARK: URL Request

func createRequest(url: URL?) -> URLRequest? {
    guard let url else { return nil }
    var request = URLRequest(url: url)
    return request
}

// MARK: Session Configuration

func sessionConfiguration() -> URLSession {
    let configuration = URLSessionConfiguration.default
    configuration.allowsCellularAccess = false
    configuration.waitsForConnectivity = true
    return URLSession(configuration: configuration)
}

// MARK: Fetching Data

func getData() {
    guard let url = createURL(path: .dataForSpecificDate),
    //guard let url = createURL(path: .dataForToday),
   // guard let url = createURL(path: .wrongURL),
    let urlRequest = createRequest(url: url) else { return }
    let session = sessionConfiguration()
    session.dataTask(with: urlRequest) { data, response, error in
        if error != nil {
            print("Error is not nil")
        } else {
        let response = response as? HTTPURLResponse
            switch response?.statusCode {
            case 200:
                print("Response status code is 200. You've got the data.")
            case 400:
                print("Response status code is 400. This indicates that the server cannot or will not process the request due to something that is perceived to be a client error.")
            case 500:
                print("Response status code is 500. This indicates that the server encountered an unexpected condition that prevented it from fulfilling the request.")
            default:
                print("Sorry, you faced with unknown error.")
            }
        guard let data = data else { return }
        let dataAsString = String(data: data, encoding: .utf8)
        print("\(String(describing: dataAsString))")
        }
    }.resume()
}

getData()
