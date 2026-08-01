# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Instagram caption routes", type: :routing do
  it "routes POST /captions/instagram to create" do
    expect(post: "/captions/instagram")
      .to route_to(
            controller: "instagram_captions",
            action: "create"
          )
  end

  it "routes GET /captions/instagrams to index" do
    expect(get: "/captions/instagrams")
      .to route_to(
            controller: "instagram_captions",
            action: "index"
          )
  end
end
