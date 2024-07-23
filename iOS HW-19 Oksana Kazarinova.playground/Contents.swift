import Foundation

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

createURL(path: .dataForToday)
createURL(path: .dataForSpecificDate)

func createRequest(url: URL?) -> URLRequest? {
    guard let url else { return nil }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    return request
}

func sessionConfiguration() -> URLSession {
    let configuration = URLSessionConfiguration.default
    configuration.allowsCellularAccess = false
    configuration.waitsForConnectivity = true
    return URLSession(configuration: configuration)
}

func getData(urlRequest: String) {
    let urlRequest = createRequest(url: createURL(path: .dataForSpecificDate))
    guard let url = urlRequest else { return }
    sessionConfiguration().dataTask(with: url) { data, response, error in
        if error != nil {

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
// 79eaebd384b9c4dc6d5b8498c70de65f public
// 56d8367e02b0b31038ed8293b79bd42c71cbe0e7 private

