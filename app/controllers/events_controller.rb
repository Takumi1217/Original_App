class EventsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :my_events]
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def new
    @event = Event.new
  end

  def index
    @q = Event.ransack(params[:q])
    @events = @q.result(distinct: true).order(created_at: :desc).paginate(page: params[:page], per_page: 30)
  end
  
  def show
    # @eventはset_eventで取得済み
  end

  def my_events
    @events = current_user.events.order(created_at: :desc).paginate(page: params[:page], per_page: 30)
  end

  def create
    @event = Event.new(event_params)
    @event.user_id = current_user.id
    
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
    flash[:success] = "Event deleted."
    redirect_to my_events_path
  end  

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(
      :title, :catchphrase, :body, :start_date, :end_date, :area, :place,
      :station, :category, :contact, :cost, :link, :thumbnail, :image_1, :image_2
    )
  end

  # ログインしていない場合はログインページにリダイレクト
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url, status: :see_other
    end
  end
end
