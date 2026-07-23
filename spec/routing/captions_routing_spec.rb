# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Caption routes", type: :routing do
  it "routes GET /captions to index" do
    expect(get: "/captions")
      .to route_to(controller: "captions", action: "index")
  end

  it "routes GET /captions/:id to show" do
    expect(get: "/captions/1")
      .to route_to(controller: "captions", action: "show", id: "1")
  end

  it "routes POST /captions to create" do
    expect(post: "/captions")
      .to route_to(controller: "captions", action: "create")
  end

  it "routes DELETE /captions/:id to destroy" do
    expect(delete: "/captions/1")
      .to route_to(controller: "captions", action: "destroy", id: "1")
  end
end
