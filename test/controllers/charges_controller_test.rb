require 'test_helper'

class ChargesControllerTest < ActionController::TestCase
  setup do
    @charge = Charge.new({token: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJub25lIn0.eyJkYXRhIjoiMTQ0NDQzMDAyOS00MzAwMTc0MDQyMjUwNzQ4IiwiZXhwIjoxNDQ0NDMwNjI5fQ.', amount: 999, status: 'success'})
  end

  test "Debe aplicar un cargo" do
    post :create, charge: {token: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJub25lIn0.eyJkYXRhIjoiMTQ0NDQzMDAyOS00MzAwMTc0MDQyMjUwNzQ4IiwiZXhwIjoxNDQ0NDMwNjI5fQ.', amount: 999}
    puts "RESPUESTA:::::::::: #{@response.body}"
    assert_response 200
  end
end
  