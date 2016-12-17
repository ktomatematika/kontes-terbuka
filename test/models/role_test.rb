require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  test 'role to string' do
    assert_equal Role.create(name: 'coba_aja').to_s, 'Coba Aja',
                 'Referrer to string is not equal to its name title+humanized.'
  end
end
