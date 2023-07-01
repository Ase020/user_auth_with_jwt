class Api::V1::AuthController < ApplicationController
  skip_before_action :authorized, only: [:create]

  def create
    user = User.find_by(username: user_log_in_params[:username])
    #User#authenticate comes from BCrypt
    if user&.authenticate(user_log_in_params[:password])
      # encode token comes from ApplicationController
      token = encode_token({ user_id: user.id })
      render json: {user:user, jwt:token}, status: :accepted
    else
      render json: {message: "Invalid username or password"}, status: :unauthorized
    end
    end

  private
  def user_login_params
    # params { user: {username: 'Chandler Bing', password: 'hi' } }
    params.permit(:username, :password)
  end

end

# A sample request might look like:
#
#                               const token = localStorage.getItem("jwt");
#
# fetch("http://localhost:3000/api/v1/profile", {
#   method: "GET",
#   headers: {
#     Authorization: `Bearer ${token}`,
#   },
# });
