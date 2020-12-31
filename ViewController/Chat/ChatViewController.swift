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
/// A base class for the example controllers
class ChatViewController: MessagesViewController, MessagesDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // MARK: - Public properties

    /// The `BasicAudioController` controll the AVAudioPlayer state (play, pause, stop) and udpate audio cell UI accordingly.
    lazy var audioController = BasicAudioController(messageCollectionView: messagesCollectionView)

    lazy var messageList: [MockMessage] = []
    
    private(set) lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
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
    let ref3 = Constants.refs3.databaseChats.childByAutoId()
//
//    let chatdata : chat? = nil
    var imagePicker = UIImagePickerController()
 
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.isHidden = false
//        self.navigationController?.isToolbarHidden = false
        self.navigationController?.isNavigationBarHidden = false
        configureMessageCollectionView()
        configureMessageInputBar()
        configure()
//        loadFirstMessages()
        title = "MessageKit"
        displaymsg()
       
        
//        finishSendingMessage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Show the navigation bar on other view controllers
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func configure() {
        let button = InputBarButtonItem()
        button.onKeyboardSwipeGesture { item, gesture in
            if gesture.direction == .left {
                item.inputBarAccessoryView?.setLeftStackViewWidthConstant(to: 0, animated: true)
            } else if gesture.direction == .right {
                item.inputBarAccessoryView?.setLeftStackViewWidthConstant(to: 36, animated: true)
            }
        }
        button.setSize(CGSize(width: 36, height: 36), animated: false)
        button.setImage(#imageLiteral(resourceName: "attachment").withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill//scaleAspectFit
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
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)

        
//        messageInputBar.shouldAnimateTextDidChangeLayout = true
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
            let user = SampleData.shared.currentSender
            let message = MockMessage(image: image, user: user, messageId: UUID().uuidString, date: Date())
            self.insertMessage(message)
            //          self.sendPhoto(image)
        }
        
        // 2
      } else if let image = info[.originalImage] as? UIImage {
        //        sendPhoto(image)
        let user = SampleData.shared.currentSender
        let message = MockMessage(image: image, user: user, messageId: UUID().uuidString, date: Date())
        self.insertMessage(message)
        uploadMedia(image: image)
      }
    }


    func uploadMedia(image:UIImage) {
        var data = NSData()
        data = image.jpegData(compressionQuality: 0.8)! as NSData
         // set upload path
        let filePath = "images/abc"//"\(Auth.auth().currentUser!.uid)/\("images")"
        print(filePath)
        let metaData = StorageMetadata()
         metaData.contentType = "image/jpeg"
        Storage.storage().reference().child(filePath).putData(data as Data, metadata: metaData){(metaData,error) in
             if let error = error {
                 print(error.localizedDescription)
                 return
             }else{
             //store downloadURL
                let downloadURL = metaData?.description
                print(downloadURL)
             //store downloadURL at database
//                self.databaseRef.child("users").child(Auth.auth().currentUser!.uid).updateChildValues(["userPhoto": downloadURL])
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
    
    @objc func displaymsg()  {
        let query = Constants.refs3.databaseChats.queryLimited(toLast: 10)

        _ = query.observe(.childAdded, with: { [weak self] snapshot in

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

//        showMessageTimestampOnSwipeLeft = true // default false
        
        
        
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
                
                // Create Date
                let date = Date()

                // Create Date Formatter
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
                // Convert Date to String
               let strdate = dateFormatter.string(from: date)
                print(strdate)
//                let message1 = [chat_id: "", pic_url : "", receiver_id : "", sender_id:user.senderId,sender_name:user.displayName,status:"",text:str, time:"",timestamp:strdate, type:"text"]
//
//                self.ref3.setValue(message1)
//                let msg1 = MockUser.init(senderId: user.senderId, displayName: user.displayName)
//                let msg2 = MockMessage.init(text: str, user: msg1, messageId: chat_id, date:Date())
//                insertMessage(msg2)
                
                insertMessage(message)
            } else if let img = component as? UIImage {
                let message = MockMessage(image: img, user: user, messageId: UUID().uuidString, date: Date())
                insertMessage(message)
            }
        }
    }
}

