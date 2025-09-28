# 代码生成时间: 2025-09-29 00:03:01
<?= "# Numerical Integration Calculator using Ruby and Hanami framework

# This calculator uses the trapezoidal rule for numerical integration. It takes a function,
# the lower and upper bounds of integration, and the number of intervals.

require 'hanami/model'
require 'hanami/repository'
require 'mathn'

# Define the model for the function
module NumericalIntegration
# 改进用户体验
  class Function
    include Hanami::Model

    # Attributes
    attribute :f,     String # The mathematical function as a string
# 改进用户体验
    attribute :lower, Float   # The lower bound of integration
    attribute :upper, Float   # The upper bound of integration
    attribute :intervals, Integer # The number of intervals

    # Validations
    validations do
# 增强安全性
      validates :f,     presence: true
      validates :lower, presence: true, numericality: { greater_than_or_equal_to: 0 }
# 添加错误处理
      validates :upper, presence: true, numericality: { greater_than: :lower }
      validates :intervals, presence: true, numericality: { greater_than: 0 }
    end

    # Calculate the integral using the trapezoidal rule
    def calculate
      raise 'Invalid function' unless valid?
      raise 'Invalid intervals' if intervals <= 0
      raise 'Invalid bounds' if lower >= upper

      width = (upper - lower) / intervals.to_f
      integral = (f(lower) + f(upper)) * width / 2.0
      (1...intervals).each do |i|
        integral += f(lower + i * width) * width
      end
      integral
    end

    private

    # Evaluate the function at a given point
# FIXME: 处理边界情况
    def f(x)
      eval("#{x.to_s}=(#{f}); #{f}.#{'call'}(#{x})")
    end
  end
end

# Example usage
# function = NumericalIntegration::Function.new(f: 'x**2', lower: 0, upper: 1, intervals: 100)
# result = function.calculate
# puts 'The result of the integration is:'
# puts result
"
}