# frozen_string_literal: true

class Caption < ApplicationRecord
  validates :url, presence: { message: "is blank" }

  validates :text,
            presence: { message: "is blank" },
            length: { maximum: 266 }
end
