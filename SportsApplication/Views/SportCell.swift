//
//  SportCell.swift
//  SportsApplication
//
//  Created by Hell on 27/12/2021.
//

import UIKit

protocol SportDelegate: class {
    func addImage(_ cell:SportCell)
}

class SportCell: UITableViewCell {
    
    @IBOutlet weak var sportName: UILabel!
    @IBOutlet weak var sportImage: UIImageView!
    
    var sport:Sport!
    weak var delegate: SportDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        sportImage.isUserInteractionEnabled = true
        sportImage.addGestureRecognizer(tapGR)
        // Initialization code
    }
    
    @objc func imageTapped(_ sender:UITapGestureRecognizer){
        delegate?.addImage(self)
    }
    
    func configureCell(text:String?, imageData:Data?){
        sportName.text = text
        if let imageData = imageData {
            sportImage.image = UIImage(data: imageData)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
