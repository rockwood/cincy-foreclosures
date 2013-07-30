require "spec_helper"

describe ScrapeJob, :vcr do
  describe "#submit_disclaimer_form" do
    it "results in the list page" do
      list_page = subject.submit_disclaimer_form
      list_page.uri.to_s.should == "http://www.hcso.org/PublicServices/ExecutionSales/ExecPropertySales.aspx"
    end
  end
  describe "#run" do
    it "creates property models" do
      subject.run
      Property.count.should == 382
    end
    it "doesn't create duplicate properties" do
      subject.run
      subject.run
      Property.count.should == 382
    end
  end
end