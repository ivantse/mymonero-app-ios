//
//  Links.swift
//  MyMonero
//
//  Created by Paul Shapiro on 6/3/17.
//  Copyright © 2017 MyMonero. All rights reserved.
//

import UIKit

extension UICommonComponents
{
	class LinkButtonView: UIButton
	{
		enum Mode
		{
			case mono_default
			case mono_destructive
			case sansSerif_default
		}
		var mode: Mode!
		init(mode: Mode, title: String)
		{
			let frame = CGRect(
				x: 0,
				y: 0, 
				width: 0,
				height: 24 // increased height for touchability
			)
			super.init(frame: frame)
			self.mode = mode
			self.setTitleText(to: title)
		}
		required init?(coder aDecoder: NSCoder)
		{
			fatalError("init(coder:) has not been implemented")
		}
		//
		func setTitleText(to title: String)
		{ // use this instead of setTitle
			let normal_attributedTitle = NSAttributedString(
				string: title,
				attributes:
				[
					NSForegroundColorAttributeName: UIColor.utilityOrConstructiveLinkColor,
					NSFontAttributeName: UIFont.smallRegularMonospace,
					NSUnderlineStyleAttributeName: NSUnderlineStyle.styleNone.rawValue
				]
			)
			let selected_attributedTitle = NSAttributedString(
				string: title,
				attributes:
				[
					NSForegroundColorAttributeName: UIColor.utilityOrConstructiveLinkColor,
					NSFontAttributeName: UIFont.smallRegularMonospace,
					NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue
				]
			)
			let disabled_attributedTitle = NSAttributedString(
				string: title,
				attributes:
				[
					NSForegroundColorAttributeName: UIColor.disabled_utilityOrConstructiveLinkColor,
					NSFontAttributeName: UIFont.smallRegularMonospace,
					NSUnderlineStyleAttributeName: NSUnderlineStyle.styleNone.rawValue
				]
			)
			self.setAttributedTitle(normal_attributedTitle, for: .normal)
			self.setAttributedTitle(selected_attributedTitle, for: .highlighted)
			self.setAttributedTitle(selected_attributedTitle, for: .selected)
			self.setAttributedTitle(disabled_attributedTitle, for: .disabled)
			//
			// now that we have title and font…
			self.sizeToFit()
		}
	}
}
