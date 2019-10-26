class UsersController < ApplicationController

  def login 
    userFound = User.find_by(name: request.headers[:username])
    if userFound && userFound.authenticate(request.headers[:password])
      payload = {user: userFound.id}
      token = JWT.encode(payload, 'okcool', 'HS256')
      render json: {token: token}
    else 
      render json: "Failed, wrong password."
    end 
  end 

  def create 
    newUser = User.new(name: request.headers[:username], age: request.headers[:age], password: request.headers[:password])
    if newUser.valid? 
      newUser.save
      payload = {user: newUser.id}
      token = JWT.encode(payload, 'okcool', 'HS256')
      render json: {token: token}
    else 
      render json: newUser.errors 
    end 
  end 

  def profile 
    decoded_token = JWT.decode(request.headers[:token], 'okcool', true, {algorithm: 'HS256'})
    foundProfile = User.find(decoded_token[0]["user"])
    render json: foundProfile.to_json(except: [:password_digest])
  end 
end
