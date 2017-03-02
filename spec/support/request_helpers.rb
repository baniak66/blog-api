module Requests
  module JsonHelpers
    def json
      JSON.parse(response.body)
    end
  end
  module JwtHelpers
    def get_token(user)
      post "/user_token", :params => {
            auth: {email: user.email, password: user.password}
        }
      json['jwt']
    end
  end
end
