# 代码生成时间: 2025-10-19 21:51:45
# document_collaboration_service.rb
#
# A simple document collaboration service using Ruby and Hanami framework.
#

require 'hanami'

# Define a service for document collaboration
class DocumentCollaborationService
  # Initialize with a repository
  # @param repository [DocumentRepository] the repository to store and fetch documents
  def initialize(repository)
    @repository = repository
  end

  # Create a new document
  #
  # @param title [String] the title of the document
  # @param content [String] the initial content of the document
  # @return [Document] the created document
  def create_document(title, content)
    # Error handling for invalid input
    raise Hanami::Validation::Error, 'Title and content are required' if title.nil? || content.nil?

    document = Document.new(title: title, content: content)
    if document.valid?
      @repository.save(document)
      document
    else
      raise Hanami::Validation::Error, document.errors.full_messages.join(', ')
    end
  end

  # Update an existing document
  #
  # @param id [Integer] the ID of the document to update
  # @param content [String] the new content of the document
  # @return [Document] the updated document
  def update_document(id, content)
    document = @repository.find(id)
    raise 'Document not found' if document.nil?

    document.content = content
    if document.valid?
      @repository.save(document)
      document
    else
      raise Hanami::Validation::Error, document.errors.full_messages.join(', ')
    end
  end

  # Find a document by ID
  #
  # @param id [Integer] the ID of the document to find
  # @return [Document] the found document or nil if not found
  def find_document(id)
    @repository.find(id)
  end
end

# Define a repository for document storage
class DocumentRepository
  # Simulate a database with an in-memory hash
  @@documents = {}
  @@next_id = 1

  def self.next_id
    @@next_id
  end

  # Save a document to the repository
  #
  # @param document [Document] the document to save
  # @return [Integer] the ID of the saved document
  def save(document)
    @@documents[self.class.next_id] = document
    id = self.class.next_id
    self.class.next_id += 1
    id
  end

  # Find a document by ID
  #
  # @param id [Integer] the ID of the document to find
  # @return [Document] the found document or nil if not found
  def find(id)
    @@documents[id]
  end
end

# Define a document entity
class Document
  include Hanami::Entity

  # @!attribute [r] id
  #   @return [Integer] the ID of the document
  attribute :id
  # @!attribute [rw] title
  #   @return [String] the title of the document
  attribute :title, String
  # @!attribute [rw] content
  #   @return [String] the content of the document
  attribute :content, String
end
