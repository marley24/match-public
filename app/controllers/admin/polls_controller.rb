module Admin
  class PollsController < AdminController
    before_action :allowed_to_create_poll, only: [:create, :new]
    before_action :assign_match

    def index
      @polls = Poll.all
      redirect_to new_admin_match_poll_path(@match) if @polls.empty?
    end

    def new
      @poll = Poll.new
    end

    def edit
      @poll = Poll.find(params[:id])
    end

    def create
      @poll = Poll.new(poll_params)
      @poll.match = Match.last
      if @poll.save
        flash[:notice] = t('poll.created')
        redirect_to admin_match_polls_path(@match)
      else
        flash[:alert] = @poll.end_date <= @poll.start_date ? t('poll.error_dates') : t('poll.error_creating')
        render 'new'
      end
    end

    def update
      @poll = Poll.find(params[:id])
      if @poll.update(poll_params)
        flash[:notice] = t('poll.updated')
        redirect_to admin_polls_path
      else
        flash[:alert] = t('poll.error_updating')
        render 'edit'
      end
    end

    def destroy
      @poll = Poll.find(params[:id])
      if @poll.destroy
        flash[:notice] = t('poll.deleted')
      else
        flash[:alert] = t('poll.error_deleting')
      end
      redirect_to admin_match_polls_path(@match)
    end

    private

    def assign_match
      @match = Match.find(params[:match_id])
    end

    def allowed_to_create_poll
      return if Poll.pending_polls(Date.today).empty?

      flash[:alert] = t('poll.error_actual_polls')
      redirect_to admin_polls_path
    end

    def poll_params
      params.require(:poll).permit(:end_date, :start_date, :activities_from, :activities_to)
    end
  end
end
