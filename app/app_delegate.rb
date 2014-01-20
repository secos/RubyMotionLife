class AppDelegate
  def applicationDidFinishLaunching(notification)
    buildMenu
    buildWindow
  end

  def buildWindow
    @mainWindow = NSWindow.alloc.initWithContentRect([[400, 300], [480, 400]],
      styleMask: NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask,
      backing: NSBackingStoreBuffered,
      defer: false)
    @mainWindow.title = NSBundle.mainBundle.infoDictionary['CFBundleName']
    @mainWindow.setAcceptsMouseMovedEvents true

    @life_view = LifeView.alloc.initWithFrame(NSMakeRect(0, 40, 480, 360))
    @life_view.autoresizingMask = NSViewWidthSizable|NSViewHeightSizable
    @mainWindow.contentView.addSubview(@life_view)

    slider1 = NSSlider.alloc.initWithFrame(NSMakeRect(140, 5, 100, 21))
    slider1.action = :"takeFramerateFrom:"
    slider1.target = @life_view
    slider1.minValue = 1
    slider1.maxValue = 100
    slider1.intValue = 10
    slider1.autoresizingMask = NSViewMinXMargin
    @mainWindow.contentView.addSubview(slider1)


    button = NSButton.alloc.initWithFrame(NSMakeRect(250, 5, 63, 28))
    button.title = "Clear" 
    button.action = "clear:" 
    button.target = @life_view
    button.bezelStyle = NSRoundedBezelStyle 
    button.autoresizingMask = NSViewMinXMargin 
    @mainWindow.contentView.addSubview(button)


    color_well = NSColorWell.alloc.initWithFrame(NSMakeRect(320, 5, 53, 30))
    color_well.color = NSColor.blueColor 
    color_well.action = :"takeColorFrom:" 
    color_well.target = @life_view
    color_well.autoresizingMask = NSViewMinXMargin 
    @mainWindow.contentView.addSubview(color_well)

    @button = NSButton.alloc.initWithFrame(NSMakeRect(390, 5, 63, 28))
    @button.title = "Go" 
    @button.action = "toggleAnimation:" 
    @button.target = self
    @button.bezelStyle = NSRoundedBezelStyle 
    @button.autoresizingMask = NSViewMinXMargin 
    @mainWindow.contentView.addSubview(@button)

    @mainWindow.orderFrontRegardless
  end

  def toggleAnimation(sender)
    @life_view.toggleAnimation(sender)
    @button.title = (@button.title == "Go" ? "Stop" : "Go")
  end
end
