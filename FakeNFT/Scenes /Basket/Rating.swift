import UIKit


final class Rating: UIView {
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            UIImageView(image: UIImage(named: "rating_star")),
            UIImageView(image: UIImage(named: "rating_star")),
            UIImageView(image: UIImage(named: "rating_star")),
            UIImageView(image: UIImage(named: "rating_star")),
            UIImageView(image: UIImage(named: "rating_star"))
        ])
        stack.spacing = 2
        stack.distribution = .equalSpacing
        return stack
    }()
    
    init() {
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(count: Int) {
        let normalCount = max(0, min(count, 5))
    
        for (index, view) in stackView.arrangedSubviews.enumerated() {
            guard let imageView = view as? UIImageView else { return }
            
            if index < normalCount {
                imageView.tintColor = UIColor(hexString: "#FEEF0D")
            } else {
                imageView.tintColor = UIColor(hexString: "#F7F7F8")
            }
        }
    }
    
    private func initialize() {
        addSubview(stackView)
        stackView.constraintEdges(to: self)
    }
}
