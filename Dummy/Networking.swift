//
//  Networking.swift
//  Dummy
//
//  Created by Anmol Kalra on 13/07/21.
//

import Foundation

struct Networking {
	let baseURL = "https://api.thecatapi.com/v1/images/search?limit=20&page=1&mime_types=png"
	func getCatData(completion: @escaping ([Cat]) -> Void) {
		var catImageData = [Cat]()
		guard let safeURL = URL(string: baseURL) else { return }
		URLSession.shared.dataTask(with: safeURL) { data, _, error in
			if let e = error {
				print(e)
			}
			
			if let safeData = data {
				do {
					catImageData = try JSONDecoder().decode([Cat].self, from: safeData)
					completion(catImageData)
					
				} catch {
					print(error)
				}
			}
		}.resume()
	}
	func getCatImageData(using url: URL, completion: @escaping (Data) -> Void) {
		URLSession.shared.dataTask(with: url) { data, _, _ in
			guard let safeData = data else { return }
			completion(safeData)
		}.resume()
	}
}
