class ScrapeJob

  DISCLAIMER_URL = "http://www.hcso.org/PublicServices/ExecutionSales/ExecPropertySalesDisclaimer.aspx"
  LIST_URL = "http://www.hcso.org/PublicServices/ExecutionSales/ExecPropertySales.aspx"

  def initialize
    @agent = Mechanize.new
  end

  def run
    list_page = submit_disclaimer_form

    list_page.search("#DataGrid1 tr").each do |row|
      if(attrs = parse_row(row))
        if (property = Property.where(address: attrs['address']).first)
          property.update_atrributes(attrs)
        else
          property = Property.new(attrs)
        end
        property.save
      end
    end
  end

  def submit_disclaimer_form
    disclaimer_page = @agent.get(DISCLAIMER_URL)
    disclaimer_form = disclaimer_page.form("Form1")
    disclaimer_form.__EVENTTARGET = "lnkAgree"
    @agent.submit(disclaimer_form)
  end

  def is_header_row?(row)
    row.attributes["nowrap"].present?
  end

  def parse_row(row)
    return false if is_header_row?(row)
    cells = row.search('td')
    {
      case_number:    cells[0].text,
      plaintiff:      cells[1].text,
      owner:          cells[2].text,
      address:        cells[3].text,
      township:       cells[4].text,
      attorney:       cells[5].text,
      attorney_phone: cells[6].text,
      appraisal:      cells[7].text,
      minimum_bid:    cells[8].text,
      sale_date:      Date.strptime(cells[9].text, '%m/%d/%Y'),
      withdrawn:      cells[10].search("input").first.attributes["checked"].present?,
      city:           "Cincinnati",
      state:          "OH",
    }
  end
end