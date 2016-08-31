require 'test_helper'
require 'generators/province/province_generator'

class ProvinceGeneratorTest < Rails::Generators::TestCase
  tests ProvinceGenerator
  destination Rails.root.join('tmp/generators')
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
