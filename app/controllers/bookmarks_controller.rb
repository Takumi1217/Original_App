class BookmarksController < ApplicationController
  before_action :logged_in_user

  def index
    @bookmarked_events = current_user.bookmarks.includes(:event).map(&:event)
  end

  def create
    @bookmark = current_user.bookmarks.build(event_id: params[:event_id])
    if @bookmark.save
      flash[:success] = "Bookmarked the event!"
    else
      flash[:danger] = "Bookmarking failed."
    end
    redirect_back_or_to events_path
  end

  def destroy
    @bookmark = current_user.bookmarks.find(params[:id])
    @bookmark.destroy
    flash[:success] = "Removed the bookmark."

    redirect_back_or_to events_path
  end

  private

  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_path
    end
  end

  # リダイレクト先をリファラから取得
  def redirect_back_or_to(default)
    redirect_to(request.referer || default)
  end
end
