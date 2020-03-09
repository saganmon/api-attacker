class HomesController < ApplicationController

  def index
    @postal_code = PostalCode.new
  end

end
