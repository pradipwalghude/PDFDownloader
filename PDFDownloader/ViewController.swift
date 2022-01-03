
import UIKit

class ViewController: UIViewController {
    var pdfUrl:URL?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tappedOnDownloadBtn(_ sender: Any) {
        testDownload()
    }
  
    func testDownload() {
        let urlString = "https://www.tutorialspoint.com/swift/swift_tutorial.pdf"
        let url = URL(string: urlString)
        // Create destination URL
        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as URL

        let destinationFileUrl = documentsUrl.appendingPathComponent(url!.lastPathComponent)
        //Create URL to the source file you want to download
        let fileURL = URL(string: urlString)
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest(url:fileURL!)
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded. Status code: \(statusCode)")
                }
                do {
                    if FileManager.default.fileExists(atPath: destinationFileUrl.path) {
                        try FileManager.default.removeItem(at: destinationFileUrl)
                    }
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                    print("copy sucessfully")
                    
                    do {
                        //Show UIActivityViewController to save the downloaded file
                        let contents  = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                        for indexx in 0..<contents.count {
                            if contents[indexx].lastPathComponent == destinationFileUrl.lastPathComponent {
                                let activityViewController = UIActivityViewController(activityItems: [contents[indexx]], applicationActivities: nil)
                                DispatchQueue.main.async {
                                    self.present(activityViewController, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                    catch (let err) {
                        print("error: \(err)")
                    }
                } catch (let writeError) {
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
                }
            } else {
                print("Error took place while downloading a file. Error description: \(error?.localizedDescription ?? "")")
            }
        }
        task.resume()
    }
}


// 2nd apporach
//extension ViewController: URLSessionDownloadDelegate {
//
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//        print("download location \(location)")
//
//        guard let url = downloadTask.originalRequest?.url else { return }
//        let docPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
//        let destinationPath = docPath.appendingPathComponent(url.lastPathComponent)
//
//        try? FileManager.default.removeItem(at: destinationPath)
//        do {
//            try? FileManager.default.copyItem(at: location, to: destinationPath)
//            self.pdfUrl = destinationPath
//        } catch let error {
//            print("error\(error.localizedDescription)")
//        }
//    }
//}




//        guard let url = URL(string: "https://www.tutorialspoint.com/swift/swift_tutorial.pdf") else { return }
//        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue:  OperationQueue())
//        let downloadtask = urlSession.downloadTask(with: url)
//        downloadtask.resume()
        
        
//        DispatchQueue.main.async {
//                   let pdfData = try? Data.init(contentsOf: url)
//                   let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
//                   let pdfNameFromUrl = "pradipmedoc.pdf"
//                   let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
//                   do {
//                       try pdfData?.write(to: actualPath, options: .atomic)
//                       print("pdf successfully saved!")
//                   } catch {
//                       print("Pdf could not be saved")
//                   }
//               }
