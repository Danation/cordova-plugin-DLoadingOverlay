import Foundation

@objc(DLoadingOverlay) class DLoadingOverlay : CDVPlugin {
    
    var loadingView : DLoadingOverlayView?
    
    override func pluginInitialize() {
        NotificationCenter.default.addObserver(self, selector: #selector(DLoadingOverlay.pageDidLoad), name: NSNotification.Name(rawValue: "CDVPageDidLoadNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DLoadingOverlay.pageDidStart), name: NSNotification.Name(rawValue: "CDVPluginResetNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DLoadingOverlay.setVisibleNotification), name: NSNotification.Name(rawValue: "DLoadingOverlaySetVisibleNotification"), object: nil)
    }
    
    @objc(setVisible:)
    func setVisible(command : CDVInvokedUrlCommand) {
        internalSetVisible(shouldShow: command.arguments[0] as! Bool)
    }
    
    func internalSetVisible(shouldShow: Bool) {
        if shouldShow {
            if (loadingView != nil) {
                loadingView?.removeView()
            }
            loadingView = DLoadingOverlayView.loadingViewInView(aSuperview: (self.webView!.window?.subviews[0])!)
        }
        else {
            if (loadingView != nil) {
                loadingView?.removeView()
                loadingView = nil
            }
        }
    }
    
    func setVisibleNotification(notification : NSNotification) {
        print("Notified to set overlay visibility to false", terminator: "")
        internalSetVisible(shouldShow: notification.object as! Bool)
    }
    
    func pageDidLoad(notification : NSNotification) {
        internalSetVisible(shouldShow: false)
    }
    
    func pageDidStart(notification : NSNotification) {
        internalSetVisible(shouldShow: true)
    }
}