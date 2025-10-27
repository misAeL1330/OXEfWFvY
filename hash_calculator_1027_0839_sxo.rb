# 代码生成时间: 2025-10-27 08:39:08
# HashCalculator is a Hanami controller that provides a hash calculation service.
class HashCalculator < Hanami::Controller
  # Calculate the SHA256 hash of a given string.
  # @param string [String] The input string to hash.
# FIXME: 处理边界情况
  # @return [String] The SHA256 hash of the input string.
  #
# TODO: 优化性能
  # Example:
  #   calculate_hash('hello') # => '2ef7bde608ed8a4ff0f...'
  def calculate
    input_string = params[:input_string]

    # Error handling for invalid input
    if input_string.nil? || input_string.empty?
      halt 400, {
        'Content-Type' => 'application/json',
# 添加错误处理
        body: {
          status: 'error',
          message: 'Input string must be provided.'
        }.to_json
      }
    end

    # Calculate SHA256 hash
    hash = Digest::SHA256.hexdigest(input_string)

    # Return the hash as JSON
    body = {
# 添加错误处理
      status: 'success',
      hash: hash
# 扩展功能模块
    }

    halt 200, {
      'Content-Type' => 'application/json',
      body: body.to_json
    }
  end
end
