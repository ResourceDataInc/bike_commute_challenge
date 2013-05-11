class TeamsController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def new
  end

  def create
    @team.memberships.build(user: current_user, approved: true)

    if @team.save
      join_first_competition(@team)
      flash[:success] = t("team.add.success") 
      redirect_to @team
    else
      render :new
    end
  end

  def show
    @membership = Membership.new
  end

  def edit
  end

  def update
    if @team.update_attributes(params[:team])
      flash[:success] = t("team.edit.success") 
      redirect_to @team
    else
      render :edit
    end
  end

  def delete
  end

  def destroy
    @team.destroy
    flash[:success] = t("team.delete.success") 
    redirect_to root_url
  end

  private

  def join_first_competition(team)
    competition = Competition.first
    unless competition.nil?
      competition.competitors.create(team_id: team.id, approved: true)
    end
  end
end
