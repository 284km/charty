module Charty
  class Main
    def initialize(frontend)
      @frontend = frontend
    end

    def curve(**args, &block)
      context = RenderContext.new :curve, **args, &block
      context.apply(@frontend)
    end

    def scatter(**args, &block)
      context = RenderContext.new :scatter, **args, &block
      context.apply(@frontend)
    end

    def errorbar(**args, &block)
      context = RenderContext.new :errorbar, **args, &block
      context.apply(@frontend)
    end

    def hist(**args, &block)
      context = RenderContext.new :hist, **args, &block
      context.apply(@frontend)
    end

    def layout(definition=:horizontal)
      Layout.new(@frontend, definition)
    end
  end

  Series = Struct.new(:xs, :ys)

  class RenderContext
    attr_reader :function, :range, :series, :method, :data, :xerr, :yerr

    def initialize(method, **args, &block)
      @method = method
      configurator = Configurator.new(**args)
      configurator.instance_eval &block
      (@range, @series, @function, @data, @xerr, @yerr) = configurator.to_a
    end

    class Configurator
      def initialize(**args)
        @args = args
      end

      def function(&block)
        @function = block
      end

      def data(data)
        @data = data
      end

      def xerr(xerr)
        @xerr = xerr
      end

      def yerr(yerr)
        @yerr = yerr
      end

      def series(xs, ys)
        @series = Series.new(xs, ys)
      end

      def range(range)
        @range = range
      end

      def to_a
        [@range, @series, @function, @data, @xerr, @yerr]
      end

      def method_missing(method, *args)
        if (@args.has_key?(method))
          @args[name]
        else
          super
        end
      end
    end

    def range_x
      @range[:x]
    end

    def range_y
      @range[:y]
    end

    def render
      @frontend.render(self)
    end

    def apply(frontend)
      case
        when @series
          frontend.series = @series
        when @function
          linspace = Linspace.new(@range[:x], 100)
          @series = Series.new(linspace.to_a, linspace.map{|x| @function.call(x) })
      end

      @frontend = frontend
      self
    end
  end
end
