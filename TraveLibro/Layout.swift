
import UIKit
import Spring

class HorizontalLayout: UIView {
    
    var xOffsets: [CGFloat] = []
    
    init(height: CGFloat) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: height))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        var width: CGFloat = 0
        
        for i in 0..<subviews.count {
            let view = subviews[i] as UIView
            view.layoutSubviews()
            width += xOffsets[i]
            view.frame.origin.x = width
            width += view.frame.width
        }
        
        self.frame.size.width = width
        
    }
    
    override func addSubview(_ view: UIView) {
        
        xOffsets.append(view.frame.origin.x)
        super.addSubview(view)
        
    }
    
    func removeAll() {
        
        for view in subviews {
            view.removeFromSuperview()
        }
        xOffsets.removeAll(keepingCapacity: false)
        
    }
    
}



class HorizontalFitLayout: HorizontalLayout {
    
    
    override init(height: CGFloat) {
        super.init(height: height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        var width: CGFloat = 0
        var zeroWidthView: UIView?
        
        for i in 0..<subviews.count {
            let view = subviews[i] as UIView
            width += xOffsets[i]
            if view.frame.width == 0 {
                zeroWidthView = view
            } else {
                width += view.frame.width
            }
        }
        
        if width < superview!.frame.width && zeroWidthView != nil {
            zeroWidthView!.frame.size.width = superview!.frame.width - width
        }
        
        super.layoutSubviews()
        
    }
    
}



class VerticalLayout: SpringView {
    
    var yOffsets: [CGFloat] = []
    
    init(width: CGFloat) {
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        var height: CGFloat = 0
        
        for i in 0..<subviews.count {
            let view = subviews[i] as UIView
            view.layoutSubviews()
            height += yOffsets[i]
            view.frame.origin.y = height
            height += view.frame.height
        }
        
        self.frame.size.height = height
        
    }
    
    override func addSubview(_ view: UIView) {
        
        yOffsets.append(view.frame.origin.y)
        super.addSubview(view)
        
    }
    
    func removeAll() {
        
        for view in subviews {
            view.removeFromSuperview()
        }
        yOffsets.removeAll(keepingCapacity: false)
        
    }
    
}


class VerticalScreenLayout: VerticalLayout {
    
    
    init() {
        super.init(width: UIScreen.main.bounds.width)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        self.frame.size.width = UIScreen.main.bounds.width
        super.layoutSubviews()
        
    }
    
}


class VerticalFitLayout: VerticalLayout {
    
    
    override init(width: CGFloat) {
        super.init(width: width)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        var height: CGFloat = 0
        var zeroHeightView: UIView?
        
        for i in 0..<subviews.count {
            let view = subviews[i] as UIView
            height += yOffsets[i]
            if view.frame.height == 0 {
                zeroHeightView = view
            } else {
                height += view.frame.height
            }
        }
        
        if height < superview!.frame.height && zeroHeightView != nil {
            zeroHeightView!.frame.size.height = superview!.frame.height - height
        }
        
        super.layoutSubviews()
        
    }
    
}

