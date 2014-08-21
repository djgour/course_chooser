module Semesterable
  
  extend ActiveSupport::Concern

  def get_season_from(semester)
    month = semester.month
    get_season_from_month_number(month)
  end
  
  def get_season_from_month_number(month)
    GlobalConstants::SEASONS_INVERTED.select{|key, value| key === month }.values.first
  end
  
  def get_year_from(semester)
    semester.year.to_s
  end
  
  def convert_semester_datetime_to_string(semester_datetime)
    return nil if semester_datetime.nil?
    season = get_season_from(semester_datetime).to_s.capitalize
    year = get_year_from(semester_datetime)
    "#{season} #{year}"
  end
  
  def upcoming_semester
    current_date = DateTime.now
    year = get_year_from current_date
    season = get_season_from current_date
    seasons = GlobalConstants::SEASONS.keys
    season_number = seasons.index(season)
    next_season_number = (season_number + 1) % seasons.count
    year += 1 if (next_season_number == 0)
    "#{seasons[next_season_number].to_s.capitalize} #{year.to_s}"
  end

end