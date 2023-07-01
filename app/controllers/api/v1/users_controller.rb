class Api::V1::UsersController < ApplicationController
  skip_before_action :authorized, only: [:create]
  wrap_parameters format: []

  def profile
    render json: { user: UserSerializer.new(current_user) }, status: :accepted
  end
  def index
    users = User.all
    render json: users, status: :ok
  end
  def create
    user = User.create(user_params)
    if user.valid?
      token = encode_token(user_id: user.id)
      render json: { user:user, jwt: token }, status: :created
    else
      render json: { error: 'failed to create user' }, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.permit(:username, :password, :bio, :avatar)
  end
end

# fetch("http://localhost:3000/api/v1/users", {
#   method: "POST",
#   headers: {
#     "Content-Type": "application/json",
#     Accept: "application/json",
#   },
#   body: JSON.stringify(newUserData),
# })
#   .then((r) => r.json())
#   .then((data) => {
#     // save the token to localStorage for future access
#     localStorage.setItem("jwt", data.jwt);
#     // save the user somewhere (in state!) to log the user in
#     setUser(data.user);
#   });
