//
//  LocalFileManager.swift
//  CrytpoSwift
//
//  Created by Linval Muchapirei on 11/1/2025.
//

import Foundation
import SwiftUI

class LocalFileManager {
    static let instance = LocalFileManager()
    private init() {
        
    }
    
    func saveImage(image: UIImage,imageName: String,folderName: String){
        // create folder {doesnt do anything if folder exists}
        createFolderIfNeeded(folderName: folderName)
        // get path for image
        guard let data = image.pngData(),
        let url = getURLForImage(imageName: imageName, folderName: folderName) else { return }
        do {
        // save image to path
            try data.write(to: url)
        } catch let error {
            print("Error saving image. ImageName: \(imageName) \(error.localizedDescription)")
        }
    }
    func  getImage(imageName: String,folderName: String) -> UIImage?{
        guard let url = getURLForImage(imageName: imageName, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path)
        else { return nil}
        return UIImage(contentsOfFile: url.path)
        
    }
    private func createFolderIfNeeded(folderName: String){
        guard let url = getUrlForFolder(folderName: folderName) else { return }
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            } catch let error {
                print("Error creating directory. FolderName: \(folderName). \(error)")
            }
        }
    }
    
    private func getUrlForFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        
        return url.appendingPathComponent(folderName)
    }
    
    private func getURLForImage(imageName: String,folderName: String)-> URL? {
        guard let folderURL = getUrlForFolder(folderName: folderName) else { return nil }
        return folderURL.appendingPathComponent(imageName + ".png")
    }
}
