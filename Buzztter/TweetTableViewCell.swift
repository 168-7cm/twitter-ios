//
//  TweetTableViewCell.swift
//  Buzztter
//
//  Created by kou yamamoto on 2021/01/06.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var accountAndScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var firstTweetPictureImageView: UIImageView!
    @IBOutlet weak var secondTweetPictureImageView: UIImageView!
    @IBOutlet weak var thirdTweetPictureImageView: UIImageView!
    @IBOutlet weak var forthTweetPictureImageView: UIImageView!
    @IBOutlet weak var leftStackView: UIStackView!
    @IBOutlet weak var rightStackView: UIStackView!
    @IBOutlet weak var parentStackView: UIStackView!
    
    @IBOutlet var PriorityContstraints: NSLayoutConstraint!
    
    func setupTweet(tweet: Tweet) {
        
        accountAndScreenNameLabel.text = "\(tweet.accountName)  @\(tweet.screenName)"
        favoriteCountLabel.text = "\(tweet.favoriteCount)万"
        iconImageView.image = UIImage(url: tweet.profileImageURL)
        tweetTextLabel.text = tweet.tweetText
        retweetCountLabel.text = tweet.retweetCount
        
        let tweetPicturesCount = tweet.tweetImages.count
        
        firstTweetPictureImageView.isHidden = false
        secondTweetPictureImageView.isHidden = false
        thirdTweetPictureImageView.isHidden = false
        forthTweetPictureImageView.isHidden = false
        rightStackView.isHidden = false
        leftStackView.isHidden = false
        parentStackView.isHidden = false
        PriorityContstraints.isActive = true

        switch tweetPicturesCount {
        
        case 0:
            firstTweetPictureImageView.isHidden = true
            secondTweetPictureImageView.isHidden = true
            thirdTweetPictureImageView.isHidden = true
            forthTweetPictureImageView.isHidden = true
            rightStackView.isHidden = true
            leftStackView.isHidden = true
            parentStackView.isHidden = true
            PriorityContstraints.isActive = false
        
        case 1:
            firstTweetPictureImageView.image = UIImage(url: tweet.tweetImages[0])
            secondTweetPictureImageView.isHidden = true
            thirdTweetPictureImageView.isHidden = true
            forthTweetPictureImageView.isHidden = true
            rightStackView.isHidden = true
            
        case 2:
            firstTweetPictureImageView.image = UIImage(url:tweet.tweetImages[0])
            secondTweetPictureImageView.image = UIImage(url: tweet.tweetImages[1])
            thirdTweetPictureImageView.isHidden = true
            forthTweetPictureImageView.isHidden = true
            
        case 3:
            firstTweetPictureImageView.image = UIImage(url:tweet.tweetImages[0])
            secondTweetPictureImageView.image = UIImage(url: tweet.tweetImages[1])
            thirdTweetPictureImageView.image = UIImage(url: tweet.tweetImages[2])
            forthTweetPictureImageView.isHidden = true
            
        case 4:
            firstTweetPictureImageView.image = UIImage(url:tweet.tweetImages[0])
            secondTweetPictureImageView.image = UIImage(url: tweet.tweetImages[1])
            thirdTweetPictureImageView.image = UIImage(url: tweet.tweetImages[2])
            forthTweetPictureImageView.image = UIImage(url: tweet.tweetImages[3])
            
        default:
            break
        }
    }
}
//UIImageをURL指定するため
extension UIImage {
    
    public convenience init(url: String) {
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            self.init(data: data)!
            return
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        self.init()
    }
}
