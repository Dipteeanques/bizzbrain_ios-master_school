//
//  VideoplayerViewController.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 14/03/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import AVKit
import Alamofire

class VideoplayerViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var playerset: UIView!
    
    var videoUrl = ""
    var titlevideo = ""
    var descripVideo = ""
    var Subject_id : Int?
    var playerItem:AVPlayerItem?
    var player:AVPlayer?
    var playPauseButton: PlayPauseButton!
    var wc = Webservice.init()
    var arrVideo = [DatumVideo]()
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getVideoSub()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
           self.tabBarController?.tabBar.isHidden = true
       }
       
       override func viewWillDisappear(_ animated: Bool) {
           self.tabBarController?.tabBar.isHidden = false
       }
    
    func getVideoSub() {
                
        if Subject_id != nil {
            let param = ["s_subject_id": Subject_id ?? 0] as [String : Any]
            print(param)
            let token = loggdenUser.value(forKey: TOKEN)as! String
            let headers: HTTPHeaders = ["Xapi": Xapi,
                                    "Authorization":token]
            
            wc.callSimplewebservice(url: exam_videos, parameters: param, headers: headers, fromView: self.view, isLoading: true) { (success, response: VideoResponsModel?) in
                if success {
                    let suc = response?.success
                    if suc == true {
                        let data = response?.data
                        self.arrVideo = data!.data
                        print(self.arrVideo)
                        let strurl = self.arrVideo[0].teacherNoteFiles
                        let urlVideo = strurl[0]
                        let url = URL(string: urlVideo)
                        self.player = AVPlayer(url: url!)
                        let playerLayer = AVPlayerLayer(player: self.player)
                        playerLayer.frame = self.playerset.bounds
                        self.playerset.layer.addSublayer(playerLayer)
                        self.player?.play()
                        self.lblTitle.text = self.arrVideo[0].name
                        self.descripVideo = self.arrVideo[0].datumDescription
                        //self.tblMain.reloadData()
                    }
                    else {
                    }
                }
            }
        }
        else {
            let url : URL = URL(string: videoUrl)!
            player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.playerset.bounds
            self.playerset.layer.addSublayer(playerLayer)
            player?.play()
            lblTitle.text = titlevideo
            playPauseButton = PlayPauseButton()
            playPauseButton.avPlayer = player
            playerset.addSubview(playPauseButton)
            playPauseButton.setup(in: self)
        }
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransition(to: size, with: coordinator)

            playPauseButton.updateUI()
        }
    

    @IBAction func btnbackAction(_ sender: UIButton) {
        player?.pause()
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension VideoplayerViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let lbldesc = cell.viewWithTag(101)as! UILabel
        lbldesc.text = descripVideo
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}



//Create play/pause custome button

class PlayPauseButton: UIView {
    var kvoRateContext = 0
    var avPlayer: AVPlayer?
    var isPlaying: Bool {
        return avPlayer?.rate != 0 && avPlayer?.error == nil
    }

    func addObservers() {
        avPlayer?.addObserver(self, forKeyPath: "rate", options: .new, context: &kvoRateContext)
    }

    func setup(in container: UIViewController) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        addGestureRecognizer(gesture)

        updatePosition()
        updateUI()
        addObservers()
    }

    @objc func tapped(_ sender: UITapGestureRecognizer) {
        updateStatus()
        updateUI()
    }

    private func updateStatus() {
        if isPlaying {
            avPlayer?.pause()
        } else {
            avPlayer?.play()
        }
    }

    func updateUI() {
        if isPlaying {
            setBackgroundImage(name: "pause")
        } else {
            setBackgroundImage(name: "play")
        }
    }
    
    func updatePosition() {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 60),
            heightAnchor.constraint(equalToConstant: 60),
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor)
            ])
    }

    private func setBackgroundImage(name: String) {
        UIGraphicsBeginImageContext(frame.size)
        UIImage(named: name)?.draw(in: bounds)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return }
        UIGraphicsEndImageContext()
        backgroundColor = UIColor(patternImage: image)
    }

    private func handleRateChanged() {
        updateUI()
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let context = context else { return }

        switch context {
        case &kvoRateContext:
            handleRateChanged()
        default:
            break
        }
    }
}
