import UIKit


final class CurrencyViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CurrencyViewCell"
    
    var id: String?
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .blackDay
        return imageView
    }()
    
    private lazy var name: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .blackDay
        return label
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .greenUniversal
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            layer.borderWidth = isSelected ? 1 : 0
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(currency: CurrencyModel) {
        if let url = URL(string: currency.image) {
            imageView.kf.setImage(with: url)
        }
        name.text = currency.title
        title.text = currency.name
        id = currency.id
    }
}

private extension CurrencyViewCell {
    
    func setupCell() {
        setupAppearance()
        addSubviews()
        activateConstraints()
    }
    
    func setupAppearance() {
        backgroundColor = .lightGrayDay
        layer.cornerRadius = 12
        layer.masksToBounds = true
        layer.borderColor = UIColor.blackDay.cgColor
    }
    
    func addSubviews() {
        [imageView,
        name,
        title
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            imageView.heightAnchor.constraint(equalToConstant: 36),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1),
            name.topAnchor.constraint(equalTo: imageView.topAnchor),
            name.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -12),
            name.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4),
            name.bottomAnchor.constraint(equalTo: title.topAnchor),
            title.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -12),
            title.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4),
            title.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
        ])
    }
}
