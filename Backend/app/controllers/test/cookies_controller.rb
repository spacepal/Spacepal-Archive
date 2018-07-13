class Test::CookiesController < ApplicationController
  def get
    render :json => { response: cookies.encrypted[:test_string] }
  end

  def set
    cookies.encrypted[:test_string] = {
      value: "cookies work"
    }
    render :json => { response: "cookies were made!"}
  end

  def del
    cookies.delete :test_string
    render :json => { response: "cookies were deleted", cookies: cookies.encrypted[:test_string] }
  end
end
