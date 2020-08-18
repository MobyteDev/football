class SuperuserTokenController < Knock::AuthTokenController
  private

  def auth_params
    params.require(:auth).permit(:login, :password)
  end
end
