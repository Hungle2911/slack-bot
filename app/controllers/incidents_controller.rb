class IncidentsController < ApplicationController
  def index
    @incidents = Incident.all.order(sort_column + " " + sort_direction)
  end

  def show
    @incident = Incident.find(params[:id])
  end

  private

  def sort_column
    %w[title severity status created_at resolved_at creator_name].include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
  helper_method :sort_column, :sort_direction
end
