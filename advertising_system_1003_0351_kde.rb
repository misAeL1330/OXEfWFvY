# 代码生成时间: 2025-10-03 03:51:26
#!/usr/bin/env ruby

# Gemfile
# gem 'hanami', '~> 2.0'

# advertising_system.rb

require 'hanami'

# Define the Ad model
class Ad
  include Hanami::Entity

  # Define the attributes of an Ad
  # @return [Integer] the unique identifier of the ad
  # @return [String] the title of the ad
  # @return [String] the content of the ad
  # @return [String] the url that the ad points to
  attributes :id, :title, :content, :url
end

# Define the AdRepository
class AdRepository
  include Hanami::Repository
  # Define the storage for the ads
  # @return [Array<Ad>] the list of ads
  attr_accessor :ads

  def initialize(*args)
    super
    @ads = []
  end

  # Find all ads
  # @return [Array<Ad>] all ads in the repository
  def all
    @ads
  end

  # Create a new ad
  # @param title [String] the title of the ad
  # @param content [String] the content of the ad
  # @param url [String] the url of the ad
  # @return [Ad] the newly created ad
  def create(title:, content:, url:)
    ad = Ad.new(id: SecureRandom.uuid, title: title, content: content, url: url)
    @ads.push ad
    ad
  end

  # Find an ad by its id
  # @param id [String] the unique identifier of the ad
  # @return [Ad, Nil] the ad with the given id or nil if not found
  def find(id)
    @ads.find { |ad| ad.id == id }
  end
end

# Define the AdService for business logic
class AdService
  attr_reader :repository

  def initialize(repository: AdRepository.new)
    @repository = repository
  end

  # Retrieve all ads
  # @return [Array<Ad>] all ads
  def all_ads
    repository.all
  end

  # Create a new ad
  # @param title [String] the title of the ad
  # @param content [String] the content of the ad
  # @param url [String] the url of the ad
  # @return [Ad] the newly created ad
  def create_ad(title:, content:, url:)
    repository.create(title: title, content: content, url: url)
  end

  # Find an ad by its id
  # @param id [String] the unique identifier of the ad
  # @return [Ad, Nil] the ad with the given id or nil if not found
  def find_ad(id)
    repository.find(id)
  end
end

# Define the AdController
class AdController < Hanami::Action
  include Hanami::Action::Flash

  # Define the path for the ads index route
  # @return [String] the path for the ads index route
  def self.ad_index_path
    '/ads'
  end

  # Define the path for the ad creation route
  # @return [String] the path for the ad creation route
  def self.create_ad_path
    '/ads/new'
  end

  # Index action to display all ads
  # @return [void]
  get ad_index_path, as: :index do
    only &:index
    def index
      ads = ad_service.all_ads
      expose(ads)
    end
  end

  # Create action to handle ad creation
  # @return [void]
  post create_ad_path, as: :create do
    only &:create
    def create
      ad_service.create_ad(title: params[:title], content: params[:content], url: params[:url])
      flash[:success] = "Ad created successfully."
      redirect to: self.class.ad_index_path
    rescue StandardError => e
      flash.now[:error] = e.message
      render 'new'
    end
  end

  private
  # @return [AdService]
  def ad_service
    @ad_service ||= AdService.new(repository: AdRepository.new)
  end
end

# Start the Hanami application
Hanami::Container.run!