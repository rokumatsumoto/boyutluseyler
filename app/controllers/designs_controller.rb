# frozen_string_literal: true

class DesignsController < ApplicationController
  include Boyutluseyler::Utils::StrongMemoize

  before_action :authenticate_user!, except: %i[show index]
  before_action :design, only: %i[show edit update destroy download]

  def new
    @design = Design.new
    @illustrations = {}
    @blueprints = {}
  end

  def show
    @illustrations = BuildSerializer.new(design.illustrations,
                                         fields: { illustration: file_preview_fields })
                                    .serialize

    @model_blueprints = BuildSerializer.new(design.model_blueprints,
                                            fields: { blueprint: file_preview_fields })
                                       .serialize

    @page_views_count = Ahoy::Event.where_event('Viewed design', design_id: design.id).count

    ahoy.track 'Viewed design', design_id: design.id
  end

  def create
    @design = Designs::CreateService.new(nil, current_user, design_params).execute

    if @design.persisted?
      redirect_to design_show_path(@design.category.slug, @design)
    else
      design_files_for(:create_error)

      render :new
    end
  end

  def edit
    design_files_for(:edit)
  end

  def update
    @design = Designs::UpdateService.new(design, current_user, design_params).execute

    if @design.valid?
      redirect_to action: :edit
    else
      design_files_for(:update_error)

      render :edit
    end
  end

  # TODO: soft deletion
  def destroy
    design.destroy

    redirect_to root_path
  end

  def download
    url = Designs::Downloads::StateMachineService.new(design).execute

    ensure_new_visit_created_before_async_jobs

    AhoyWorker.perform_async(current_user_id: current_user.id,
                             event_name: 'Downloaded design',
                             design_id: design.id,
                             visit_token: ahoy.visit_token)

    render json: { url: url }, status: :ok
  end

  private

  # Ahoy.server_side_visits = :when_needed
  # We are using the above config so visits will be created server-side only when needed by events
  # In this file we track events named 'Viewed design' 'Downloaded design', 'Liked design' and 'Saved design'
  # 'Viewed design' event invoked synchronously, others invoked asynchronously
  # Ahoy uses 'request' object for accessing 'traffic source', 'technology', 'UTM parameters' etc. (https://api.rubyonrails.org/v6.0.0/classes/ActionDispatch/Request.html)
  # For asynchronous jobs, we cannot send this 'request' object to the Sidekiq (https://github.com/mperham/sidekiq/wiki/Best-Practices#1-make-your-job-parameters-small-and-simple)
  # https://github.com/ankane/ahoy/pull/409

  # In our scenario user must view the design before async jobs. (download, like, save) When the user views the design, a visit record will be created if 'visit_duration' (4.hours) time expired at that moment.
  # Users may visit the design very close to the end of the 'visit_duration', after that visit 'visit_duration' time may be expired. Clicking the download button creates a new visit record because 'visit_duration' time expired. This new visit record will contain missing data about 'traffic source', 'technology', 'UTM parameters' etc. because Ahoy will be unable to access 'request' object in the async job.
  # So we need to ensure a new visit is created in controller or service before async jobs.

  def ensure_new_visit_created_before_async_jobs
    # https://github.com/ankane/ahoy/blob/6409f3152afa882659a02f95644e3ac928f7dcb6/lib/ahoy/controller.rb#L31
    ahoy.track_visit(defer: false) if ahoy.new_visit?
  end

  def design_files_for(action)
    lists = Designs::Files::ListService.new(list_options_for(action)).execute

    @illustrations = BuildSerializer.new(lists[:illustrations],
                                         fields: { illustration: file_detail_fields })
                                    .serialize

    @blueprints = BuildSerializer.new(lists[:blueprints],
                                      fields: { blueprint: file_detail_fields })
                                 .serialize
  end

  def list_options_for(action)
    opts = {}

    opts[:action] = action
    case action
    when :create_error
      opts[:design] = @design
      opts[:params] = design_params
    when :update_error
      opts[:design] = design
      opts[:params] = design_params
    when :edit
      opts[:design] = design
    end

    opts
  end

  def design
    strong_memoize(:design) { Design.friendly.find(params[:id]) }
  end

  def design_params
    params.require(:design).permit(design_params_attributes)
  end

  def design_params_attributes
    [
      :name,
      :description,
      :printing_settings,
      :license_type,
      :tags_as_string,
      :allow_comments,
      :category_id,
      illustration_ids: [],
      blueprint_ids: []
    ]
  end

  def file_preview_fields
    %i[id url imageUrl]
  end

  def file_detail_fields
    %i[id url size imageUrl filename]
  end
end
