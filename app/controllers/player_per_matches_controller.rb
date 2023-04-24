class PlayerPerMatchesController < ApplicationController
  before_action :set_player_per_match, only: %i[ show update destroy ]

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
    @player_per_match = PlayerPerMatch.new(player_per_match_params)

    if @player_per_match.save
      render json: @player_per_match, status: :created, location: @player_per_match
    else
      render json: @player_per_match.errors, status: :unprocessable_entity
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
      params.require(:player_per_match).permit(:player_id, :match_id, :position, :status)
    end
end
