require 'rails_helper'

RSpec.describe ScrapeProductJob, type: :job do
  include ActiveJob::TestHelper

  let(:product) { create(:product, url: "https://www.flipkart.com/sample-product") }
  let(:fake_data) do
    {
      title: "Sample Product",
      price: 99.99,
      description: "Sample description",
      brand: "Sample Brand",
      website: "www.flipkart.com",
      additional_info: {}
    }
  end

  before do
    # Stub the service call to avoid making real HTTP requests.
    scraper = instance_double(WebScraperService, scrape: fake_data)
    allow(WebScraperService).to receive(:new).with(product.url).and_return(scraper)
  end

  it "updates the product with scraped data on success" do
    perform_enqueued_jobs do
      ScrapeProductJob.perform_later(product.id)
    end

    product.reload
    expect(product.status).to eq("completed")
    expect(product.title).to eq("Sample Product")
    expect(product.last_scraped_at).not_to be_nil
  end

  it "updates the product with failed status if an error occurs" do
    # Simulate an error in the scraper
    scraper = instance_double(WebScraperService)
    allow(WebScraperService).to receive(:new).with(product.url).and_return(scraper)
    allow(scraper).to receive(:scrape).and_raise(StandardError.new("Test error"))

    error = nil
    begin
      # Call perform directly instead of enqueuing the job.
      ScrapeProductJob.new.perform(product.id)
    rescue StandardError => e
      error = e
    end

    expect(error).not_to be_nil
    expect(error.message).to eq("Test error")

    product.reload
    expect(product.status).to eq("failed")
    expect(product.error_message).to eq("Test error")
  end
end
