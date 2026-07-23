# frozen_string_literal: true

class InstagramCaptionInputJsonParser
  class Contract < Dry::Validation::Contract
    params do
      required(:image).hash do
        required(:type).value(:string)
        required(:text).value(:string)

        optional(:url).value(:string)
        optional(:filter).value(:string)
        optional(:color).value(:string)
        optional(:start_color).value(:string)
        optional(:end_color).value(:string)
      end
    end
  end

  def parse(body)
    result = Contract.new.call(body)

    raise ValidationError.new(missing_parameter_error(result)) if result.failure?

    result.to_h[:image]
  end

  private

  def missing_parameter_error(result)
    parameter = result.errors.first.path.last

    {
      code: "missing_parameters",
      title: "Parameter is missing from the request body",
      description: "#{parameter} parameter is missing from the request body. " \
        "It is a required parameter and the request cannot be processed."
    }
  end
end
