class Days
  def self.firstDay(inpDay)
    #inpDay is a day of a month
    if inpDay.is_a? String
      day = DateTime.parse inpDay
    else
      day = inpDay
    end
    #returning tha first day
    day.change({:day=>1}).beginning_of_day
  end
  def self.lastDay(inpDay)
    #inpDay is a day of a month
    if inpDay.is_a? String
      day = DateTime.parse inpDay
    else
      day = inpDay
    end
    #returning tha last day
    day.at_end_of_month.end_of_day
  end
  def self.inMonth?(eventDay,currentDay)
    #the day must be between first and last days
    if eventDay.is_a? String
      day = DateTime.parse eventDay
    else
      day = eventDay
    end
    if currentDay.is_a? String
      currDay = DateTime.parse currentDay
    else
      currDay = currentDay
    end
    firstDay(currDay) <= day && lastDay(currDay) >= day
  end
end