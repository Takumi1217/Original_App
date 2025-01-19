class EventsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :my_events]
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def new
    @event = Event.new
  end

  def index
    @q = Event.ransack(params[:q])
    @events = @q.result(distinct: true)

    if params[:sort] == 'rank'
      @events = @events
                 .unscope(:order)
                 .left_joins(:bookmarks)
                 .group('events.id')
                 .select('events.*, COALESCE(COUNT(bookmarks.id), 0) AS bookmarks_count')
                 .order('bookmarks_count DESC, events.created_at DESC')
    else
      @events = @events.order(created_at: :desc)
    end      

    @events = @events.paginate(page: params[:page], per_page: 30)
  end

  def show
    store_event_in_cookies(@event.id)
  end

  def my_events
    @events = current_user.events.order(created_at: :desc).paginate(page: params[:page], per_page: 30)
  end

  def viewed_history
    viewed_event_ids = cookies.signed[:viewed_events] ? JSON.parse(cookies.signed[:viewed_events]) : []
    if viewed_event_ids.any?
      order_clause = viewed_event_ids.map.with_index { |id, index| "WHEN #{id} THEN #{index}" }.join(" ")
      @viewed_events = Event.where(id: viewed_event_ids).order(Arel.sql("CASE id #{order_clause} END"))
    else
      @viewed_events = Event.none
    end
  end  

  def create
    @event = Event.new(event_params)
    @event.user_id = current_user.id

    if @event.save
      flash[:success] = "Event created!"
      redirect_to my_events_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
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

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url, status: :see_other
    end
  end

  def store_event_in_cookies(event_id)
    viewed_events = cookies.signed[:viewed_events] ? JSON.parse(cookies.signed[:viewed_events]) : []
    viewed_events.delete(event_id) if viewed_events.include?(event_id)
    viewed_events.unshift(event_id)
    viewed_events = viewed_events.first(15)
    cookies.signed[:viewed_events] = {
      value: JSON.generate(viewed_events),
      expires: 7.days.from_now
    }
  end
end
