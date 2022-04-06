//
//  UserCell.swift
//  ExampleTawk
//
//  Created by Himanshu on 29/03/22.
//

import Foundation
import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mAvtarImageView: UIImageView!
    @IBOutlet weak var mUsernameLbl: UILabel!
    @IBOutlet weak var mDetailLbl: UILabel!
    @IBOutlet weak var mNoteImageView: UIImageView!
    var userDataModel : UserData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateNoteImageWithMode()
    }
    
    func updateNoteImageWithMode() {
        mNoteImageView.image = mNoteImageView.image?.withRenderingMode(.alwaysTemplate)
        mNoteImageView.tintColor = UITraitCollection.current.userInterfaceStyle == .dark ? .white : .black
    }
    
    func updateUI(userDataModel: UserData) {
        ImageDownloader.shared.downloadImage(with: userDataModel.avatar_url ?? "", completionHandler: { (image, cached) in
            self.mAvtarImageView.image = image
        }, placeholderImage: UIImage(named: "profile"))
        updateNoteImageWithMode()
        mUsernameLbl.text = userDataModel.login
        mDetailLbl.text = "detail"
        mNoteImageView.isHidden = !(userDataModel.isNote ?? false)
    }
}
