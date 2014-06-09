class DashboardController < ApplicationController
  authorize_resource :class => false

  def index
    @rides = current_user.rides.latest.first(16)
    @ride = build_ride
    @personal_mileage = current_user.rides.total_distance

    if @membership = current_user.active_membership
      @team = @membership.team
      calculator = ParticipationCalculator.new(@team.competition)
      @membership_participation = calculator.membership_participation(@membership)
      @team_participation = calculator.team_participation(@team)
    end
  end

  private

  def build_ride
    last_ride = current_user.rides.latest.work_trips.first
    if last_ride.present?
      attrs = last_ride.attributes.slice(*copyable_ride_attrs)
    else
      attrs = {}
    end
    Ride.new(default_ride_attrs.merge(attrs).symbolize_keys)
  end

  def copyable_ride_attrs
    %w{bike_distance bus_distance walk_distance description type work_trip}
  end

  def default_ride_attrs
    { date: Calendar.today, type: :round_trip, work_trip: true }
  end
end
