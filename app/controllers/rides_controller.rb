class RidesController < ApplicationController
  load_and_authorize_resource

  def index
    @ride = Ride.new
    @ride.is_round_trip = true
  end

  def new
    @ride = Ride.new
    @ride.is_round_trip = true
  end

  def create
    if @ride.save
      redirect_to dashboard_path
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @ride.update_attributes(params[:ride])
      flash[:success] = t("ride.edit.success")
      redirect_to @ride
    else
      render :edit
    end
  end

  def delete
  end

  def destroy
    @ride.destroy
    flash[:success] = t("ride.delete.success")
    redirect_to rides_url
  end
end