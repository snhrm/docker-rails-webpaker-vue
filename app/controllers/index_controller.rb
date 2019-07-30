class IndexController < ApplicationController
  def index
    render file: '/index'
  end
end
