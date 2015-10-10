require 'test_helper'

class CardsControllerTest < ActionController::TestCase
  setup do
    @card = Card.new({number: '4444333322221111', expiration: '10-20', token: 'ww', amount: 999})
  end
  
  test "Debe tokenizar una tarjeta" do
    post :create, card: {number: '4444333322221111', expiration: '10-20', cvv: 234, amount: 999}
    puts "RESPUESTA:::::::::: #{@response.body}"
    assert_response :success
  end

end
