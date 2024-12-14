class BookmarksController < ApplicationController
  before_action :logged_in_user

  def index
    @bookmarked_events = current_user.bookmarks.includes(:event).map(&:event)
  end

  def create
    @bookmark = current_user.bookmarks.build(event_id: params[:event_id])
    if @bookmark.save
      flash[:success] = "イベントをブックマークしました！"
    else
      flash[:danger] = "ブックマークに失敗しました。"
    end
    redirect_to events_path # リダイレクト先はevents#index
  end

  def destroy
    @bookmark = current_user.bookmarks.find(params[:id])
    @bookmark.destroy
    flash[:success] = "ブックマークを解除しました。"

    # リダイレクト先を判別
    if request.referer.include?('bookmarks')
      redirect_to bookmarks_path # ブックマークページに戻る
    else
      redirect_to events_path # イベントページに戻る
    end
  end

  private

  def logged_in_user
    unless logged_in?
      flash[:danger] = "ログインしてください。"
      redirect_to login_path
    end
  end
end
