require 'iruby'
require 'rubyplot'

module Charty
  class Rubyplot
    def initialize
      @plot = ::Rubyplot
    end

    def label(x, y)
    end

    def series=(series)
      @series = series
    end

    # TODO:
    # def render_layout(layout)
    #   (fig, axes) = *@plot.subplots(nrows: layout.num_rows, ncols: layout.num_cols)
    #   layout.rows.each_with_index do |row, y|
    #     row.each_with_index do |cel, x|
    #       plot = layout.num_rows > 1 ? axes[y][x] : axes[x]
    #       plot(plot, cel)
    #     end
    #   end
    #   @plot.show
    # end

    def render(context)
      plot(@plot, context)
    end

    def plot(plot, context)
      case context.method
      when :curve
      when :scatter
        figure = ::Rubyplot::Figure.new
        axes = figure.add_subplot 0,0
        axes.scatter! do |p|
          p.data context.series.xs.to_a, context.series.ys.to_a
          # p.label = "data1"
          # p.color = :plum_purple
        end
        # axes.title = "Nice plot"
        # axes.x_title = "X data"
        # axes.y_title = "Y data"
        figure.write('sample_image/rubyplot_scatter.png')
      when :errorbar
        # TODO:
      when :hist
        # TODO:
      end
    end
  end
end
