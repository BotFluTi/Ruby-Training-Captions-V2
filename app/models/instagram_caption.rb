# frozen_string_literal: true

class InstagramCaption < ApplicationRecord
  self.inheritance_column = nil

  TYPES = %w[image color gradient].freeze
  HEX_COLOR = /\A#[0-9a-fA-F]{6}\z/
  FILTERS = %w[blackwhite light_blur hard_blur].freeze

  validates :type,
            presence: { message: "is blank" },
            inclusion: { in: TYPES }

  validates :text,
            presence: { message: "is blank" },
            length: { maximum: 266 }

  validates :filter,
            inclusion: { in: FILTERS },
            allow_nil: true

  validates :filter,
            absence: {
              message: "is only allowed for image captions"
            },
            unless: :image?

  validates :url,
            presence: { message: "is blank" },
            if: :image?

  validates :color,
            presence: { message: "is blank" },
            format: {
              with: HEX_COLOR,
              message: "must be a valid HEX color"
            },
            if: :color?

  validates :start_color,
            presence: { message: "is blank" },
            format: {
              with: HEX_COLOR,
              message: "must be a valid HEX color"
            },
            if: :gradient?

  validates :end_color,
            presence: { message: "is blank" },
            format: {
              with: HEX_COLOR,
              message: "must be a valid HEX color"
            },
            if: :gradient?

  private

  def image?
    type == "image"
  end

  def color?
    type == "color"
  end

  def gradient?
    type == "gradient"
  end
end
