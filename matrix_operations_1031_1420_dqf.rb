# 代码生成时间: 2025-10-31 14:20:30
# matrix_operations.rb
#
# This is a simple matrix operations library in Ruby that demonstrates
# how to structure code for clarity, add error handling,
# and follow best practices in Ruby programming.
#
# The library provides basic operations such as addition,
# subtraction, multiplication, and determinant calculation.

require 'hanami'

module MatrixOperations
  # Ensures that the provided arrays are valid matrices.
  #
  # @param matrices [Array<Array<Integer>>] The matrices to be compared.
  # @raise [ArgumentError] If the matrices are not of the same dimensions.
  def self.validate_matrices(*matrices)
    return if matrices.size <= 1
    size = matrices.first.size
    matrices.each do |matrix|
      raise ArgumentError, 'All matrices must have the same dimensions' unless matrix.size == size
      matrix.each do |row|
        raise ArgumentError, 'Each row must have the same number of elements' unless row.size == size
      end
    end
  end

  # Adds two matrices together.
  #
  # @param matrix_a [Array<Array<Integer>>] The first matrix.
  # @param matrix_b [Array<Array<Integer>>] The second matrix.
  # @return [Array<Array<Integer>>] The sum of the two matrices.
  def self.add(matrix_a, matrix_b)
    validate_matrices(matrix_a, matrix_b)
    result = []
    matrix_a.size.times do |i|
      row = []
      matrix_a[i].size.times do |j|
        row << matrix_a[i][j] + matrix_b[i][j]
      end
      result << row
    end
    result
  end

  # Subtracts one matrix from another.
  #
  # @param matrix_a [Array<Array<Integer>>] The first matrix.
  # @param matrix_b [Array<Array<Integer>>] The second matrix.
  # @return [Array<Array<Integer>>] The difference of the two matrices.
  def self.subtract(matrix_a, matrix_b)
    validate_matrices(matrix_a, matrix_b)
    result = []
    matrix_a.size.times do |i|
      row = []
      matrix_a[i].size.times do |j|
        row << matrix_a[i][j] - matrix_b[i][j]
      end
      result << row
    end
    result
  end

  # Multiplies two matrices together.
  #
  # @param matrix_a [Array<Array<Integer>>] The first matrix.
  # @param matrix_b [Array<Array<Integer>>] The second matrix.
  # @return [Array<Array<Integer>>] The product of the two matrices.
  def self.multiply(matrix_a, matrix_b)
    validate_matrices(matrix_a) # Validate the first matrix only for multiplication
    return nil unless matrix_a[0].size == matrix_b.size
    result = Array.new(matrix_a.size) { Array.new(matrix_b[0].size, 0) }
    matrix_a.size.times do |i|
      matrix_b[0].size.times do |j|
        matrix_a[i].size.times do |k|
          result[i][j] += matrix_a[i][k] * matrix_b[k][j]
        end
      end
    end
    result
  end

  # Calculates the determinant of a matrix.
  #
  # @param matrix [Array<Array<Integer>>] The matrix to calculate the determinant for.
  # @return [Integer] The determinant of the matrix.
  def self.determinant(matrix)
    raise ArgumentError, 'Matrix must be square' unless matrix.size == matrix[0].size
    case matrix.size
    when 1
      matrix[0][0]
    when 2
      matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0]
    else
      result = 0
      matrix[0].size.times do |i|
        minor = matrix.dup
        minor.shift
        minor[i] = []
        result += (-1) ** i * matrix[0][i] * determinant(minor)
      end
      result
    end
  end
end
