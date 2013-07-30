desc "Scrape Properties"
task scrape_properties: :environment do
  job = ScrapeJob.new
  job.run
  Property.geocode_all
end