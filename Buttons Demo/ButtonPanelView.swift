//
//  ButtonPanelView.swift
//  Buttons Demo
//
//  Created by Alejandrina Patrón López on 6/13/20.
//  Copyright © 2020 Alejandrina Patrón López. All rights reserved.
//
import UIKit

/// Protocol to handle interactions with buttons in the button panel.
protocol ButtonPanelDelegate: NSObject {

  
  /// Notifies the delegate that a button in the panel was tapped.
  /// - Parameter text: The text in the button that was tapped.
  func didTapButtonWithText(_ text: String)
}

fileprivate let buttonSize: CGFloat = 56
fileprivate let shadowOpacity: Float = 0.7

class ButtonPanelView: UIView {

  weak var delegate: ButtonPanelDelegate?

  lazy var menuButton: UIButton = {
    let button = UIButton(frame: .zero)
    button.setTitle("➕", for: .normal)
    button.backgroundColor = .clear
    button.layer.cornerRadius = buttonSize / 2
    button.addTarget(
      self, action: #selector(handleTogglePanelButtonTapped(_:)), for: .touchUpInside)
    return button
  }()

  lazy var dogButton: UIButton = {
    let button = UIButton(frame: .zero)
    button.setTitle("🐶", for: .normal)
    button.layer.cornerRadius = buttonSize / 2
    button.isHidden = true
    button.addTarget(
      self, action: #selector(handleExpandedButtonTapped(_:)), for: .touchUpInside)
    return button
  }()

  lazy var catButton: UIButton = {
    let button = UIButton(frame: .zero)
    button.setTitle("🐱", for: .normal)
    button.layer.cornerRadius = buttonSize / 2
    button.isHidden = true
    button.addTarget(
      self, action: #selector(handleExpandedButtonTapped(_:)), for: .touchUpInside)
    return button
  }()

  lazy var expandedStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.isHidden = true
    stackView.addArrangedSubview(dogButton)
    stackView.addArrangedSubview(catButton)
    return stackView
  }()

  lazy var containerStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.addArrangedSubview(expandedStackView)
    stackView.addArrangedSubview(menuButton)
    return stackView
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor(red: 81/255, green: 166/255, blue: 219/255, alpha: 1)

    layer.cornerRadius = buttonSize / 2
    layer.shadowColor = UIColor.lightGray.cgColor
    layer.shadowOpacity = shadowOpacity

    layer.shadowOffset = .zero

    addSubview(containerStackView)
    setConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setConstraints() {
    // Main button
    menuButton.translatesAutoresizingMaskIntoConstraints = false
    menuButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
    menuButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true

    // Dog button
    dogButton.translatesAutoresizingMaskIntoConstraints = false
    dogButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
    dogButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true

    // Cat button
    catButton.translatesAutoresizingMaskIntoConstraints = false
    catButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
    catButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true

    // Container stack view
    containerStackView.translatesAutoresizingMaskIntoConstraints = false
    containerStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    containerStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

    translatesAutoresizingMaskIntoConstraints = false
    self.widthAnchor.constraint(equalTo: containerStackView.widthAnchor).isActive = true
    self.heightAnchor.constraint(equalTo: containerStackView.heightAnchor).isActive = true
  }
}

// MARK: - Gestures

extension ButtonPanelView {
  @objc private func handleTogglePanelButtonTapped(_ sender: UIButton) {
    let willExpand = expandedStackView.isHidden
    let menuButtonNewTitle = willExpand ? "❌" : "➕"
    UIView.animate(
      withDuration:0.3, delay: 0, options: .curveEaseIn,
      animations: {
        self.expandedStackView.subviews.forEach { $0.isHidden = !$0.isHidden }
        self.expandedStackView.isHidden = !self.expandedStackView.isHidden
        if willExpand {
          self.menuButton.setTitle(menuButtonNewTitle, for: .normal)
        }
    }, completion: { _ in
      // When collapsing, wait for animation to finish before changing from "x" to "+"
      if !willExpand {
        self.menuButton.setTitle(menuButtonNewTitle, for: .normal)
      }
    })
  }

  @objc private func handleExpandedButtonTapped(_ sender: UIButton) {
    guard let label = sender.titleLabel, let text = label.text else { return }
    delegate?.didTapButtonWithText(text)
  }
}
