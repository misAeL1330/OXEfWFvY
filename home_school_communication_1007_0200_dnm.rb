# 代码生成时间: 2025-10-07 02:00:22
# HomeSchoolCommunication.rb
#
# This Ruby program provides a simple home-school communication tool using the Hanami framework.

require 'hanami'
require_relative 'entities/message'
require_relative 'repositories/messages_repository'
require_relative 'services/message_service'
require_relative 'controllers/message_controller'

Hanami.app do
  # Define the application configuration here
  # For brevity, assume default configuration is used
end

# Entities
module Entities
  # Message entity
  class Message
    include Hanami::Entity
    attributes :id, :content, :timestamp, :sender, :receiver
  end
end

# Repositories
module Repositories
  # Messages repository
  class MessagesRepository
    include Hanami::Repository
    def self.message_service
      MessageService.new(self)
    end
  end
end

# Services
module Services
  # Message service
  class MessageService
    def initialize(repository)
      @repository = repository
    end
    
    # Send a message from sender to receiver
    def send(sender:, receiver:, content:)
      message = Entities::Message.new(id: nil, content: content, timestamp: Time.now, sender: sender, receiver: receiver)
      @repository.commands.create(message)
    rescue StandardError => e
      # Handle any errors that occur during message sending
      { success: false, message: e.message }
    end
    
    # Fetch messages for a given user
    def for_user(user:)
      @repository.queries.messages_for_user(user)
    rescue StandardError => e
      # Handle any errors that occur during message fetching
      { success: false, message: e.message }
    end
  end
end

# Controllers
module Controllers
  # Message controller
  class MessageController < Hanami::Controller
    include Hanami::Action::Partials
    include Hanami::Action::Flash

    # POST /messages
    # Send a message from sender to receiver
    def create
      result = Repositories::MessagesRepository.message_service.send(
        sender: params[:sender],
        receiver: params[:receiver],
        content: params[:content]
      )
      if result[:success]
        flash[:success] = 'Message sent successfully!'
      else
        flash[:error] = result[:message]
      end
      redirect_to '/messages'
    end
    
    # GET /messages/:id
    # Fetch messages for a given user
    def index
      user = params[:id]
      messages = Repositories::MessagesRepository.message_service.for_user(user: user)
      partials.messages(messages: messages)
    end
  end
end
