//
//  OnTheMap.swift
//  ios-nanodegree-onthemap
//
//  Created by Andrew Despres on 12/24/18.
//  Copyright © 2018 Andrew Despres. All rights reserved.
//

import Foundation

class OnTheMap {
    private static let applicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    private static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    private static let decoder = JSONDecoder()
    private static let encoder = JSONEncoder()
    
    class func getStudentLocation(for uniqueKey: String, completion: @escaping (StudentLocations?, Error?) -> Void) {
        let parameters = "{\"uniqueKey\":\"\(uniqueKey)\"}".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?where=\(parameters)")
        taskForGETRequest(url: url!, response: StudentLocations.self) { (response, error) in
            if let response = response {
                DispatchQueue.main.async { completion(response, nil) }
            } else {
                DispatchQueue.main.async { completion(nil, error) }
            }
        }
    }
    
    class func getStudentLocations(completion: @escaping (StudentLocations?, Error?) -> Void) {
        let url = URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=updatedAt")
        taskForGETRequest(url: url!, response: StudentLocations.self) { (response, error) in
            if let response = response {
                DispatchQueue.main.async { completion(response, nil) }
            } else {
                DispatchQueue.main.async { completion(nil, error) }
            }
        }
    }
    
    class func getUserData(for userId: String, completion: @escaping (UserData?, Error?) -> Void) {
        let url = URL(string: "https://onthemap-api.udacity.com/v1/users/\(userId)")
        taskForGETRequest(url: url!, response: UserData.self, securedResponse: true) { (response, error) in
            if let response = response {
                DispatchQueue.main.async { completion(response, nil) }
            } else {
                DispatchQueue.main.async { completion(nil, error) }
            }
        }
    }
    
    class func postStudentLocation(_ studentLocation: StudentLocation, completion: @escaping (PostStudentLocation?, Error?) -> Void) {
        let url = URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")
        let body = studentLocation
        taskForPOSTRequest(url: url!, body: body, response: PostStudentLocation.self, completion: { (response, error) in
            if let response = response {
                DispatchQueue.main.async { completion(response, nil) }
            } else {
                DispatchQueue.main.async { completion(nil, error) }
            }
        })
    }
    
    class func putStudentLocation(_ studentLocation: StudentLocation, completion: @escaping (PutStudentLocation?, Error?) -> Void) {
        let url = URL(string: "https://parse.udacity.com/parse/classes/StudentLocation/\(studentLocation.objectId)")
        let body = studentLocation
        taskForPUTRequest(url: url!, body: body, response: PutStudentLocation.self, completion: { (response, error) in
            if let response = response {
                DispatchQueue.main.async { completion(response, nil) }
            } else {
                DispatchQueue.main.async { completion(nil, error) }
            }
        })
    }
    
    class func postSession(username: String, password: String, completion: @escaping (PostSession?, Error?) -> Void) {
        let url = URL(string: "https://onthemap-api.udacity.com/v1/session")
        
        let login = Login(username: username, password: password)
        let udacityLogin = UdacityLogin(login: login)
        
        taskForPOSTRequest(url: url!, body: udacityLogin, response: PostSession.self, securedResponse: true) { (response, error) in
            if let response = response {
                DispatchQueue.main.async { completion(response, nil) }
            } else {
                DispatchQueue.main.async { completion(nil, error) }
            }
        }
    }
    
    class func deleteSession(completion: @escaping (DeleteSession?, Error?) -> Void) {
        let url = URL(string: "https://onthemap-api.udacity.com/v1/session")
        
        taskForDELETERequest(url: url!, response: DeleteSession.self, securedResponse: true) { (response, error) in
            if let response = response {
                DispatchQueue.main.async { completion(response, nil) }
            } else {
                DispatchQueue.main.async { completion(nil, error) }
            }
        }
    }
}

// MARK: - HTTP Requests
extension OnTheMap {
    private class func taskForGETRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, securedResponse: Bool = false, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.addValue(applicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard var data = data else {
                completion(nil, error)
                return
            }
            
            if securedResponse {
                let range = 5 ..< data.count
                data = data.subdata(in: range)
            }
            
            // Decode JSON to ResponseType
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                completion(responseObject, nil)
                return
            } catch {
                completion(nil, error)
                return
            }
        }
        
        task.resume()
    }
    
    private class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, body: RequestType, response: ResponseType.Type, securedResponse: Bool = false, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(applicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // add http request body
        do {
            request.httpBody = try encoder.encode(body)
        } catch {
            completion(nil, error)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard var data = data else {
                completion(nil, error)
                return
            }
            
            if securedResponse {
                let range = 5 ..< data.count
                data = data.subdata(in: range)
            }
            
            // For Debug Purposes Only
            print(String(data: data, encoding: .utf8))
            
            // Decode JSON to ResponseType
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                completion(responseObject, nil)
                return
            } catch {
                do {
                    let errorObject = try decoder.decode(OnTheMapError.self, from: data)
                    completion(nil, errorObject)
                    return
                } catch {
                    completion(nil, error)
                    return
                }
            }
        }
        
        task.resume()
    }
    
    private class func taskForDELETERequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, securedResponse: Bool = false, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard var data = data else {
                completion(nil, error)
                return
            }
            
            if securedResponse {
                let range = 5 ..< data.count
                data = data.subdata(in: range)
            }
            
            // Decode JSON to ResponseType
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                completion(responseObject, nil)
                return
            } catch {
                completion(nil, error)
                return
            }
        }
        
        task.resume()
    }
    
    private class func taskForPUTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, body: RequestType, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue(applicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // add http request body
        do {
            request.httpBody = try encoder.encode(body)
        } catch {
            completion(nil, error)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            // Decode JSON to ResponseType
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                completion(responseObject, nil)
                return
            } catch {
                completion(nil, error)
                return
            }
        }
        
        task.resume()
    }
}
