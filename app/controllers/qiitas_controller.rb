class QiitasController < ApplicationController

  def index
    @items = QiitaItem.get
  end

end
