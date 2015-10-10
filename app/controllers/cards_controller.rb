class CardsController < ApplicationController
  require 'jwt'
  require 'redis'
  require 'openssl'
  require 'base64'

  # Registra y tokeniza una tarjeta
  # Params:
  # - token(string)
  # - amount(float)
  # Resultado
  # - success(boolean)
  # - token(string)
  # - errors(array) opcional
  def create
    params = card_params

    if /^\d{3,4}$/.match(params[:cvv]).nil?
      render status: 500, json: {errors: ['CVV is required']}
      return
    end

    # Genero token de tarjeta
    now = Time.now.to_i
    text = now.to_s + '-' + params[:number]
    data = {:data => text, :exp => now + 600}
    params[:token] = JWT.encode data, nil, 'none'

    # Conexion a redis
    redis = Redis.new(:host => 'localhost', :port => 6379, password: 'conekta')
    cvv = params[:cvv]
    params.delete :cvv

    @card = Card.new(params)
    if @card.save
      #Encriptacion del cvv
      public_key = OpenSSL::PKey::RSA.new(File.read(Rails.root.join('public.pem')))
      encrypted_cvv = Base64.encode64(public_key.public_encrypt(cvv))
      redis.set(@card.token, encrypted_cvv)

      render status: 201, json:{success:true, token: @card.token}
    else
      render status: 500, json:{success: false, errors: @card.errors.full_messages.collect{|e| e}}
    end
  end

  private

  def card_params
    params.require(:card).permit(:number, :expiration, :cvv, :amount)
  end
end
