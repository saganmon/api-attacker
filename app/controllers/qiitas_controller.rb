class QiitasController < ApplicationController

  def index
    @items = QiitaItem.get_response
  end

end
