# frozen_string_literal: true

class PlayerPerMatchesController < ApplicationController
  before_action :set_player_per_match, only: %i[show update destroy]
  wrap_parameters :player_per_match, include: [:player_id, :match_id, :position, :status, :player_number, :player_name]

  # GET /player_per_matches
  def index
    @player_per_matches = PlayerPerMatch.all

    render json: @player_per_matches
  end

  # GET /player_per_matches/1
  def show
    render json: @player_per_match
  end

  # POST /player_per_matches
  def create
    already_confirmed = PlayerPerMatch.joins(:player).find_by(player: {number: params[:player_number]}, match_id: Match.open.last&.id).present?

    if already_confirmed
      render plain: "Você já está inscrito"
    else
      @player_per_match = PlayerPerMatch.new(player_per_match_params)
      if @player_per_match.save
        render plain: @player_per_match.match.print_list_of_players 
      else
        render json: @player_per_match.errors, status: :unprocessable_entity
      end
    end

  end

  # PATCH/PUT /player_per_matches/1
  def update
    if @player_per_match.update(player_per_match_params)
      render json: @player_per_match
    else
      render json: @player_per_match.errors, status: :unprocessable_entity
    end
  end

  # DELETE /player_per_matches/1
  def destroy
    @player_per_match.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_player_per_match
    @player_per_match = PlayerPerMatch.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def player_per_match_params
    params.require(:player_per_match).permit(:player_id, :match_id, :position,
                                             :status, :player_number, :player_name)
  end
end
