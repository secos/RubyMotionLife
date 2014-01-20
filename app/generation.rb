class Generation

  attr_reader :height, :width

  # height: the height of the simulation
  # width: the width of the simulation
  # first_gen: array of arrays containing x,y coordinates of initial cells
  #            [[x,y],[x1,y1] ... ] 
  def initialize(height=100, width=100, first_gen = [])
    @height = height
    @width = width
    @generation = Hash.new
    first_gen.each {|x,y| set(x,y) }
  end

  def clear
    @generation.clear
  end

  def translate_coordinate(x,y)
    [x % @width, y % @height]
  end

  def cells
    @generation.keys
  end

  def get(x,y)
    @generation[translate_coordinate(x,y)]
  end

  def set(x,y)
    @generation[translate_coordinate(x,y)] = true
  end

  def unset(x,y)
    @generation.delete translate_coordinate(x,y)
  end

  def flip(x,y)
    if get(x,y)
      unset(x,y)
    else
      set(x,y)
    end
  end

  def num_neighbors_for(x,y)
    count = 0

    count +=1 if get(x-1, y-1)
    count +=1 if get(x  , y-1)
    count +=1 if get(x+1, y-1)

    count +=1 if get(x-1, y)
    count +=1 if get(x+1, y)

    count +=1 if get(x-1, y+1)
    count +=1 if get(x  , y+1)
    count +=1 if get(x+1, y+1)

    count
  end

  def next_generation
    nextgen = Generation.new(height, width)
    height.times do |y|
      width.times do |x|
        # From: http://en.wikipedia.org/wiki/Conway's_Game_of_Life
        #   Any live cell with fewer than two live neighbours dies, as if caused by under-population.
        #   Any live cell with two or three live neighbours lives on to the next generation.
        #   Any live cell with more than three live neighbours dies, as if by overcrowding.
        #   Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
        neighbors = num_neighbors_for(x,y)
        if (neighbors == 2 && get(x,y)) || neighbors == 3
          nextgen.set(x,y)
        end
      end
    end
    nextgen
  end

  def resize(new_height, new_width)
    gen = Generation.new(new_height, new_width)
    new_height.times do |y|
      new_width.times do |x|
        gen.set(x,y) if get(x,y)
      end
    end
    gen
  end
end
