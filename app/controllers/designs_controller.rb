# frozen_string_literal: true

class DesignsController < ApplicationController
  include AhoyActions

  before_action :authenticate_user!, except: %i[show latest popular]
  before_action :design, only: %i[show edit update destroy download like]

  def new
    authorize Design

    @design = Design.new
    @illustrations = {}
    @blueprints = {}
  end

  def show
    @illustrations = BuildSerializer.new(design.preview_illustrations,
                                         fields: { illustration: file_preview_fields })
                                    .serialize

    @blueprints = BuildSerializer.new(design.preview_blueprints,
                                      fields: { blueprint: file_preview_fields })
                                 .serialize

    @page_views_count = Ahoy::Event.where_event(Ahoy::Event::VIEWED_DESIGN,
                                                design_id: design.id).count

    Designs::PageViews::AfterPageViewService.new(design, current_user, controller: self).execute
  end

  def create
    authorize Design

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

  def destroy
    Designs::DestroyService.new(design, current_user).execute

    redirect_to root_path
  end

  def download
    url = Designs::Downloads::StateMachineService.new(design).execute

    Designs::Downloads::AfterDownloadService.new(design,
                                                 current_user,
                                                 controller: self).execute

    render json: { url: url }, status: :ok
  end

  def like
    Designs::Likes::AfterLikeService.new(design, current_user, controller: self).execute
  end

  def latest
    authorize Design

    @pagy, @designs = pagy(DesignsFinder.new(design_list_params).execute)
  end

  def popular
    authorize Design

    params[:popularity] = true
    @pagy, @designs = pagy(DesignsFinder.new(design_list_params).execute)
  end

  private

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
    @design ||= Design.friendly.find(params[:id])
    authorize @design
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

  def design_list_params
    params[:with_illustration] = true
    params.permit(%i[direction sort page with_illustration popularity])
  end

  def file_preview_fields
    %i[id url thumbUrl]
  end

  def file_detail_fields
    %i[id url thumbUrl filename size]
  end
end
