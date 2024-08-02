import UIKit


final class NFTBasketCell: UITableViewCell {
    
    static let reuseIdentifier = "NFTBasketCell"
    
    private var deleteNftAction: ((String) -> ())?
    
    private var id: String?
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private lazy var ratingView = Rating()
    
    private lazy var priceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.text = "Цена"
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var removeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "basket_delete"), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(nft: NFTBasketModel, deleteNftAction: @escaping (String) -> ()) {
        id = nft.id
        nftImageView.kf.setImage(with: nft.imageUrl)
        nameLabel.text = nft.name
        ratingView.setup(count: nft.rating)
        priceLabel.text = String(format: "%.2f", nft.price) + " ETH"
        self.deleteNftAction = deleteNftAction
    }
}

private extension NFTBasketCell {
    
    func setupCell() {
        selectionStyle = .none
        addSubviews()
        activateConstraints()
        addActions()
    }
    
    func addSubviews() {
        [
        nftImageView,
        nameLabel,
        ratingView,
        priceTitleLabel,
        priceLabel,
        removeButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    func activateConstraints() {
        let container = UILayoutGuide()
        let infoContainer = UILayoutGuide()
        contentView.addLayoutGuide(container)
        contentView.addLayoutGuide(infoContainer)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 140),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nftImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            nftImageView.topAnchor.constraint(equalTo: container.topAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            nftImageView.widthAnchor.constraint(equalTo: nftImageView.heightAnchor, multiplier: 1),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            infoContainer.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            infoContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
            infoContainer.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            infoContainer.trailingAnchor.constraint(lessThanOrEqualTo: removeButton.leadingAnchor),
            removeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            removeButton.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            removeButton.heightAnchor.constraint(equalToConstant: 40),
            removeButton.widthAnchor.constraint(equalToConstant: 40),
            nameLabel.topAnchor.constraint(equalTo: infoContainer.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: infoContainer.trailingAnchor),
            ratingView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ratingView.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor),
            ratingView.trailingAnchor.constraint(lessThanOrEqualTo: infoContainer.trailingAnchor),
            priceTitleLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 12),
            priceTitleLabel.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor),
            priceTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: infoContainer.trailingAnchor),
            priceLabel.topAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor, constant: 2),
            priceLabel.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor),
            priceLabel.trailingAnchor.constraint(lessThanOrEqualTo: infoContainer.trailingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: infoContainer.bottomAnchor)
        ])
    }
    
    func addActions() {
        removeButton.addTarget(self, action: #selector(Self.deleteNft), for: .touchUpInside)
    }
    
    @objc
    func deleteNft() {
        guard let id else { return }
        deleteNftAction?(id)
    }
}
