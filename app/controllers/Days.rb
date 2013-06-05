class Days
  def self.firstDay(inpDay)
    #inpDay is a day of a month
    day = DateTime.parse(inpDay)
    #returning tha first day
    day.change({:day=>1}).beginning_of_day
  end
  def self.lastDay(inpDay)
    #inpDay is a day of a month
    day = DateTime.parse(inpDay)
    #returning tha last day
    day.at_end_of_month.end_of_day
  end
  def self.inMonth?(eventDay,currentDay)
    #the day must be between first and last days
    firstDay(currentDay) <= DateTime.parse(eventDay) && lastDay(currentDay) >= DateTime.parse(eventDay)
  end
end