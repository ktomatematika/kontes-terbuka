# frozen_string_literal: true

class String
  def get(binding)
    binding.eval "\"#{self}\""
  end
end

Social = JSON.parse(File.read(Rails.root.join('app/assets/social.json')),
                    object_class: OpenStruct)
