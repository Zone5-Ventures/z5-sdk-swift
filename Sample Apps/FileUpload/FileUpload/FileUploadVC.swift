//
//  ViewController.swift
//  FileUpload
//
//  Created by John Covele on 2/27/20.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//
// This sample is app is free to use for any of our licensees.

import UIKit
import Zone5

class FileUploadVC: UIViewController {
    
    //TODO: Set these to proper values:
    let stagingURL = URL(string: "https://whats.todaysplan.com.au")!
    let clientID = "xx-xxxxx"
    let stagingSecret = "sss-sss-sssssss"
    let username = "john.covele@zone5cloud.com"
    let password = "your-password"
    
    @IBOutlet weak var statusLabel: UILabel!
    
    let didAuthenticateNotice = Notification.Name("didAuthenticateNotice")
    let didFinishUploadNotice = Notification.Name("didFinishUploadNotice")

    var uploadedFileID: Int? = nil
    var originalFileSize : UInt64? = nil
    var downloadedFileSize : UInt64? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(didAuthenticate), name: didAuthenticateNotice, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishUpload), name: didFinishUploadNotice, object: nil)

        statusLabel.text = "Logging in..."
        // login using hardcoded credentials at top of this file:
        authenticate()
    }
    
    // this will get called after successful login:
    @objc func didAuthenticate() {
        // get a sample fit file:
         guard let fileURL = Bundle.main.url(forResource: "walk", withExtension: "fit") else {
             return
         }

        // get file size just for informational / debugging purposes:
        do {
             let attr = try FileManager.default.attributesOfItem(atPath: fileURL.path)
             originalFileSize = attr[FileAttributeKey.size] as? UInt64
         } catch {
             print("File size error: \(error)")
         }

        // start the asynchronous file upload:
        uploadToZone5(fileURL: fileURL, statusHandler: statusHandler)
    }

    @objc func didFinishUpload() {
        
    }

    // basic username/password login:
    func authenticate() {
        Zone5.shared.configure(for: stagingURL, clientID: clientID, clientSecret: stagingSecret)
        
        Zone5.shared.oAuth.accessToken(username: self.username, password: self.password) { result in
            switch result {
            case .failure(let error):
                print("\(error)")
                DispatchQueue.main.async {
                    self.statusLabel.text = "Login Failed"
                }
                
            case .success(let accessToken):
                DispatchQueue.main.async {
                    self.statusLabel.text = "Login Successful"  //you could save accessToken for future use to bypass login
                    NotificationCenter.default.post(name: self.didAuthenticateNotice, object: accessToken)
                }
                
            }
        }
        
    }
    
    // Upload the fit file to Today's Plan. The statusHandler callback will be called
    // with status of the upload.
    func uploadToZone5(fileURL: URL, statusHandler: @escaping (_ statusStr: String) -> Void) {
        
        var context = DataFileUploadContext()
        context.startTime = .now
        //TODO: Set other configuation properties here
        
        Zone5.shared.activities.upload(fileURL, context: context) { result in
            switch result {
            case .failure(let error):
                print(error)
                statusHandler("Failed")
                
            case .success(let index):
                self.uploadedFileID = index.id
                
                DispatchQueue.main.async {
                    
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                        switch index.state {
                        case .finished:
                            statusHandler("Finished.")
                            timer.invalidate()
                            self.uploadedFileID = index.resultID

                            
                        case .error:
                            self.statusHandler("Failed")
                            timer.invalidate()
                            
                        default:
                            self.checkUploadStatus(index: index, timer: timer)
                        }
                    }
                }
            }
        }
        
    }
    
    // the only thing our status handler does is update the status label:
    func statusHandler(_ statusStr: String) {
        DispatchQueue.main.async {
            self.statusLabel.text = statusStr
        }
    }
    
    // monitor the status of a file upload:
    func checkUploadStatus(index: DataFileUploadIndex, timer: Timer) {
        
        Zone5.shared.activities.uploadStatus(of: index.id) { result in
            switch result {
            case .failure(let error):
                print(error)
                self.statusHandler("Failed")
                
            case .success(let index):
                switch index.state {
                case .finished:
                    self.statusHandler("Finished")
                    self.uploadedFileID = index.resultID
                    timer.invalidate()
                    
                case .error:
                    self.statusHandler("Failed")
                    timer.invalidate()
                    
                default:
                    self.statusHandler("Uploading...")
                }
            }
        }
    }
    
    
    @IBAction func tappedDownload(_ sender: Any) {
        
        guard let fileID = uploadedFileID else {
            self.statusLabel.text = "Upload a file first"
            return
        }
        
        Zone5.shared.activities.downloadOriginal(fileID) { result in
            
            switch result {
            case .failure(let error):
                print(error)
                self.statusHandler("Failed")
                
            case .success(let fileURL):
                self.downloadedFileSize = nil
                do {
                    let attr = try FileManager.default.attributesOfItem(atPath: fileURL.path)
                    self.downloadedFileSize = attr[FileAttributeKey.size] as? UInt64

                } catch {
                    print("Error: \(error)")
                }
                print("original size: \(self.originalFileSize); downloaded size: \(self.downloadedFileSize)")
                try? FileManager.default.removeItem(at: fileURL)
            }

        }
    }
    
}

