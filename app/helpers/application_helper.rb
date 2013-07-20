module ApplicationHelper
  def list_error_messagses(f, field)
    if f.object.errors.messages[field].count == 0
      return ''
    else
      str = '<ul>'
      f.object.errors.messages[field].each do |errmsg|
        str += '<li>' + errmsg.to_s + '</li>\n'
      end
      str += '</ul>'
      return str
    end
  end
  def field_is_unquie?(object, field, value)
    if object.where("? = ?", field, value).count == 0
      return true
    end
    return false
  end
end
