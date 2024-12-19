import UIKit
import SnapKit

class KickboardDetailView: UIView {
    
    // MARK: - UI Components
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.white.cgColor
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var kickboardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "kickboard_box1")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .leading
        return stack
    }()
    
    lazy var codeLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.bodyBold
        label.text = "None"
        label.textColor = Colors.gray4
        return label
    }()
    
    lazy var batteryView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        let icon = UIImageView(image: UIImage(named: "battery_full"))
        let label = UILabel()
        label.font = Fonts.bodyBold
        label.textColor = Colors.mint
        stack.addArrangedSubview(icon)
        stack.addArrangedSubview(label)
        return stack
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.bodyBold
        label.textColor = Colors.gray3
        return label
    }()
    
    lazy var remainingTimeLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.bodyBold
        label.textAlignment = .left
        label.textColor = Colors.gray3
        
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.bodyBold
        label.textAlignment = .right
        label.textColor = Colors.gray3
        return label
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 12
        return stack
    }()
    
    // MARK: - 클로저 프로퍼티 추가
    var closeButtonTappedAction: (() -> Void)?
    var actionButtonTappedAction: (() -> Void)?
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = .clear
        
        addSubview(containerView)
        
        buttonStackView.applyTwoButtonsViewStyle(
            actionLeft: { [weak self] in self?.closeButtonTappedAction?() },  // 클로저 호출
            actionRight: { [weak self] in self?.actionButtonTappedAction?() }, // 클로저 호출
            titleLeft: "닫기",
            titleRight: "대여하기",
            colorSide: .right
        )

        containerView.addSubview(kickboardImageView)
        containerView.addSubview(infoStackView)
        containerView.addSubview(timeLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(buttonStackView)
        containerView.addSubview(remainingTimeLabel)
        
        infoStackView.addArrangedSubview(codeLabel)
        infoStackView.addArrangedSubview(batteryView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(256)
        }
        
        kickboardImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(40)
        }
        
        infoStackView.snp.makeConstraints {
            $0.leading.equalTo(kickboardImageView.snp.trailing).offset(12)
            $0.top.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        timeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(infoStackView.snp.bottom).offset(8)
        }
        
        priceLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalTo(timeLabel)
        }
        
        remainingTimeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(infoStackView.snp.bottom).offset(8)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(50)
        }
    }
    
    // MARK: - UI Update Methods
    func updateUI(for status: KickboardStatus) {
        switch status {
        case .idle:
            buttonStackView.updateButtonsStyle(
                titleLeft: "닫기",
                titleRight: "대여하기"
            )
                
        case .isReady:
            buttonStackView.updateButtonsStyle(
                titleLeft: "닫기",
                titleRight: "사용시작"
            )
            
        case .isComing:
            buttonStackView.updateButtonsStyle(
                titleLeft: "취소",
                titleRight: "오는중"
            )
            
        case .riding:
            buttonStackView.updateButtonsStyle(
                titleLeft: "취소",
                titleRight: "반납하기"
            )
        }
    }
    
    func updateTimeLabel(_ time: Int) {
        let minutes = time / 60
        let seconds = time % 60
        timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
}
