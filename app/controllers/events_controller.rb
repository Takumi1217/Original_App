class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def new
    @event = Event.new
  end

  # イベント検索&表示欄
  def index
    @q = Event.ransack(params[:q])
    @events = @q.result(distinct: true).order(created_at: :desc)
  end

  # イベントの詳細を表示
  def show
    # @eventはset_eventで取得済み
  end

  # 自分のイベント一覧を表示
  def my_events
    @events = current_user.events.order(created_at: :desc)
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      flash[:success] = "Event created!"
      redirect_to root_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @eventはset_eventで取得済み
  end

  def update
    if @event.update(event_params)
      flash[:success] = "Event updated!"
      redirect_to my_events_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to my_events_path, notice: "イベントを削除しました。"
  end

  private

  def set_event
    @event = current_user.events.find(params[:id]) # 自分のイベントのみ操作可能
  end

  def event_params
    params.require(:event).permit(:title, :catchphrase, :body, :start_date, :end_date, :area, :place, :station, :category, :contact, :cost, :link, :thumbnail, images: [])
  end  
  
end
