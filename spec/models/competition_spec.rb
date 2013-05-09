require 'spec_helper'

describe Competition do
  context "validation" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :description }
    it { should validate_presence_of :owner }
    it { should validate_presence_of :start_on }
    it { should validate_presence_of :end_on }

    it "should require end date be greater than start date" do
      competition = FactoryGirl.build :competition,
        start_on: 2.weeks.from_now,
        end_on: 1.day.from_now
      competition.should_not be_valid
      competition.should have(1).error_on(:end_on)

      competition.end_on = 1.month.from_now
      competition.should be_valid
    end

    it "should require start date be in the future" do
      competition = FactoryGirl.build :competition,
        start_on: 1.month.ago
      competition.should_not be_valid
      competition.should have(1).error_on(:start_on)

      competition.start_on = Time.now
      competition.should be_valid
    end
  end

  it "should find competitions team has not joined" do
    team = FactoryGirl.create :team
    competition = FactoryGirl.create :competition
    joined = FactoryGirl.create :competition
    joined.competitors.create(team_id: team.id)
    competitions = Competition.joinable_by_team(team)
    competitions.should include competition
    competitions.should_not include joined
  end
end
