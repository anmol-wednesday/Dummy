//
//  Networking.swift
//  Dummy
//
//  Created by Anmol Kalra on 13/07/21.
//

import Foundation

class Networking {
	let baseURL = "https://api.thecatapi.com/v1/images/search?limit=20&page=1&mime_types=png"
	
	var imageCacher = [String: Data]()
	
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
	
	func getCatImageData(using url: URL, completion: @escaping (Data?) -> Void) {
		if let imageData = imageCacher[url.absoluteString] {
			print("used cached image")
			completion(imageData)
		} else {
			let task = URLSession.shared.downloadTask(with: url) { localURL , _, error in
				guard let localURL = localURL else { return }
				do {
					let data = try Data(contentsOf: localURL)
					self.imageCacher[url.absoluteString] = data
					completion(data)
				} catch {
					print(error)
				}
			}
			task.resume()
		}
	}
}
