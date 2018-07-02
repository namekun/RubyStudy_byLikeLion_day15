class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception -> 주석처리하면 csrf공격을 안막겠다 라는 의미. 즉 외부에서 우리서버로의 요청을 받겠다는 의미이다.
end
