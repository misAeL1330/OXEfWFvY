# 代码生成时间: 2025-09-23 19:35:16
# shopping_cart.rb
# This file defines a ShoppingCart class to manage a shopping cart's behavior.

require 'hanami/model'
require 'hanami/model/mapper_registry'

# Define a model for the Product
class Product
  include Hanami::Entity
end

# Define a model for the CartItem
class CartItem
  include Hanami::Entity
end

# Define a mapper for the Product
class ProductMapper < Hanami::Model::Mapper::Base
  attribute :id, Integer
  attribute :name, String
  attribute :price, BigDecimal
end

# Define a mapper for the CartItem
class CartItemMapper < Hanami::Model::Mapper::Base
  attribute :cart_id, Integer
  attribute :product_id, Integer
  attribute :quantity, Integer, default: 1
end

# Define the ShoppingCart class
class ShoppingCart
  # Initialize a new shopping cart with an empty list of items
  def initialize
    @items = []
  end

  # Add a product to the shopping cart
  def add_product(product_id)
    product = ProductRepository.new.find(product_id)
    raise 'Product not found' unless product
    @items << CartItem.new(product_id: product.id, quantity: 1)
  end

  # Remove a product from the shopping cart by product id
  def remove_product(product_id)
    @items.reject! { |item| item.product_id == product_id }
  end

  # Update the quantity of a product in the shopping cart
  def update_quantity(product_id, quantity)
    item = @items.find { |item| item.product_id == product_id }
    raise 'Product not found' unless item
    item.quantity = quantity
  end

  # Get the total cost of all items in the shopping cart
  def total_cost
    total = BigDecimal('0.0')
    @items.each do |item|
      product = ProductRepository.new.find(item.product_id)
      total += (product.price * item.quantity)
    end
    total
  end
end

# Define the ProductRepository class
class ProductRepository
  # Find a product by id
  def find(id)
    # This method should interact with the database to retrieve the product
    # For simplicity, we're just returning a dummy product entity
    Product.new(id: id, name: 'Product', price: BigDecimal('10.0'))
  end
end

# Example usage of ShoppingCart
if __FILE__ == $0
  cart = ShoppingCart.new
  begin
    cart.add_product(1)
    cart.add_product(2)
    puts "Total cost: \#{cart.total_cost}"
    cart.update_quantity(2, 2)
    puts "Total cost after update: \#{cart.total_cost}"
    cart.remove_product(1)
    puts "Total cost after removal: \#{cart.total_cost}"
  rescue => e
    puts "Error: \#{e.message}"
  end
end