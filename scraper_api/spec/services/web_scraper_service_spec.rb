# @file spec/services/web_scraper_service_spec.rb
# @description Tests for WebScraperService, ensuring correct extraction of product details from a webpage.
# @version 1.0.0 - Initial tests for successful and fixed failed scraping scenarios, including new fields like `currency` and `image_url`.
# @authors
#  - Athika Jishida

require 'rails_helper'

RSpec.describe WebScraperService, type: :service do
  let(:url) { "https://www.flipkart.com/sample-product" }
  let(:service) { described_class.new(url) }
  let(:fake_html) do
    <<-HTML
      <html>
        <body>
          <div class="B_NuCI">Sample Flipkart Product</div>
          <div class="_30jeq3 _16Jk6d">₹1,234</div>
          <div class="_1mXcCf RmoJUa">Sample description</div>
          <div class="G6XhRU">Sample Brand</div>
          <div class="_14cfVK">
            <div class="_1hKmbr">Key</div>
            <div class="URwL2w">Value</div>
          </div>
        </body>
      </html>
    HTML
  end

  before do
    # Stub the HTTParty.get call to return fake HTML
    fake_response = double("response", body: fake_html)
    allow(HTTParty).to receive(:get).with(url).and_return(fake_response)
  end

  context "when scraping Flipkart" do
    it "returns a hash with product details" do
      result = service.scrape

      expect(result).to be_a(Hash)
      expect(result[:title]).to eq("Sample Flipkart Product")
      # The price is extracted by removing non-digits so expect a float
      expect(result[:price]).to eq(1234.0)
      expect(result[:description]).to eq("Sample description")
      expect(result[:brand]).to eq("Sample Brand")
      expect(result[:website]).to eq("www.flipkart.com")
      expect(result[:additional_info]).to eq({ "Key" => "Value" })
    end
  end

  context "when scraping fails" do
    before do
      allow(HTTParty).to receive(:get).with(url).and_raise(StandardError.new("Network error"))
    end

    it "raises a ScrapingError" do
      expect { service.scrape }.to raise_error(WebScraperService::ScrapingError, /Network error/)
    end
  end
end
