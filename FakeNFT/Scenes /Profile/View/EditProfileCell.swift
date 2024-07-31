import Foundation
import UIKit

final class EditProfileCell: UICollectionViewCell {
    // MARK: - Public Properties
    static let cellID = "EditProfileCell"
    
    // MARK: - Private Properties
    
    private lazy var textViewInCell: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 12
        textView.backgroundColor = UIColor(named: "ypLightGray")
        textView.font = UIFont.sfProRegular17
        textView.textColor = UIColor(named: "ypBlack")
        textView.layer.masksToBounds = true
        textView.textContainerInset = UIEdgeInsets(
            top: 11,
            left: 16,
            bottom: 11,
            right: 16
        )
        return textView
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        customizingScreenElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc func handleTapGesture() {
        print("Tap Gesture did tap")
        textViewInCell.resignFirstResponder()
    }

    // MARK: - Public Methods
    func changingNFT(text: String) {
        textViewInCell.text = text
    }
    
    // MARK: - Private Methods
    private func customizingScreenElements() {
        contentView.addSubview(textViewInCell)
        
        textViewInCell.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textViewInCell.topAnchor.constraint(equalTo: contentView.topAnchor),
            textViewInCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textViewInCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textViewInCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTapGesture)
        )
        self.addGestureRecognizer(tapGesture)
    }
}
