//
//  ChatViewController.swift
//  bizzbrains
//
//  Created by Anques on 31/12/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Photos
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import Firebase
import FirebaseCore

/// A base class for the example controllers
class ChatViewController: MessagesViewController, MessagesDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // MARK: - Public properties

    /// The `BasicAudioController` controll the AVAudioPlayer state (play, pause, stop) and udpate audio cell UI accordingly.
    lazy var audioController = BasicAudioController(messageCollectionView: messagesCollectionView)

    lazy var messageList: [MockMessage] = []
    
    var strChatId = String()
    var userName = String()
    
    var viewGallery = UIView()
    var btnClose = UIButton()
    var imgPreview = UIImageView()
    
    var navigationView = UIView()
    var btnBack = UIButton()
    var lblTitle = UILabel()
    
    private(set) lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(displaymsg), for: .valueChanged)
        return control
    }()

    // MARK: - Private properties

    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
//        let date = dateFormatter.date(from: date)
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        return  dateFormatter.string(from: date!)
        return dateFormatter
    }()

    let ref1 = Constants.refs1.databaseChats.childByAutoId()
    let ref2 = Constants.refs2.databaseChats.childByAutoId()
//    let ref3 = Constants.refs3.databaseChats.childByAutoId()
    
//    let chatdata : chat? = nil
    var imagePicker = UIImagePickerController()
 
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()


        setDefault()
        
//        self.navigationController?.navigationBar.backgroundColor = UIColor.systemRed
//        self.navigationController?.navigationBar.barTintColor = UIColor.systemRed
//        self.navigationController?.isNavigationBarHidden = false
        configureMessageCollectionView()
        configureMessageInputBar()
        configure()
//        loadFirstMessages()
//        title = userName//"MessageKit"
//        displaymsg()
       
        let user = Auth.auth().currentUser
        if let user = user {
          // The user's ID, unique to the Firebase project.
          // Do NOT use this value to authenticate with your backend server,
          // if you have one. Use getTokenWithCompletion:completion: instead.
            let uid = user.uid
            print("autoid:",uid)
        }
        getChatList()
//        finishSendingMessage()
    }
    
    func setDefault() {
        navigationView.frame = CGRect(x: 0, y: -20, width: self.view.frame.width, height: 90)
        navigationView.backgroundColor = .systemRed
        self.view.addSubview(navigationView)
        
        btnBack.frame = CGRect(x: 15, y: 50, width: 32, height: 32)
        btnBack.setImage(UIImage(named: "Backarrow"), for: .normal)
        self.navigationView.addSubview(btnBack)
        btnBack.addTarget(self, action: #selector(btnBackAction), for: .allTouchEvents)
        
        lblTitle.frame = CGRect(x: 64, y: 50, width: self.view.frame.width - 70, height: 33)
        lblTitle.textColor = .white
        lblTitle.text = userName
        self.navigationView.addSubview(lblTitle)
        
        
        viewGallery.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        viewGallery.backgroundColor = .black
        self.view.addSubview(viewGallery)
        btnClose.frame = CGRect(x: self.view.frame.width - 40, y: 30, width: 25, height: 25)
        btnClose.setImage(UIImage(named: "wrong"), for: .normal)
        btnClose.tintColor = .white
        viewGallery.addSubview(btnClose)
        
        imgPreview.frame = CGRect(x: 0, y: 80, width: self.view.frame.width, height: (self.view.frame.height-160))
        imgPreview.image = UIImage(named: "image_message_placeholder")
        viewGallery.addSubview(imgPreview)
        viewGallery.isHidden = true
        strChatIdRoot = strChatId
        print(strChatIdRoot)
        btnClose.addTarget(self, action: #selector(btnCloseAction), for: .allTouchEvents)
    }
    
    @objc func btnBackAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnCloseAction() {
        viewGallery.isHidden = true
        messageInputBar.isHidden = false
//        navigationController?.navigationBar.isHidden = false
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        // Show the navigation bar on other view controllers
//        self.navigationController?.isNavigationBarHidden = false
//    }
//    
    func configure() {
        let button = InputBarButtonItem()
        button.onKeyboardSwipeGesture { item, gesture in
            if gesture.direction == .left {
                item.inputBarAccessoryView?.setLeftStackViewWidthConstant(to: 0, animated: true)
            } else if gesture.direction == .right {
                item.inputBarAccessoryView?.setLeftStackViewWidthConstant(to: 36, animated: true)
            }
        }
        button.setSize(CGSize(width: 35, height: 30), animated: false)
        button.setImage(#imageLiteral(resourceName: "attachment").withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit //scaleToFill
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(Attechment), for: .allTouchEvents)
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
        if #available(iOS 13, *) {
            messageInputBar.inputTextView.layer.borderColor = UIColor.systemGray2.cgColor
        } else {
            messageInputBar.inputTextView.layer.borderColor = UIColor.lightGray.cgColor
        }
        messageInputBar.inputTextView.layer.borderWidth = 1.0
        messageInputBar.inputTextView.layer.cornerRadius = 16.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        messageInputBar.setLeftStackViewWidthConstant(to: 40, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)

        messageInputBar.shouldAnimateTextDidChangeLayout = true
    }
//    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
//        self.dismiss(animated: true, completion: { () -> Void in
//            print("image:",image!)
//            let user = SampleData.shared.currentSender
//            let message = MockMessage(image: image, user: user, messageId: UUID().uuidString, date: Date())
//            self.insertMessage(message)
//        })
//
//
//    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        // 1
        if let asset = info[.phAsset] as? PHAsset {
            let size = CGSize(width: 500, height: 500)
            PHImageManager.default().requestImage(
                for: asset,
                targetSize: size,
                contentMode: .aspectFit,
                options: nil) { result, info in
                
                guard let image = result else {
                    return
                }
//                let user = SampleData.shared.currentSender
//                let message = MockMessage(image: image, user: user, messageId: UUID().uuidString, date: Date())
//                self.insertMessage(message)
                //          self.sendPhoto(image)
            }
            
            // 2
        } else if let image = info[.originalImage] as? UIImage {
            let imageurl = info[.imageURL] as? URL
            uploadMedia(image: image, imageName: imageurl?.lastPathComponent ?? (String( NSDate().timeIntervalSince1970 * 1000) + ".jpeg"))
        }
    }


    func uploadMedia(image:UIImage, imageName:String) {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        
        var data = NSData()
        data = image.jpegData(compressionQuality: 0.8)! as NSData
        // set upload path
        let filePath = "images/\(imageName)"//"\(Auth.auth().currentUser!.uid)/\("images")"
        print(filePath)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        let storageRef = Storage.storage().reference().child(filePath)
        storageRef.putData(data as Data, metadata: metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                storageRef.downloadURL { (URL, error) -> Void in
                    if (error != nil) {
                        // Handle any errors
                    } else {
                        let UrlString = URL?.absoluteString
                        print(UrlString)
                        let user = SampleData.shared.currentSender
//                        let message = MockMessage(imageURL:  NSURL(string: UrlString ?? "")! as URL, user: user, messageId: UUID().uuidString, date: Date())
//                        self.insertMessage(message)
                        
                        let ref3 = Constants.refs3.databaseChats.childByAutoId()
                        let senderName = ((loggdenUser.string(forKey: NAME) ?? "") + "(\((loggdenUser.string(forKey: EMAIL) ?? "")))")
                        let message1 = [chat_id:ref3.key, pic_url : UrlString, receiver_id : loggdenUser.string(forKey: RECIEVER_ID), sender_id:user.senderId,sender_name:senderName,status:"0",text:"", time:"",timestamp:self.timeStampDate(), type1:"image"]

                        ref3.setValue(message1)
                        
                        let ref1 = Constants.refs1.databaseChats.child(loggdenUser.string(forKey: SENDER_ID)!).child(loggdenUser.string(forKey: RECIEVER_ID)!)
                        let message2 = ["date":self.timeStampDate(),"msg":"image","name":self.userName,"rid":loggdenUser.string(forKey: RECIEVER_ID)!,"status":"1","timestamp":self.timeStampDate()]
                        ref1.setValue(message2)
                        DispatchQueue.main.async {
                            activityIndicator.stopAnimating()
                        }
                    }
                }
            }
        }
    }

    func uploadPdf(url: URL, filename: String) {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()
        
        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        
        // File located on disk
        let localFile = url//URL(string: url)!
        
        // Create a reference to the file you want to upload
        let riversRef = storageRef.child("pdf/\(filename)")
        
        // Upload the file to the path "docs/rivers.pdf"
        let uploadTask = riversRef.putFile(from: localFile, metadata: nil) { metadata, error in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            
            riversRef.downloadURL { (URL, error) -> Void in
                if (error != nil) {
                    // Handle any errors
                    print(error)
                    print(error?.localizedDescription)
                } else {
                    // Get the download URL for 'images/stars.jpg'
                    
                    let UrlString = URL?.absoluteString
                    print(UrlString)
                    
                    let user = SampleData.shared.currentSender
//                    let message = MockLinkItem(text: "", attributedText: NSAttributedString(string: ""), url: URL ?? NSURL() as URL, title: filename, teaser: "", thumbnailImage: UIImage(named: "pdf")!)
//                    let msg1 = MockMessage(linkItem: message, user: user, messageId: UUID().uuidString, date:Date())
//                    self.insertMessage(msg1)
                    
                    
                    let ref3 = Constants.refs3.databaseChats.childByAutoId()
                    let senderName = ((loggdenUser.string(forKey: NAME) ?? "") + "(\((loggdenUser.string(forKey: EMAIL) ?? "")))")
                    let message1 = [chat_id:ref3.key, pic_url : UrlString, receiver_id : loggdenUser.string(forKey: RECIEVER_ID), sender_id:user.senderId,sender_name:senderName,status:"0",text:filename, time:"",timestamp:self.timeStampDate(), type1:"pdf"]

                    ref3.setValue(message1)
                    
                    let ref1 = Constants.refs1.databaseChats.child(loggdenUser.string(forKey: SENDER_ID)!).child(loggdenUser.string(forKey: RECIEVER_ID)!)
                    let message2 = ["date":self.timeStampDate(),"msg":"pdf","name":self.userName,"rid":loggdenUser.string(forKey: RECIEVER_ID)!,"status":"1","timestamp":self.timeStampDate()]
                    ref1.setValue(message2)
                    DispatchQueue.main.async {
                        activityIndicator.stopAnimating()
                    }
                    // you will get the String of Url
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func Attechment()  {
        let sheet = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        
        let photoAction = UIAlertAction(title: "Camera", style: .default) { (action) in

            let picker = UIImagePickerController()
             picker.delegate = self

             if UIImagePickerController.isSourceTypeAvailable(.camera) {
               picker.sourceType = .camera
             } else {
               picker.sourceType = .photoLibrary
             }

            self.present(picker, animated: true, completion: nil)
        }
        
        let gallaryAction = UIAlertAction(title: "Gallary", style: .default) { (action) in

            
            let picker = UIImagePickerController()
             picker.delegate = self


               picker.sourceType = .photoLibrary
            

            self.present(picker, animated: true, completion: nil)

        }
        
        let pdfAction = UIAlertAction(title: "PDF", style: .default) { (action) in

            let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.text", "com.apple.iwork.pages.pages", "public.data"], in: .import)

            documentPicker.delegate = self
            self.present(documentPicker, animated: true, completion: nil)
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        sheet.addAction(photoAction)
        sheet.addAction(gallaryAction)
        sheet.addAction(pdfAction)
        sheet.addAction(cancelAction)
        
        self.present(sheet, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        MockSocket.shared.connect(with: [SampleData.shared.nathan, SampleData.shared.wu])
            .onNewMessage { [weak self] message in
                self?.insertMessage(message)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        MockSocket.shared.disconnect()
        audioController.stopAnyOngoingPlaying()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func getChatList(){
        let activityIndicator = UIActivityIndicatorView()
        
        activityIndicator.style = .gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        let  ref: DatabaseReference?
        let handle: DatabaseHandle?

        ref = Database.database().reference()
print(strChatId)
        
//        let ref1 = ref?.child("chat").child(strChatId)
//
//        ref1?.setValue(ref1)
//        let firebaseId = loggdenUser.value(forKey:SENDER_ID)
        handle = ref?.child("chat").child(strChatId).observe(.childAdded, with: { (snapshot) in

            print("snapshot:",snapshot.value)
            if  let data        = snapshot.value as? [String: Any]
            {
               
              

               
                print("snapshotdata:",data)
//                let chatdata = data["t6TyVEi4rbOQjsgoBVd77JrIoOu2"] as? [String:String]
//                print("date:",chatdata)
//                print(chatdata?["date"])
                let msg1 = MockUser.init(senderId: data[sender_id] as! String, displayName: data[sender_name]as! String)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
                // Convert Date to String
                let strdate = dateFormatter.date(from: data[timestamp] as! String)
                
                if data[type1] as! String == "image"{                    
                    let message = MockMessage(imageURL: NSURL(string: data[pic_url] as! String)! as URL, user: msg1, messageId: data[chat_id] as! String, date: strdate ?? Date())
                    self.messageList.append(message)
                }
                else if data[type1] as! String == "pdf"{
                    
                    let link = MockLinkItem(text: "", attributedText: NSAttributedString(string: ""), url: NSURL(string: data[pic_url] as! String)! as URL, title: (data[text] as! String), teaser: "", thumbnailImage: UIImage(named: "pdf")!)
                    let msg1 = MockMessage(linkItem: link, user: msg1, messageId: data[chat_id] as! String, date: strdate ?? Date())
                    self.messageList.append(msg1)
                }
                else{
                    let msg2 = MockMessage.init(text: data[text] as! String, user: msg1, messageId: data[chat_id] as! String, date: strdate ?? Date())
                    self.messageList.append(msg2)
                }

                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem()
                self.messagesCollectionView.scrollToBottom()
                
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
               
            }
        })

        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
        }
    }
    
    @objc func displaymsg()  {
        let query = Constants.refs3.databaseChats.queryLimited(toLast: 10)

        let firebaseId = loggdenUser.value(forKey:SENDER_ID)
        print("firebaseId: ",firebaseId)
        _ = query.observe(.childAdded, with: { [weak self] snapshot in
            print("snapshot:",snapshot)

            if  let data        = snapshot.value as? [String: String],
                let chat_id          = data[chat_id],
                let pic_url        = data[pic_url],
                let receiver_id        = data[receiver_id],
                let sender_id          = data[sender_id],
                let sender_name        = data[sender_name],
                let status        = data[status],
                let text        = data[text],
                let time          = data[time],
                let timestamp        = data[timestamp],
                let type        = data[type1]
            {
                print("chatData: ",data)
                DispatchQueue.global(qos: .userInitiated).async {
                    let count = UserDefaults.standard.mockMessagesCount()
                    SampleData.shared.getMessages(count: count) { messages in
                        DispatchQueue.main.async {
                            let msg1 = MockUser.init(senderId: sender_id, displayName: sender_name)
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
                            // Convert Date to String
                           let strdate = dateFormatter.date(from: timestamp)
                            let msg2 = MockMessage.init(text: text, user: msg1, messageId: chat_id, date: strdate ?? Date())
                            print(messages)
                            self?.messageList.append(msg2)
//                            self?.messageList = messages
                            self?.messagesCollectionView.reloadData()
                            self?.messagesCollectionView.scrollToLastItem()
                        }
                    }
                }
            }
        })
    }
    
    func loadFirstMessages() {
        
        DispatchQueue.global(qos: .userInitiated).async {
            let count = UserDefaults.standard.mockMessagesCount()
            SampleData.shared.getMessages(count: count) { messages in
                DispatchQueue.main.async {
                    self.messageList = messages
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToLastItem()
                }
            }
        }
        

    }
    
    @objc func loadMoreMessages() {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
            SampleData.shared.getMessages(count: 20) { messages in
                DispatchQueue.main.async {
                    self.messageList.insert(contentsOf: messages, at: 0)
                    self.messagesCollectionView.reloadDataAndKeepOffset()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    func configureMessageCollectionView() {
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        
        scrollsToLastItemOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false

        showMessageTimestampOnSwipeLeft = true // default false
        
        messagesCollectionView.refreshControl = refreshControl
    }
    
    func configureMessageInputBar() {
        messageInputBar.delegate = self
        messageInputBar.inputTextView.tintColor = .primaryColor
        messageInputBar.sendButton.setTitleColor(.primaryColor, for: .normal)
        messageInputBar.sendButton.setTitleColor(
            UIColor.primaryColor.withAlphaComponent(0.3),
            for: .highlighted
        )
    }
    
    // MARK: - Helpers
    
    func insertMessage(_ message: MockMessage) {
        
        messageList.append(message)
        // Reload last section to update header/footer labels and insert a new one
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messageList.count - 1])
            if messageList.count >= 2 {
                messagesCollectionView.reloadSections([messageList.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToLastItem(animated: true)
            }
        })
    }
    
    func isLastSectionVisible() -> Bool {
        
        guard !messageList.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: messageList.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }

    // MARK: - MessagesDataSource

    func currentSender() -> SenderType {
        return SampleData.shared.currentSender
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
    }

    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }

//    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//        return NSAttributedString(string: "Read", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
//    }

//    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//        let name = message.sender.displayName
//        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
//    }

    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
}

// MARK: - MessageCellDelegate

extension ChatViewController: MessageCellDelegate {
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("Avatar tapped")
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
    }
    
    func didTapImage(in cell: MessageCollectionViewCell) {
        print("Image tapped")
        viewGallery.isHidden = false
        messageInputBar.isHidden = true
//        navigationController?.navigationBar.isHidden = true
        print(cell)
//        cell.focusItems(in: MediaItem)
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
            let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else {
                print("Failed to identify message when audio cell receive tap gesture")
                return
        }
        switch message.kind {
            case .photo(let photoItem):
                 let image = photoItem.url
                print(image)
                        // here is your image
//                let image1 = photoItem.image
//                    imgPreview.image = image1
                imgPreview.kf.setImage(with: image)
            
            default:
                break
            }
    }
    
    func didTapCellTopLabel(in cell: MessageCollectionViewCell) {
        print("Top cell label tapped")
    }
    
    func didTapCellBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom cell label tapped")
    }
    
    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
        print("Top message label tapped")
    }
    
    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom label tapped")
    }

    func didTapPlayButton(in cell: AudioMessageCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
            let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else {
                print("Failed to identify message when audio cell receive tap gesture")
                return
        }
        guard audioController.state != .stopped else {
            // There is no audio sound playing - prepare to start playing for given audio message
            audioController.playSound(for: message, in: cell)
            return
        }
        if audioController.playingMessage?.messageId == message.messageId {
            // tap occur in the current cell that is playing audio sound
            if audioController.state == .playing {
                audioController.pauseSound(for: message, in: cell)
            } else {
                audioController.resumeSound()
            }
        } else {
            // tap occur in a difference cell that the one is currently playing sound. First stop currently playing and start the sound for given message
            audioController.stopAnyOngoingPlaying()
            audioController.playSound(for: message, in: cell)
        }
    }

    func didStartAudio(in cell: AudioMessageCell) {
        print("Did start playing audio sound")
    }

    func didPauseAudio(in cell: AudioMessageCell) {
        print("Did pause audio sound")
    }

    func didStopAudio(in cell: AudioMessageCell) {
        print("Did stop audio sound")
    }

    func didTapAccessoryView(in cell: MessageCollectionViewCell) {
        print("Accessory view tapped")
    }

}

// MARK: - MessageLabelDelegate

extension ChatViewController: MessageLabelDelegate {
    func didSelectAddress(_ addressComponents: [String: String]) {
        print("Address Selected: \(addressComponents)")
    }
    
    func didSelectDate(_ date: Date) {
        print("Date Selected: \(date)")
    }
    
    func didSelectPhoneNumber(_ phoneNumber: String) {
        print("Phone Number Selected: \(phoneNumber)")
    }
    
    func didSelectURL(_ url: URL) {
        print("URL Selected: \(url)")
//        guard let url = URL(string: "https://stackoverflow.com") else { return }
        UIApplication.shared.open(url)
    }
    
    func didSelectTransitInformation(_ transitInformation: [String: String]) {
        print("TransitInformation Selected: \(transitInformation)")
    }

    func didSelectHashtag(_ hashtag: String) {
        print("Hashtag selected: \(hashtag)")
    }

    func didSelectMention(_ mention: String) {
        print("Mention selected: \(mention)")
    }

    func didSelectCustom(_ pattern: String, match: String?) {
        print("Custom data detector patter selected: \(pattern)")
    }
}

// MARK: - MessageInputBarDelegate

extension ChatViewController: InputBarAccessoryViewDelegate {

    @objc
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        processInputBar(messageInputBar)
    }

    func processInputBar(_ inputBar: InputBarAccessoryView) {
        // Here we can parse for which substrings were autocompleted
        let attributedText = inputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in

            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }

        let components = inputBar.inputTextView.components
        inputBar.inputTextView.text = String()
        inputBar.invalidatePlugins()
        // Send button activity animation
        inputBar.sendButton.startAnimating()
        inputBar.inputTextView.placeholder = "Sending..."
        // Resign first responder for iPad split view
        inputBar.inputTextView.resignFirstResponder()
        DispatchQueue.global(qos: .default).async {
            // fake send request task
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                inputBar.sendButton.stopAnimating()
                inputBar.inputTextView.placeholder = "Aa"
                

                self?.insertMessages(components)
                self?.messagesCollectionView.scrollToLastItem(animated: true)
            }
        }
    }

    private func insertMessages(_ data: [Any]) {
        for component in data {
            let user = SampleData.shared.currentSender
            if let str = component as? String {
                let message = MockMessage(text: str, user: user, messageId: UUID().uuidString, date: Date())
                
//                // Create Date
//                let date = Date()
//
//                // Create Date Formatter
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
                // Convert Date to String
               let strdate = timeStampDate()//dateFormatter.string(from: date)
                print(strdate)
                let ref3 = Constants.refs3.databaseChats.childByAutoId()
                let senderName = ((loggdenUser.string(forKey: NAME) ?? "") + "(\((loggdenUser.string(forKey: EMAIL) ?? "")))")
                let message1 = [chat_id:ref3.key, pic_url : "", receiver_id : loggdenUser.string(forKey: RECIEVER_ID), sender_id:user.senderId,sender_name:senderName,status:"0",text:str, time:"",timestamp:strdate, type1:"text"]
                ref3.setValue(message1)
                
                
                let ref1 = Constants.refs1.databaseChats.child(loggdenUser.string(forKey: SENDER_ID)!).child(loggdenUser.string(forKey: RECIEVER_ID)!)
                let message2 = ["date":strdate,"msg":str,"name":self.userName,"rid":loggdenUser.string(forKey: RECIEVER_ID)!,"status":"1","timestamp":strdate]
                ref1.setValue(message2)
                
                            
//                let msg1 = MockUser.init(senderId: user.senderId, displayName: user.displayName)
//                let msg2 = MockMessage.init(text: str, user: msg1, messageId: chat_id, date:Date())
//                insertMessage(msg2)
            } else if let img = component as? UIImage {
                let message = MockMessage(image: img, user: user, messageId: UUID().uuidString, date: Date())
                insertMessage(message)
            }
        }
    }
    func timeStampDate() -> String{
        // Create Date
        let date = Date()

        // Create Date Formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        // Convert Date to String
       let strdate = dateFormatter.string(from: date)
        print(strdate)
        return strdate
    }
}


extension ChatViewController: UIDocumentPickerDelegate{
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        let cico = url as URL
        print(cico)
        print(url)
        
        print(url.lastPathComponent)
        
        print(url.pathExtension)
        uploadPdf(url: url, filename: url.lastPathComponent)
    }
}
