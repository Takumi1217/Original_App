class NoticesController < ApplicationController
  def index
    @notices = Notice.order(published_at: :desc).limit(10)
  end
end
