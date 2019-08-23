# frozen_string_literal: true

class DesignsController < ApplicationController
  include Boyutluseyler::Utils::StrongMemoize

  before_action :authenticate_user!, except: %i[show index]
  before_action :design, only: %i[show edit update destroy]

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
  end

  def create
    @design = Designs::CreateService.new(nil, current_user, design_params).execute

    if @design.persisted?
      redirect_to @design
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
    strong_memoize(:design) { Design.find(params[:id]) }
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
