class LifeView < NSView
  attr_accessor :generation

  def initWithFrame(frame)
    super(frame)

    @cellsize = 10
    @fps = 10

    @generation = Generation.new((frame.size.height / @cellsize).ceil,
                                 (frame.size.width / @cellsize).ceil)

    @color = NSColor.blueColor
    self
  end

  def drawRect(rect)
    NSColor.whiteColor.set
    NSRectFill(bounds)

    height = (rect.size.height / @cellsize).ceil
    width = (rect.size.width / @cellsize).ceil
    if (height != @generation.height) || (width != @generation.width)
      resize(rect)
    end

    draw_cells
  end

  def resize(rect)
    height = (rect.size.height / @cellsize).ceil
    width = (rect.size.width / @cellsize).ceil
    @generation = generation.resize(height, width)
  end

  def draw_cells
    generation.cells.each do |x,y|
      draw_cell *translate_from_simulation_to_screen(x,y)
    end
  end

  # 
  def translate_from_screen_to_simulation(x,y)
    [x.floor / @cellsize, y.floor / @cellsize]
  end

  def translate_from_simulation_to_screen(x,y)
    [x * @cellsize, y * @cellsize]
  end

  def mouseMoved
    cell = current_cell(convertPoint(event.locationInWindow, fromView:nil))
    if cell != @last_cell
      puts "Cell: #{cell.inspect} active: #{generation.get(*cell)} neighbors: #{generation.num_neighbors_for(*cell)}}"
    end
    @last_cell = cell
  end

  def current_cell(point)
    translate_from_screen_to_simulation(point.x, point.y)
  end

  # def mouseDown(event)
  #   # p(mouseDown: event)
  #   cell = current_cell(convertPoint(event.locationInWindow, fromView:nil))
  #   if cell != @last_cell
  #     set_cell convertPoint(event.locationInWindow, fromView:nil)
  #   end
  #   @last_cell = cell
  #   setNeedsDisplay(true)
  # end

  def mouseDragged(event)
    # p(mouseDragged: event)
    cell = current_cell(convertPoint(event.locationInWindow, fromView:nil))
    if cell != @last_cell
      set_cell convertPoint(event.locationInWindow, fromView:nil)
    end
    @last_cell = cell
    setNeedsDisplay(true)
  end

  def mouseUp(event)
    # p(mouseUp: event)
    cell = current_cell(convertPoint(event.locationInWindow, fromView:nil))
    if cell != @last_cell
      set_cell convertPoint(event.locationInWindow, fromView:nil)
    end
    @last_cell = cell
    setNeedsDisplay(true)
  end

  def set_cell(point)
    # p(point: point)
    x,y = translate_from_screen_to_simulation point.x, point.y
    generation.flip(x,y)
  end

  def draw_cell(x,y)
    rect = NSMakeRect(0, 0, 0, 0)
    rect.origin.x = x
    rect.origin.y = y
    rect.size.width  = @cellsize
    rect.size.height = @cellsize
    
    @color.set
    NSBezierPath.bezierPathWithOvalInRect(rect).fill
  end

  def takeColorFrom(sender)
    @color = sender.color
    setNeedsDisplay true
  end

  def takeFramerateFrom(sender)
    setFramerate(sender)
  end

  def setFramerate(sender)
    @fps = sender.intValue
    startAnimation(sender) if @timer
  end

  def clear(sender)
    generation.clear
    setNeedsDisplay true
  end

  def startAnimation(sender)
    stopAnimation sender

    # We schedule a timer for a desired 30fps animation rate.
    # In performAnimation: we determine exactly
    # how much time has elapsed and animate accordingly.
    @timer = NSTimer.scheduledTimerWithTimeInterval 1.0/@fps.to_f,
      target:self,
      selector:'performAnimation:',
      userInfo:nil,
      repeats:true

    # The next two lines make sure that animation will continue to occur
    # while modal panels are displayed and while event tracking is taking
    # place (for example, while a slider is being dragged).
    NSRunLoop.currentRunLoop.addTimer @timer, forMode:NSModalPanelRunLoopMode
    NSRunLoop.currentRunLoop.addTimer @timer, forMode:NSEventTrackingRunLoopMode
  end

  def stopAnimation(sender)
    if @timer
      @timer.invalidate
      @timer = nil
    end
  end

  def toggleAnimation(sender)
    if @timer
      stopAnimation sender
    else
      startAnimation sender
    end
  end

  def performAnimation(timer)
    @generation = generation.next_generation
    setNeedsDisplay true
  end

end
