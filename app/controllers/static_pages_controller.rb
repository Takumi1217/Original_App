class StaticPagesController < ApplicationController
  def home
    @events = Event.order("RANDOM()").limit(6) # ピックアップ用
    @free_events = Event.where(cost: '0').order(created_at: :desc).limit(6) # 無料イベント用
    @popular_events = Event.unscope(:order)
                            .joins(:bookmarks)
                            .group('events.id')
                            .order('COUNT(bookmarks.id) DESC') # Bookmarks数で並べ替え
                            .limit(9) # 人気イベント用
  end

  def agreement
  end

  def policy
  end

  def help
  end

  def contact
  end

  def history
  end

  def notice
  end
end
