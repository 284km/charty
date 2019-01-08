require 'iruby'
require 'gruff'

module Charty
  class Gruff
    def initialize
      @plot = ::Gruff
    end

    def label(x, y)
    end

    def series=(series)
      @series = series
    end

    def render_layout(layout)
      (fig, axes) = *@plot.subplots(nrows: layout.num_rows, ncols: layout.num_cols)
      layout.rows.each_with_index do |row, y|
        row.each_with_index do |cel, x|
          plot = layout.num_rows > 1 ? axes[y][x] : axes[x]
          plot(plot, cel)
        end
      end
      @plot.show
    end

    def render(context)
      plot(@plot, context)
    end

    def plot(plot, context)
      case context.method
      when :curve
      when :scatter
        g = plot::Scatter.new(800)
        # TODO: set label value
        # g.data(:label, context.series.xs.to_a, context.series.ys.to_a)
        g.data("", context.series.xs.to_a, context.series.ys.to_a)
        # TODO: use another data structure instead of series.
        # g.data(:apples, [1,2,3,4], [4,3,2,1])
        # g.data('oranges', [5,7,8], [4,1,7])
        g.write('sample_image/gruff_scatter.png')
        
      when :errorbar
      when :hist
      end
    end
  end
end
