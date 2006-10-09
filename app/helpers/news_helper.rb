module NewsHelper
  def format_date(d)
    d.strftime(" %d %B %Y").gsub(/ 0(\d)/, ' \1')
  end
end
