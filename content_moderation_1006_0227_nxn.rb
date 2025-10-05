# 代码生成时间: 2025-10-06 02:27:22
# content_moderation.rb

require 'hanami'

# ContentModeration module that contains the moderation logic
module ContentModeration
  # Constants for moderation status
  STATUS_APPROVED = 'approved'
  STATUS_REJECTED = 'rejected'
  STATUS_PENDING = 'pending'

  # List of prohibited words for content moderation
  PROHIBITED_WORDS = ['badword1', 'badword2']

  # Check if the content contains any prohibited words
  # @param content [String] the content to be moderated
  # @return [Hash] a hash containing the status and reason of the moderation
  def self.moderate(content)
    status = STATUS_PENDING
    reason = ''

    if content.nil? || content.strip.empty?
      status = STATUS_REJECTED
      reason = 'Content is empty'
    else
      PROHIBITED_WORDS.each do |word|
        if content.include?(word)
          status = STATUS_REJECTED
          reason = 