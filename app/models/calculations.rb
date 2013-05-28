class Calculations

  attr_reader :start_on, :end_on

  def initialize(start_on, end_on)
    @start_on = start_on
    @end_on = end_on
  end

  def total_work_days
    @total_work_days ||= work_days_between(start_on, end_on)
  end

  def work_days
    @work_days ||= work_days_between(start_on, Date.today)
  end

  def member_participation_percent(rides)    
    (member_possible_rides == 0)? 0.0 : (100.0 * member_actual_rides(rides) / member_possible_rides).round(1)
  end

  def member_actual_rides(rides)
    # here be dragons
    dated_rides = competition_rides(rides).group_by(&:date)
    dated_rides.inject(0) do |total, (_, rides)|
      total + [2, rides.inject(0) {|total, r| total + (r.is_round_trip ? 2 : 1)}].min
    end
  end

  def member_ride_mileage(rides)
    competition_rides(rides).map(&:total_distance).sum
  end

  def team_participation_percent(business_size, rides)
    possible_rides = team_possible_rides(business_size)
    (possible_rides == 0)? 0.0 : (100.0 * team_actual_rides(rides) / possible_rides).round(1)
  end

  private
    def member_possible_rides
      2 * work_days
    end

    def team_possible_rides(business_size)
      2 * business_size * work_days
    end

    def team_actual_rides(rides)
      # here be dragons
      user_rides = competition_rides(rides).group_by(&:rider_id)
      user_rides.inject(0) do |total, (_, rides)|
        dated_rides = rides.group_by(&:date)
        total + dated_rides.inject(0) do |total, (_, rides)|
          total + [2, rides.inject(0) {|total, r| total + (r.is_round_trip ? 2 : 1)}].min
        end
      end
    end

    def work_days_between(date1, date2)
      (date1 <= date2 && date2 <= end_on) ? (date1..date2).select { |d| (1..5).include?(d.wday) }.size : 0
    end

    def competition_rides(rides)
      from_date = (Date.today <= end_on) ? Date.today : end_on
      (start_on <= Date.today) ? rides.where(:date => start_on..from_date, :work_trip => true).select { |r| (1..5).include?(r.date.wday) } : []
    end
end