# @file app/controllers/api/products_controller.rb
# @description API Controller for managing product resources, including retrieval and searching.
#              Supports pagination and query-based filtering.
# @version 1.0.0 - Initial implementation with index and show actions, added filtering and pagination support.
# @authors
#  - Athika Jishida

module Api
  module V1
    class ProductsController < ApplicationController


      def create
        @product = Product.find_or_initialize_by(url: product_params[:url])
        
        if @product.new_record?
          @product.status = :pending
          
          if @product.save
            ScrapeProductJob.perform_later(@product.id)
            render json: @product, status: :accepted
          else
            render json: { errors: @product.errors }, status: :unprocessable_entity
          end
        elsif @product.needs_update?
          ScrapeProductJob.perform_later(@product.id)
          render json: @product, status: :accepted
        else
          render json: @product
        end
      end

      # GET /api/v1/products
      # Returns a list of products, supports optional search filtering.
      def index
        @products = Product.all
      
        if params[:query].present?     # Apply search filter if query is provided
          search_term = "%#{params[:query].downcase}%"
          @products = @products.where("LOWER(title) LIKE ? OR LOWER(description) LIKE ?", search_term, search_term)
        end
      
        @products = @products.page(params[:page]).per(params[:per_page] || 20).order(created_at: :desc)
      
        render json: {
          products: @products,
          meta: {
            current_page: @products.current_page,
            total_pages: @products.total_pages,
            total_count: @products.total_count
          }
        }
      end
      
      

      # GET /api/v1/products/:id
      # Returns details of a specific product.
      def show
        @product = Product.find(params[:id])
        render json: @product
      end
      
      private
      def product_params
        params.require(:product).permit(:url)
      end
    end
  end
end