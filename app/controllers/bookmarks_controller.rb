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
    redirect_to events_path
  end

  def destroy
    @bookmark = current_user.bookmarks.find(params[:id])
    @bookmark.destroy
    flash[:success] = "Removed the bookmark."

    # リダイレクト先を判別
    if request.referer.include?('bookmarks')
      redirect_to bookmarks_path
    else
      redirect_to events_path
    end
  end

  private

  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_path
    end
  end
end
