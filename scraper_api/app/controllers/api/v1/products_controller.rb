# app/controllers/api/v1/products_controller.rb
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
      
      def index
        @products = Product.page(params[:page])
                          .per(params[:per_page] || 20)
                          .order(created_at: :desc)
        
        render json: {
          products: @products,
          meta: {
            current_page: @products.current_page,
            total_pages: @products.total_pages,
            total_count: @products.total_count
          }
        }
      end
      
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