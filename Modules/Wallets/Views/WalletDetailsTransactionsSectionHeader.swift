//
//  WalletDetailsTransactionsSectionHeader.swift
//  MyMonero
//
//  Created by Paul Shapiro on 7/19/17.
//  Copyright © 2017 MyMonero. All rights reserved.
//

import UIKit
//
extension WalletDetails
{
	class TransactionsSectionHeaderView: UIView
	{
		//
		enum Mode
		{
			case scanningIndicator
			case importTransactionsButton
		}
		static var bottomPadding: CGFloat {
			return 6
		}
		static func fullViewHeight(forMode: Mode, topPadding: CGFloat) -> CGFloat
		{
			return topPadding + 16 + TransactionsSectionHeaderView.bottomPadding // TODO: get fixed height instead of '16'
		}
		//
		// Properties - Settable after init
		var importTransactions_tapped_fn: ((Void) -> Void)?
		//
		// Properties - Settable via init
		var mode: Mode
		var wallet: Wallet // self SHOULD be torn down on a table .reloadData() so we can keep this as strong
		var contentView: UIView!
		init(mode: Mode, wallet: Wallet)
		{
			self.mode = mode
			self.wallet = wallet
			super.init(frame: .zero)
			self.setup()
		}
		required init?(coder aDecoder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
		func setup()
		{
			switch self.mode {
			case .scanningIndicator:
				let view = UICommonComponents.GraphicAndTwoUpLabelsActivityIndicatorView()
				// we will set the main text in layoutSubviews - oddly enough - b/c that is where we get informed of the superview width
				view.set(
					accessoryLabelText: String(
						format: NSLocalizedString(
							"%d blocks behind",
							comment: ""
						),
						self.wallet.nBlocksBehind
					)
				)
				do {
					view.frame = CGRect( // initial
						x: CGFloat.form_label_margin_x,
						y: 0, // will set in layoutSubviews
						width: 0, // we'll set this in layoutSubviews
						height: view.new_height_withoutVSpacing // cause we manage v spacing here
					)
				}
				view.isHidden = true // quirk of activityIndicator API - must start hidden in order to .show(), which triggers startAnimating() - could just reach in and call startAnimating directly, or improve API
				self.contentView = view
				self.addSubview(view)
				break
			case .importTransactionsButton:
				let view = UICommonComponents.LinkButtonView(mode: .mono_default, title: NSLocalizedString("IMPORT TRANSACTIONS", comment: ""))
				view.addTarget(self, action: #selector(importTransactions_tapped), for: .touchUpInside)
				view.frame = CGRect(
					x: CGFloat.form_label_margin_x,
					y: 0, // will set
					width: view.frame.size.width,
					height: view.frame.size.height
				)
				self.contentView = view
				self.addSubview(view)
				break
			}
		}
		//
		deinit
		{
			if self.mode == .scanningIndicator {
				if self.indicatorView.activityIndicator.isAnimating {
					self.indicatorView.activityIndicator.stopAnimating()
				}
				assert(self.indicatorView.activityIndicator.isAnimating == false)
			}
		}
		//
		//
		var indicatorView: UICommonComponents.GraphicAndTwoUpLabelsActivityIndicatorView {
			return self.contentView as! UICommonComponents.GraphicAndTwoUpLabelsActivityIndicatorView
		}
		//
		// Overrides - Imperatives
		override func layoutSubviews()
		{
			super.layoutSubviews()
			//
			let view = self.contentView! // why is ! necessary?
			let x = view.frame.origin.x // allow setup to specify x
			let w = self.mode == .importTransactionsButton ? view.frame.size.width : self.frame.size.width - 2*x // preserving sizedToFit LinkButtonView
			view.frame = CGRect(
				x: x,
				y: self.frame.size.height - view.frame.size.height - TransactionsSectionHeaderView.bottomPadding, // need to set Y
				width: w,
				height: view.frame.size.height
			)
			//
			switch self.mode {
				case .scanningIndicator:
					let isLargerFormatScreen = self.frame.size.width > 320
					let text = isLargerFormatScreen
						? NSLocalizedString("SCANNING BLOCKCHAIN…", comment: "") // ambiguous w/o " BLOCKCHAIN"
						: NSLocalizedString("SCANNING…", comment: "") // just not enough space
					if self.indicatorView.label.text != text {
						self.indicatorView.set(
							labelText: text
						)
					} else {
						// unlikely but possible
					}
				default:
					break // nothing to do
			}
		}
		//
		// Delegation - Interactions
		func importTransactions_tapped()
		{
			if let fn = self.importTransactions_tapped_fn {
				fn()
			}
		}
	}
}
