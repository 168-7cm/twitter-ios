//
//  TimeLineViewController.swift
//  Buzztter
//
//  Created by kou yamamoto on 2021/01/06.
//

import UIKit
import Swifter
import ImageViewer
import SVProgressHUD

class TweetListViewController: UIViewController {
    
    @IBOutlet weak var TweetListTableView: UITableView!
    @IBOutlet weak var segmentedControll: UISegmentedControl!
    
    let swifter = Swifter(consumerKey: "ZSvKGOHjFxeX8im8katf7RC4i", consumerSecret: "djqFCpF3lKZiAaxSSYONS1F9abmJt1ikF8WWtIPAGjnRxrcWef")
    
    let userDefault = UserDefaults.standard
    
    //クエリのパラメーター
    var searchQuery = "?q=min_faves:1000 exclude:retweets filter:images"
    var maxID = "0"
    let lang = "ja"
    let locale = "ja"
    let resultType = "mixed"
    let searchCount = 10
    
    var Tweets: [Tweet] = []
    
    let refreshControl = UIRefreshControl()
    
    private var galleryDelegate: GalleryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        searchTweet(swifter: swifter)
        reflesh()
    }
}

extension TweetListViewController {
    
    func searchTweet(swifter: Swifter) {
        
        SVProgressHUD.show()
        
        swifter.searchTweet(using: searchQuery ,lang: lang, locale: locale, resultType: resultType, count: searchCount, maxID: maxID, tweetMode: .extended, success:{ [self] response, arg  in
            
            //ツイート数
            let tweets = response.array!
            
            for tweet in tweets {
                //Tweet情報
                let tweetID = (Int(tweet["id_str"].string ?? "")! - 1)
                maxID = String(tweetID)
                
                //名前、ユーザー名、プロフィール写真
                let accountName = tweet["user"]["name"].string ?? ""
                let screenName = tweet["user"]["screen_name"].string ?? ""
                let profileImageURL = tweet["user"]["profile_image_url"].string ?? ""
                
                //ツイート文とツイート画像
                var tweetText = tweet["full_text"].string ?? ""
                let urlEmbeddedInText = tweet["extended_entities"]["media"][0]["url"].string ?? ""
                tweetText = tweetText.replacingOccurrences(of:urlEmbeddedInText, with: "")
                
                let tweetImages = tweet["extended_entities"]["media"].array ?? []
                var tweetImageURLs = tweetImages.map{$0["media_url_https"].string ?? ""}
                
                //リツイート・ファボ数
                let retweetCount = Int(tweet["retweet_count"].double!)
                let favoriteCount = Int(tweet["favorite_count"].double!)/1000
                
                var tweet = Tweet(profileImageURL: profileImageURL, accountName: accountName, screenName: screenName, tweetText:tweetText, tweetImages: tweetImageURLs, retweetCount: String(retweetCount), favoriteCount: String(favoriteCount))
                
                Tweets.append(tweet)
                
            }
            
            TweetListTableView.reloadData()
            SVProgressHUD.dismiss()
            
        }, failure: { error in
            print(error.localizedDescription)
            SVProgressHUD.dismiss()
        })
    }
    
    //再読み込み
    func reflesh() {
        refreshControl.addTarget(self, action: #selector(self.reloadTweet), for: UIControl.Event.valueChanged)
        TweetListTableView.refreshControl = refreshControl
    }
    
    //際読み込み用
    @objc func reloadTweet() {
        searchTweet(swifter: swifter)
        refreshControl.endRefreshing()
    }
    
    //画像表示
    func showGallery(imageUrls: [String]) {
        galleryDelegate = GalleryDelegate(imageUrls: imageUrls)
        let galleryViewController = GalleryViewController(startIndex: 0,itemsDataSource: galleryDelegate!,
                                                          configuration: [.deleteButtonMode(.none), .seeAllCloseButtonMode(.none), .thumbnailsButtonMode(.none)])
        present(galleryViewController, animated: true, completion: nil)
    }
    
    //tableviewの設定
    func setupTableView() {
        TweetListTableView.tableFooterView = UIView()
        TweetListTableView.delegate = self
        TweetListTableView.dataSource = self
    }
}

extension TweetListViewController {
    //画像タップ
    @objc func firstImageDidTapped(gestureRecognizer: UITapGestureRecognizer) {
        let tappedLocation = gestureRecognizer.location(in: TweetListTableView)
        let tappedIndexPath = TweetListTableView.indexPathForRow(at: tappedLocation)
        let tappedRow = tappedIndexPath?.row
        if let indexpath = tappedRow {
            var image = [String]()
            image.append(Tweets[indexpath].tweetImages[0])
            showGallery(imageUrls: image)
        }
    }
    
    @objc func secondImageDidTapped(gestureRecognizer: UITapGestureRecognizer) {
        let tappedLocation = gestureRecognizer.location(in: TweetListTableView)
        let tappedIndexPath = TweetListTableView.indexPathForRow(at: tappedLocation)
        let tappedRow = tappedIndexPath?.row
        if let indexpath = tappedRow {
            var image = [String]()
            image.append(Tweets[indexpath].tweetImages[1])
            showGallery(imageUrls: image)
        }
    }
    
    @objc func thirdImageDidTapped(gestureRecognizer: UITapGestureRecognizer) {
        let tappedLocation = gestureRecognizer.location(in: TweetListTableView)
        let tappedIndexPath = TweetListTableView.indexPathForRow(at: tappedLocation)
        let tappedRow = tappedIndexPath?.row
        if let indexpath = tappedRow {
            var image = [String]()
            image.append(Tweets[indexpath].tweetImages[2])
            showGallery(imageUrls: image)
        }
    }
    
    @objc func forthImageDidTapped(gestureRecognizer: UITapGestureRecognizer) {
        let tappedLocation = gestureRecognizer.location(in: TweetListTableView)
        let tappedIndexPath = TweetListTableView.indexPathForRow(at: tappedLocation)
        let tappedRow = tappedIndexPath?.row
        if let indexpath = tappedRow {
            var image = [String]()
            image.append(Tweets[indexpath].tweetImages[3])
            showGallery(imageUrls: image)
        }
    }
}

extension TweetListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweet_cell", for: indexPath) as! TweetTableViewCell
        cell.setupTweet(tweet: Tweets[indexPath.row])
        
        //画像タップするため
        let tapGesture1: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(firstImageDidTapped(gestureRecognizer:)))
        let tapGesture2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(secondImageDidTapped(gestureRecognizer:)))
        let tapGesture3: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(thirdImageDidTapped(gestureRecognizer:)))
        let tapGesture4: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(forthImageDidTapped(gestureRecognizer:)))
        cell.firstTweetPictureImageView.addGestureRecognizer(tapGesture1)
        cell.secondTweetPictureImageView.addGestureRecognizer(tapGesture2)
        cell.thirdTweetPictureImageView.addGestureRecognizer(tapGesture3)
        cell.forthTweetPictureImageView.addGestureRecognizer(tapGesture4)
        
        return cell
    }
    
    //セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
