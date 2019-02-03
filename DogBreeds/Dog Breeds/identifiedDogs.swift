//
//  identifiedDogs.swift
//  Dog Breeds
//
//  Created by Jaden Banson on 2019-02-02.
//  Copyright © 2019 Jaden Banson. All rights reserved.
//

import UIKit
import RLBAlertsPickers
import Fusuma
import SwiftSH
import Foundation
class identifiedDogs: UIViewController, FusumaDelegate, SSHViewController {

    public var pubDogImage: UIImage?
    var imageView: UIImageView?
    var imageUrl: UILabel?
    
    var shell: Shell!
    var authenticationChallenge: AuthenticationChallenge?
    var semaphore: DispatchSemaphore!
    var lastCommand = ""
    var textBuff: [String] = []
    
    var requiresAuthentication = true
    var hostname: String! = "130.15.224.114"
    var port: UInt16? = 22
    var username: String! = "pi"
    var password: String? = "room355"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView  = UIImageView(frame: CGRect(x:0, y:0, width: view.bounds.width*0.85, height: view.bounds.width*0.94))
        imageView!.center = CGPoint(x:view.bounds.width/2, y: view.bounds.height*0.33)
        imageView!.backgroundColor = UIColor.gray
        imageView!.layer.cornerRadius = 15
        self.view.addSubview(imageView!)
        
        imageUrl = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        imageUrl!.center = CGPoint(x: view.bounds.width/2, y: view.bounds.height*0.48)
        imageUrl!.textAlignment = .center
        imageUrl!.text = ""
        self.view.addSubview(imageUrl!)
        
        view.backgroundColor = UIColor.white
        
        let takeFromLib = UIButton(frame: CGRect(x: (self.view.bounds.midX)-((UIScreen.main.bounds.width)*0.8)/2, y: UIScreen.main.bounds.height-(UIScreen.main.bounds.height)*0.30, width: ((UIScreen.main.bounds.width)*0.8), height: UIScreen.main.bounds.height-(UIScreen.main.bounds.height)*0.92))
        takeFromLib.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.92)
        takeFromLib.layer.cornerRadius = 15
        takeFromLib.setTitle("Select a Photo 🐶", for: .normal)
        takeFromLib.titleLabel?.textAlignment = NSTextAlignment.center
        takeFromLib.layer.masksToBounds = false
        takeFromLib.setTitleColor( UIColor(red: 25/255, green: 182/255, blue: 255/255, alpha: 1.0), for: .normal)
        takeFromLib.addTarget(self, action: #selector(launchPhotoSys), for: .touchUpInside)
        takeFromLib.titleLabel?.font =  UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy)
        takeFromLib.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        takeFromLib.layer.shadowOffset = CGSize(width:2.0, height:4.0)
        takeFromLib.layer.shadowOpacity = 0.6
        takeFromLib.layer.shadowRadius = 2.0
        takeFromLib.layer.masksToBounds = false
        takeFromLib.layer.cornerRadius = 15
        self.view.addSubview(takeFromLib)
        
        if self.requiresAuthentication {
            if let password = self.password {
                self.authenticationChallenge = .byPassword(username: self.username, password: password)
            } else {
                self.authenticationChallenge = .byKeyboardInteractive(username: self.username) { [unowned self] challenge in
                    DispatchQueue.main.async {
                        self.appendToTextView(challenge)
                    }
                    
                    self.semaphore = DispatchSemaphore(value: 0)
                    _ = self.semaphore.wait(timeout: DispatchTime.distantFuture)
                    self.semaphore = nil
                    
                    return self.password ?? ""
                }
            }
        }
        
        self.shell = Shell(host: self.hostname!, port: self.port!, terminal: "vanilla")

    /*
    // MARK: - Navigationa

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
    /*func sshToServer() {
        let shell = Shell(host: hostname!, port: port!, terminal: "vanilla")
        shell!.withCallback { (string: String?, error: String?) in
            print("\(string ?? error!)")
            }
            .connect()
            .authenticate(.byPassword(username: username!, password: password!))
            .open { (error) in
                if let error = error {
                    print("\(error)")
                }
            }
        shell!.write("sudo touch /home/pi/html/newtesting.txt") { (error) in
            if let error = error {
                print("error")
            }
        }
        
    }*/
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        switch source {
        case .camera:
            print("Image captured from Camera")
        case .library:
            print("Image selected from Camera Roll")
        default:
            print("Image selected")
        }
        
        self.imageView!.image = image
    }
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        print("Number of selection images: \(images.count)")
        
        var count: Double = 0
        
        for image in images {
            DispatchQueue.main.asyncAfter(deadline: .now() + (3.0 * count)) {
                self.imageView!.image = image
                print("w: \(image.size.width) - h: \(image.size.height)")
            }
            
            count += 1
        }
    }
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode, metaData: ImageMetadata) {
        print("Image mediatype: \(metaData.mediaType)")
        print("Source image size: \(metaData.pixelWidth)x\(metaData.pixelHeight)")
        print("Creation date: \(String(describing: metaData.creationDate))")
        print("Modification date: \(String(describing: metaData.modificationDate))")
        print("Video duration: \(metaData.duration)")
        print("Is favourite: \(metaData.isFavourite)")
        print("Is hidden: \(metaData.isHidden)")
        print("Location: \(String(describing: metaData.location))")
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        print("video completed and output to file: \(fileURL)")
        self.imageUrl!.text = "file output to: \(fileURL.absoluteString)"
    }
    
    func fusumaDismissedWithImage(_ image: UIImage, source: FusumaMode) {
        switch source {
        case .camera:
            performCommand(cv: "sudo touch /home/pi/html/newtestingData.txt")
        case .library:
            performCommand(cv: "sudo touch /home/pi/html/newtestingData.txt")
        default:
            print("Called just after dismissed FusumaViewController")
        }
    }
    
    func fusumaCameraRollUnauthorized() {
        print("Camera roll unauthorized")
        
        let alert = UIAlertController(title: "Access Requested",
                                      message: "Saving image needs to access your photo album",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { (action) -> Void in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.openURL(url)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        })
        
        guard let vc = UIApplication.shared.delegate?.window??.rootViewController, let presented = vc.presentedViewController else {
            return
        }
        
        presented.present(alert, animated: true, completion: nil)
    }
    
    func fusumaClosed() {
        print("FUSUMMMMMAA CLOSSSED")
    }
    
    func fusumaWillClosed() {
        print("Called when the close button is pressed")
    }
    @objc func launchPhotoSys(_ sender: AnyObject) {

        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.cropHeightRatio = 1.0
        fusuma.allowMultipleSelection = false
        fusuma.availableModes = [.library, .camera]
        fusuma.photoSelectionLimit = 4
        fusumaSavesImage = true
        
        self.imageView?.layer.cornerRadius = 15
        present(fusuma, animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.connect()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.disconnect()
    }
    
    func connect() {
        self.shell!
            .withCallback { [unowned self] (string: String?, error: String?) in
                DispatchQueue.main.async {
                    if let string = string {
                        self.appendToTextView(string)
                    }
                    if let error = error {
                        self.appendToTextView("[ERROR] \(error)")
                    }
                }
            }
            .connect()
            .authenticate(self.authenticationChallenge)
            .open { (error) in
                if let error = error {
                    print("[ERROR] \(error)")
                    
                } else {
                    print("No connection error.")
                }
        }
    }
    
    func disconnect() {
        self.shell?.disconnect { [unowned self] in
            print("Disconnected!")
        }
    }
    
    func appendToTextView(_ text: String) {
        textBuff.append(text)
    }
    
    func performCommand(cv: String) {
        print("yolo1")
        if let semaphore = self.semaphore {
            semaphore.signal()
        } else {
            print("Last command is '\(cv)'")
            self.shell.write(cv) { [unowned self] (error) in
                if let error = error {
                    print("[ERROR] \(error)")
                }
            }
        }
        
        self.lastCommand = ""
    }
    
}


extension identifiedDogs: UITextViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard !text.isEmpty else {
            guard !self.lastCommand.isEmpty else {
                return false
            }
            
            let endIndex = self.lastCommand.endIndex
            self.lastCommand.removeSubrange(self.lastCommand.index(before: endIndex)..<endIndex)
            
            return true
        }
        
        self.lastCommand.append(text)
        
        if text == "\n" {
            self.performCommand(cv: "sudo touch /home/pi/html/newstestingData.txt")
        }
        
        return true
    }
    
}

protocol SSHViewController: class {
    
    var requiresAuthentication: Bool { get set }
    var hostname: String! { get set }
    var port: UInt16? { get set }
    var username: String! { get set }
    var password: String? { get set }
    
}
