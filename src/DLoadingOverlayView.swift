//
//  Created by Matt Gallagher on 12/04/09.
//  Copyright Matt Gallagher 2009. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//
//  Converted to Swift by Danation

import Foundation
import QuartzCore

@objc(DLoadingOverlayView) class DLoadingOverlayView : UIView {

    //
    // NewPathWithRoundRect
    //
    // Creates a CGPathRect with a round rect of the given radius.
    //
    func newPathWithRoundRect(rect : CGRect, cornerRadius : CGFloat) -> CGPath {
        //
        // Create the boundary path
        //
        let path = CGMutablePath()
        path.move(to: CGPoint(x:rect.origin.x,
                              y:rect.origin.y + rect.size.height - cornerRadius))

        // Top left corner
        path.addArc(tangent1End: CGPoint(x:rect.origin.x,
                                         y:rect.origin.y),
                    tangent2End: CGPoint(x:rect.origin.x + rect.size.width,
                                         y:rect.origin.y),
                    radius: cornerRadius)

        // Top right corner
        path.addArc(tangent1End: CGPoint(x:rect.origin.x + rect.size.width,
                                         y:rect.origin.y),
                    tangent2End: CGPoint(x:rect.origin.x + rect.size.width,
                                         y:rect.origin.y + rect.size.height),
                    radius: cornerRadius)

        // Bottom right corner
        path.addArc(tangent1End: CGPoint(x:rect.origin.x + rect.size.width,
                                         y:rect.origin.y + rect.size.height),
                    tangent2End: CGPoint(x:rect.origin.x,
                                         y:rect.origin.y + rect.size.height),
                    radius: cornerRadius)
        
        // Bottom left corner
        path.addArc(tangent1End: CGPoint(x:rect.origin.x,
                                         y:rect.origin.y + rect.size.height),
                    tangent2End: CGPoint(x:rect.origin.x,
                                         y:rect.origin.y),
                    radius: cornerRadius)
        
        // Close the path at the rounded rect
        path.closeSubpath();
        
        return path;
    }

    // loadingViewInView:
    //
    // Constructor for this view. Creates and adds a loading view for covering the
    // provided aSuperview.
    //
    // Parameters:
    //    aSuperview - the superview that will be covered by the loading view
    //
    // returns the constructed view, already added as a subview of the aSuperview
    //	(and hence retained by the superview)
    //
    class func loadingViewInView(aSuperview : UIView) -> DLoadingOverlayView
    {
    	let loadingView = DLoadingOverlayView(frame: aSuperview.bounds)
    
    	loadingView.isOpaque = false
    	loadingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        aSuperview.addSubview(loadingView)
  
        let DEFAULT_LABEL_WIDTH:CGFloat = 280
        let DEFAULT_LABEL_HEIGHT:CGFloat = 50
        
        var labelFrame = CGRect(x: 0, y: 0, width: DEFAULT_LABEL_WIDTH, height: DEFAULT_LABEL_HEIGHT)

        let loadingLabel = UILabel(frame: labelFrame)

    	loadingLabel.text = "Loading..."
        
    	loadingLabel.textColor = UIColor.white
        loadingLabel.backgroundColor = UIColor.clear
        loadingLabel.textAlignment = .center
        loadingLabel.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        loadingLabel.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        loadingView.addSubview(loadingLabel)

        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        loadingView.addSubview(activityIndicatorView)

    	activityIndicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
    	activityIndicatorView.startAnimating()
    
        let totalHeight:CGFloat = loadingLabel.frame.size.height + activityIndicatorView.frame.size.height
    	labelFrame.origin.x = floor(0.5 * (loadingView.frame.size.width - DEFAULT_LABEL_WIDTH))
    	labelFrame.origin.y = floor(0.5 * (loadingView.frame.size.height - totalHeight))
    	loadingLabel.frame = labelFrame
    
    	var activityIndicatorRect = activityIndicatorView.frame;
    	activityIndicatorRect.origin.x = 0.5 * (loadingView.frame.size.width - activityIndicatorRect.size.width);
    	activityIndicatorRect.origin.y = loadingLabel.frame.origin.y + loadingLabel.frame.size.height;
    	activityIndicatorView.frame = activityIndicatorRect;
    
    	// Set up the fade-in animation
    	let animation = CATransition()
        animation.type = kCATransitionFade

        aSuperview.layer.add(animation, forKey: "layerAnimation")
    
        return loadingView;
    }

    //
    // removeView
    //
    // Animates the view out from the superview. As the view is removed from the
    // superview, it will be released.
    //
    
    func removeView() {
        removeFromSuperview()
        if let aSuperview = self.superview {
            // Set up the animation
            let animation = CATransition()
            animation.type = kCATransitionFade
            aSuperview.layer.add(animation, forKey: "layerAnimation")
        }
    }

    //
    // drawRect:
    //
    // Draw the view.
    //
    override func draw(_ rect: CGRect) {

        let RECT_PADDING:CGFloat = 0.0
        let	rect = rect.insetBy(dx: RECT_PADDING, dy: RECT_PADDING)
        
        let ROUND_RECT_CORNER_RADIUS:CGFloat = 0.0
        let roundRectPath = newPathWithRoundRect(rect: rect, cornerRadius: ROUND_RECT_CORNER_RADIUS)
        
        let context = UIGraphicsGetCurrentContext()
        
        let BACKGROUND_OPACITY:CGFloat = 0.50
        
        let RGB_VALUE:CGFloat = 0.5
        
        context!.setFillColor(red: RGB_VALUE, green: RGB_VALUE, blue: RGB_VALUE, alpha: BACKGROUND_OPACITY)
        context!.addPath(roundRectPath)
        context?.fillPath()
        
        let STROKE_OPACITY:CGFloat = 0.0
        context!.setStrokeColor(red: 1, green: 1, blue: 1, alpha: STROKE_OPACITY)
        context!.addPath(roundRectPath)
        context!.strokePath()
    }
}