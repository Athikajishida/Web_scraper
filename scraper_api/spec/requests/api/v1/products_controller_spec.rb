require 'rails_helper'

RSpec.describe "Api::V1::Products", type: :request do
  describe "GET /api/v1/products" do
    before do
      # Create a few products to list
      create_list(:product, 3)
    end

    it "returns a list of products with pagination metadata" do
      get "/api/v1/products", params: { per_page: 2 }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      
      # Check for presence of products and meta keys
      expect(json).to have_key("products")
      expect(json).to have_key("meta")
      expect(json["products"].size).to be <= 2
      expect(json["meta"]).to have_key("current_page")
      expect(json["meta"]).to have_key("total_pages")
      expect(json["meta"]).to have_key("total_count")
    end
  end

  describe "GET /api/v1/products/:id" do
    let(:product) { create(:product) }
    
    it "returns the requested product" do
      get "/api/v1/products/#{product.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["id"]).to eq(product.id)
    end
  end

  describe "POST /api/v1/products" do
    let(:valid_params) { { product: { url: "https://www.flipkart.com/sample-product" } } }
    
    context "when product is new" do
      it "creates a product and enqueues a scrape job" do
        expect {
          post "/api/v1/products", params: valid_params
        }.to have_enqueued_job(ScrapeProductJob)
        expect(response).to have_http_status(:accepted)
      end
    end

    context "when product exists and needs update" do
      let!(:existing_product) { create(:product, url: "https://www.flipkart.com/sample-product", last_scraped_at: 10.days.ago) }

      it "enqueues a scrape job for updating the product" do
        expect {
          post "/api/v1/products", params: valid_params
        }.to have_enqueued_job(ScrapeProductJob)
        expect(response).to have_http_status(:accepted)
      end
    end

    context "when product exists and does not need update" do
      let!(:existing_product) { create(:product, url: "https://www.flipkart.com/sample-product", last_scraped_at: Time.current) }

      it "returns the existing product without enqueuing a job" do
        expect {
          post "/api/v1/products", params: valid_params
        }.not_to have_enqueued_job(ScrapeProductJob)
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
