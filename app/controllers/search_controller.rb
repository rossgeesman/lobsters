class SearchController < ApplicationController
  def index
    @title = t('controllers.search.title')
    @cur_url = "/search"

    if params[:q].present?
      @search_results = search(params[:q])
    end

    render :action => "index"
  end

  private

  def search(query)
    ActiveRecord::Base.connection.execute("SELECT set_limit(0.01);")
    Story.fuzzy_search(title: query)
  end
end
