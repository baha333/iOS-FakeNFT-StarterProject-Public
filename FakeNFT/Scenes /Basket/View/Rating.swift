import UIKit


final class Rating: UIView {
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            UIImageView(),
            UIImageView(),
            UIImageView(),
            UIImageView(),
            UIImageView()
        ])
        stack.spacing = 2
        stack.distribution = .equalSpacing
        return stack
    }()
    
    init() {
        super.init(frame: .zero)
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
                imageView.image = UIImage(named: "rating_star_active")
            } else {
                imageView.image = UIImage(named: "rating_star_no_active")
            }
        }
    }
    
    private func initialize() {
        addSubview(stackView)
        stackView.constraintEdges(to: self)
    }
}
