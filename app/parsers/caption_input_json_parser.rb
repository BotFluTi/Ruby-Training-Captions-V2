# frozen_string_literal: true

class CaptionInputJsonParser
  class Contract < Dry::Validation::Contract
    params do
      required(:caption).hash do
        required(:url).value(:string)
        required(:text).value(:string)
      end
    end
  end

  def parse(body)
    result = Contract.new.call(body)

    raise ValidationError.new(missing_parameter_error(result)) if result.failure?

    result.to_h[:caption]
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
