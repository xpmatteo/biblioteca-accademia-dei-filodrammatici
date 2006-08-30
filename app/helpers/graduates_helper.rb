module GraduatesHelper
  
  def format_birth_date(date)
    date.strftime('%d/%m/%Y')
  end
  
  def graduate_attribute(label, value, filter=nil)
    return nil if value.blank?
    value = yield(value) if block_given?
    value = apply_filter(value, filter)
    "<strong>#{label}</strong>#{value}<br/>"
  end
  
private

  def apply_filter(value, filter)
    return value unless filter
    value.send(filter)
  rescue
    self.send(filter, value)
  end
end
