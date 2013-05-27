class Event < ActiveRecord::Base
  attr_accessible :allDay, :end, :start, :title, :url
   scope :before, lambda {|end_time| {:conditions => ["end < ?", Event.format_date(end_time)] }}
  scope :after, lambda {|start_time| {:conditions => ["start > ?", Event.format_date(start_time)] }}
  

  def self.format_date(date_time)
    Time.at(date_time.to_i).to_formatted_s(:db)
  end

    def as_json(options = {})
    {
      :id => self.id,
      :title => self.title,
      #:description => self.description || "",
      :start => self.start.rfc822,
      :end => self.end.rfc822,
      :allDay => self.allDay,
      :recurring => false,
      :url => self.url
    }
    
  end
end
