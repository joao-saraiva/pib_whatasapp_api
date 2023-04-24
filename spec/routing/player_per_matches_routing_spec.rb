require "rails_helper"

RSpec.describe PlayerPerMatchesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/player_per_matches").to route_to("player_per_matches#index")
    end

    it "routes to #show" do
      expect(get: "/player_per_matches/1").to route_to("player_per_matches#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/player_per_matches").to route_to("player_per_matches#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/player_per_matches/1").to route_to("player_per_matches#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/player_per_matches/1").to route_to("player_per_matches#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/player_per_matches/1").to route_to("player_per_matches#destroy", id: "1")
    end
  end
end
