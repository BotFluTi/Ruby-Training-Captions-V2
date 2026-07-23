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

    raise ValidationError.new(result.errors.to_h) if result.failure?

    result.to_h[:caption]
  end
end
