//
//  TeacherReviewStudentListTableViewCell.swift
//  KitabooSDKWithReader
//
//  Created by Manoranjan Nayak on 21/06/21.
//  Copyright © 2021 Hurix Systems. All rights reserved.
//

import UIKit

class TeacherReviewStudentListTableViewCell: UITableViewCell {
    var isDataAvailable = false
    var studentId:String?
    var indexPath:IndexPath?
    let mainView = UIView.init()
    let blurView = UIView.init()
    var userNamaLabelCenterYAnchor:NSLayoutConstraint?
    var userNamaLabelTopAnchor:NSLayoutConstraint?
    
    let profileImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: "User_Profile_Pic")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let userNameLabel:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.black
        label.text = "User Name"
        label.font = getCustomFontForWeight(14, .medium)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    let submitStatusLabel:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.black
        label.text = "Yet to submit"
        label.font = getCustomFontForWeight(12, .medium)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        constructUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constructUI() {
        self.contentView.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        mainView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        mainView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        mainView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        mainView.addSubview(profileImageView)
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = isIpad() ? 20 : 17
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 10).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: isIpad() ? 40 : 35).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: isIpad() ? 40 : 35).isActive = true
        
        mainView.addSubview(userNameLabel)
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20).isActive = true
        userNamaLabelCenterYAnchor = userNameLabel.centerYAnchor.constraint(equalTo: mainView.centerYAnchor)
        userNamaLabelCenterYAnchor!.isActive = true
        userNamaLabelTopAnchor = userNameLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 10)
        userNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        userNameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func showSubmitStatus(isTrue:Bool) {
        isDataAvailable = !isTrue
        if isTrue {
            userNamaLabelCenterYAnchor!.isActive = false
            userNamaLabelTopAnchor!.isActive = true
            mainView.addSubview(submitStatusLabel)
            submitStatusLabel.translatesAutoresizingMaskIntoConstraints = false
            submitStatusLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20).isActive = true
            submitStatusLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -10).isActive = true
            submitStatusLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
            submitStatusLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
            
            blurView.backgroundColor = UIColor(white: 1, alpha: 0.6)
            mainView.addSubview(blurView)
            blurView.translatesAutoresizingMaskIntoConstraints = false
            blurView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor).isActive = true
            blurView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor).isActive = true
            blurView.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
            blurView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
        } else {
            userNamaLabelCenterYAnchor!.isActive = true
            userNamaLabelTopAnchor!.isActive = false
            if submitStatusLabel.isDescendant(of: mainView) {
                submitStatusLabel.removeFromSuperview()
            }
            if blurView.isDescendant(of: mainView) {
                blurView.removeFromSuperview()
            }
        }
    }
    
    func setProfileImageUrl(_ imageUrl:String) {
        self.profileImageView.load(url: URL(string: imageUrl)!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
