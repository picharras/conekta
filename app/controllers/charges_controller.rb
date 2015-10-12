class ChargesController < ApplicationController
  require 'jwt'
  require 'openssl'
  require 'base64'

  # Procesa un cargo a partir de un token
  # Params
  # - token(string)
  # - amount(float)
  # Result
  # - success(boolean)
  # - transaction_id(integer)
  # - errors(array) optional
  def create
    params = charge_params

    @card = Card.where(:token => params[:token]).limit(1).first

    if @card.nil?
      render status: 500, json: {errors: ['Token not found']}
      return
    elsif @card.amount != params[:amount].to_f
      render status: 500, json: {errors: ['Amounts do not match']}
      return
    end

    # Valida si no ha expirado el token
    begin
      token = JWT.decode @card.token, nil, false
    rescue JWT::ExpiredSignature
      render status: 500, json:{success: false, errors:['El token ha expirado']}
      return
    end

    # Conexion a redis
    redis = Redis.new(:host => 'localhost', :port => 6379, :db => 0, password: 'conekta')
    encrypted_cvv = redis.get(@card.token)
    
    if encrypted_cvv.nil?
      render status: 500, json:{success: false, errors:['Transaction timeout']}
      return
    end

    password = 'conekta'
    private_key = OpenSSL::PKey::RSA.new(File.read(Rails.root.join('private.pem')),password)
    cvv = private_key.private_decrypt(Base64.decode64(encrypted_cvv))
    puts "EL CVV:::::::::::::::::::::: #{cvv}"

    params[:status] = 'success'
    @charge = Charge.new(params)
    if @charge.save
      redis.del(@card.token)
      render status: 201, json: {success: true, transaction_id: @charge.id}
    else
      render status: 500, json:{success: false, errors: @charge.errors.full_messages.collect{|e| e}}
    end

  end

  private

  def charge_params
    params.require(:charge).permit(:token, :amount, :details)
  end
end
