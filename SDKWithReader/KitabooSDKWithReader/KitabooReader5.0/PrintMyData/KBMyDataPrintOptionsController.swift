//
//  KBMyDataPrintOptionsController.swift
//  KitabooSDKWithReader
//
//  Created by CEPL on 16/09/21.
//  Copyright © 2021 Hurix Systems. All rights reserved.
//

import UIKit

@objc public protocol KBMyDataPrintOptionsControllerDelegate: AnyObject {
    func didTapOnPrintType(printType: PrintType)
}

@objc public enum PrintType: NSInteger {
    case both = 0
    case highlights
    case notes
    case none
}

@objc public class KBMyDataPrintOptionsController: UIViewController {
    
    let highLights = LocalizationHelper.localizedString(key: "HIGHLIGHTS_KEY")
    let notes = LocalizationHelper.localizedString(key: "NOTES_KEY")
    let both = LocalizationHelper.localizedString(key: "BOTH_KEY")
    let cancelButtonTitle = LocalizationHelper.localizedString(key: "CANCEL")
    let printButtonTitle = LocalizationHelper.localizedString(key: "PRINT_KEY")
    let myDataTitle = LocalizationHelper.localizedString(key: "HELP_MY_DATA_BUTTON_TITLE")
    var popupTitle = ""
    var printTypes = [String]()
    
    @objc public var kbthemeVO: KBHDThemeVO!
    @objc public var hiddenPrintType: PrintType = .none
    @objc public weak var delegate: KBMyDataPrintOptionsControllerDelegate?
    var selectedIndex = 0
    
    //MARK: - ViewLifeCycle Methods
    public override func viewDidLoad() {
        super.viewDidLoad()
        printTypes = [both, highLights, notes]
        popupTitle = "\(printButtonTitle): \(myDataTitle)"
        //UI Setup
        if isIpad() {
            addPrintOptionsForiPad()
            view.backgroundColor = .black.withAlphaComponent(0.25)
        } else {
            addPrintOptionsForiPhone()
        }
    }
    
    private func addPrintOptionsForiPhone() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let action = { [self] (action: UIAlertAction) in
            if let selectedIndex = alert.actions.firstIndex(where: { $0 == action }) {
                self.selectedIndex = selectedIndex
            }
            self.didTapOnPrintOption()
        }
        printTypes = printOptionsForiPhone()
        //Add options button
        for type in printTypes {
            alert.addAction(UIAlertAction(title: type, style: .default, handler: action))
        }
        
        //Add cancel button
        alert.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler:{_ in 
            self.dismissController()
        }))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func addPrintOptionsForiPad() {
        //Add dismiss BG button
        let dismissButton = UIButton()
        view.addSubview(dismissButton)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        dismissButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        dismissButton.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        
        //Add option container
        let optionsContainer = UIView()
        let aspectRatioConstraint = NSLayoutConstraint(item: optionsContainer,attribute: .height,relatedBy: .equal,toItem: optionsContainer,attribute: .width,multiplier: (2.0 / 1.0),constant: 0)
        optionsContainer.addConstraint(aspectRatioConstraint)
        view.addSubview(optionsContainer)
        optionsContainer.backgroundColor = .white
        optionsContainer.translatesAutoresizingMaskIntoConstraints = false
        optionsContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        optionsContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        optionsContainer.widthAnchor.constraint(equalToConstant: 280).isActive = true
        optionsContainer.heightAnchor.constraint(equalToConstant: 260).isActive = true
        optionsContainer.clipsToBounds = true
        optionsContainer.layer.cornerRadius = 4.0
        optionsContainer.layer.borderWidth = 1
        optionsContainer.layer.borderColor = kbthemeVO.toc_popup_border.cgColor
        
        //Add title
        let headerLabel = UILabel()
        optionsContainer.addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.topAnchor.constraint(equalTo: optionsContainer.topAnchor, constant: 24).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: optionsContainer.leadingAnchor, constant: 25).isActive = true
        headerLabel.text = popupTitle
        headerLabel.textColor = kbthemeVO.toc_selected_toc_title_color
        headerLabel.font = getCustomFontForWeight(18, .regular)
        
        //Add print options
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        optionsContainer.addSubview(tableView)
        tableView.tableHeaderView = UIView(frame: .zero)
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 18).isActive = true
        tableView.leadingAnchor.constraint(equalTo: optionsContainer.leadingAnchor, constant: 1).isActive = true
        tableView.trailingAnchor.constraint(equalTo: optionsContainer.trailingAnchor, constant: -1).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 48*3).isActive = true
        tableView.register(PrintTypeCell.self, forCellReuseIdentifier: PrintTypeCell.identifier)
        
        //Add print button
        let printButton = UIButton()
        optionsContainer.addSubview(printButton)
        printButton.translatesAutoresizingMaskIntoConstraints = false
        printButton.bottomAnchor.constraint(equalTo: optionsContainer.bottomAnchor, constant: -14).isActive = true
        printButton.trailingAnchor.constraint(equalTo: optionsContainer.trailingAnchor, constant: -30).isActive = true
        printButton.setTitle(printButtonTitle, for: .normal)
        printButton.setTitleColor(kbthemeVO.toc_selected_toc_title_color ?? .blue, for: .normal)
        printButton.titleLabel?.font = getCustomFontForWeight(18, .regular)
        printButton.addTarget(self, action: #selector(didTapOnPrintOption), for: .touchUpInside)
        
        //Add cancel button
        let cancelButton = UIButton()
        optionsContainer.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.centerYAnchor.constraint(equalTo: printButton.centerYAnchor).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: printButton.leadingAnchor, constant: -27).isActive = true
        cancelButton.setTitle(cancelButtonTitle, for: .normal)
        cancelButton.setTitleColor(kbthemeVO.toc_more_icon_color ?? .gray, for: .normal)
        cancelButton.titleLabel?.font = getCustomFontForWeight(18, .regular)
        cancelButton.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
    }
    
    @objc func dismissController() {
        dismiss(animated: true, completion:nil)
    }
    
    @objc func didTapOnPrintOption() {
        dismiss(animated: true, completion: { [self] in
            delegate?.didTapOnPrintType(printType: PrintType(rawValue: selectedIndex) ?? .both)
        })
    }
    
    private func printOptionsForiPhone() -> [String] {
        if hiddenPrintType == .highlights {
            return [notes]
        } else if hiddenPrintType == .notes {
            return [highLights]
        }
        return [both, highLights, notes]
    }
    
    private func disableSelection(_ printOption: PrintType, for cell: PrintTypeCell, at indexPath: IndexPath) -> Bool {
        if printOption.rawValue == indexPath.row {
            cell.disableView.backgroundColor = UIColor.init(white: 1, alpha: 0.5)
            cell.isUserInteractionEnabled = false
        } else if printOption.rawValue == indexPath.row {
            cell.disableView.backgroundColor = UIColor.init(white: 1, alpha: 0.5)
            cell.isUserInteractionEnabled = false
        } else if indexPath.row == 0 {
            cell.disableView.backgroundColor = UIColor.init(white: 1, alpha: 0.5)
            cell.isUserInteractionEnabled = false
        } else {
            cell.disableView.backgroundColor = .clear
            cell.isUserInteractionEnabled = true
            return true
        }
        return false
    }
    
}

extension KBMyDataPrintOptionsController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return printTypes.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PrintTypeCell.identifier) as! PrintTypeCell
        let type = printTypes[indexPath.row]
        
        var isSelected = false
        if hiddenPrintType != .none {
            isSelected = disableSelection(hiddenPrintType, for: cell, at: indexPath)
        } else {
            isSelected = indexPath.row == selectedIndex
        }
        
        cell.configCell(with: type, selectStatus: isSelected, with: kbthemeVO)
        return cell
    }
    
}

extension KBMyDataPrintOptionsController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndex = indexPath.row
        tableView.reloadData()
    }
    
}

//MARK: - PrintTypeCell
final class PrintTypeCell: UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = getCustomFontForWeight(14, .regular)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let roundView: RadioButton = {
        let roundButton = RadioButton(diameter: 20, buttonColor: .blue)
        roundButton.translatesAutoresizingMaskIntoConstraints = false
        return roundButton
    }()
    
    let disableView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        contentView.addSubview(roundView)
        roundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14).isActive = true
        roundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14).isActive = true
        roundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24).isActive = true
        roundView.widthAnchor.constraint(equalToConstant: roundView.diameter).isActive = true
        roundView.heightAnchor.constraint(equalToConstant: roundView.diameter).isActive = true
        
        contentView.addSubview(typeLabel)
        typeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        typeLabel.leadingAnchor.constraint(equalTo: roundView.trailingAnchor, constant: 31).isActive = true
        typeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        typeLabel.heightAnchor.constraint(equalToConstant: roundView.diameter).isActive = true
        
        contentView.addSubview(disableView)
        disableView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        disableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        disableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        disableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}

extension PrintTypeCell {
    
    func configCell(with type: String, selectStatus isSelecetd: Bool, with theme: KBHDThemeVO) {
        typeLabel.textColor = theme.toc_description_color ?? .black
        typeLabel.text = type
        roundView.buttonColor = theme.toc_popup_border ?? .blue
        roundView.isSelected = isSelecetd
    }
    
}

//MARK: - RadioButton
final class RadioButton: UIView {
    let diameter: CGFloat
    var buttonColor: UIColor
    
    private var innerShapeLayer = CAShapeLayer()
    private var outerShapeLayer = CAShapeLayer()
    var isSelected: Bool = false {
        didSet {
            innerShapeLayer.fillColor = isSelected ? buttonColor.cgColor : UIColor.clear.cgColor
            outerShapeLayer.strokeColor = buttonColor.cgColor
        }
    }
    
    init(diameter: CGFloat, buttonColor: UIColor) {
        self.diameter = diameter
        self.buttonColor = buttonColor
        super.init(frame: .zero)
        addOuterCircel()
        addInnerCircel()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addOuterCircel() {
        let shapeLayer = outerShapeLayer
        shapeLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: diameter, height: diameter)).cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = buttonColor.cgColor
        shapeLayer.lineWidth = 1.0
        layer.addSublayer(shapeLayer)
    }
    
    private func addInnerCircel() {
        let shapeLayer = innerShapeLayer
        let size = diameter/2
        let centerPoint = size - size/2
        shapeLayer.path = UIBezierPath(ovalIn: CGRect(x: centerPoint, y: centerPoint, width: size, height: size)).cgPath
        shapeLayer.fillColor = isSelected ? buttonColor.cgColor : UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 1.0
        layer.addSublayer(shapeLayer)
    }
    
}
