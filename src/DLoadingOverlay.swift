import Foundation

@objc(DLoadingOverlay) class DLoadingOverlay : CDVPlugin {
    
    var loadingView : DLoadingOverlayView?
    
    override func pluginInitialize() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pageDidLoad:", name: "CDVPageDidLoadNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pageDidStart:", name: "CDVPluginResetNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setVisibleNotification:", name: "DLoadingOverlaySetVisibleNotification", object: nil)
    }
    
    func setVisible(command : CDVInvokedUrlCommand) {
        internalSetVisible(command.arguments[0] as! Bool)
    }
    
    func internalSetVisible(shouldShow: Bool) {
        if shouldShow {
            if (loadingView != nil) {
                loadingView?.removeView()
            }
            loadingView = DLoadingOverlayView.loadingViewInView((self.webView!.window?.subviews[0])!)
        }
        else {
            if (loadingView != nil) {
                loadingView?.removeView()
                loadingView = nil
            }
        }
    }
    
    func setVisibleNotification(notification : NSNotification) {
        print("Notified to set overlay visibility to false")
        internalSetVisible(notification.object as! Bool)
    }
    
    func pageDidLoad(notification : NSNotification) {
        internalSetVisible(false)
    }
    
    func pageDidStart(notification : NSNotification) {
        internalSetVisible(true)
    }
}