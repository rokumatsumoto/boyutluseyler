# frozen_string_literal: true

class DesignsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_design, only: %i[show edit update destroy]
  after_action :sort_lists, only: %i[create update]

  def new
    @design = Design.new
  end

  def show; end

  def create
    @design = Design.new(design_params)
    @design.user = current_user
    set_model_file_format

    if @design.save
      redirect_to @design
    else
      render :new
    end
  end

  def edit; end

  def update
    set_model_file_format

    if @design.update(design_params)
      redirect_to action: :edit
    else
      render :edit
    end
  end

  def sort_lists
    sort_illustrations
    sort_blueprints
  end

  def sort_illustrations
    return if illustration_ids_identical?

    design_params[:illustration_ids].each_with_index do |id, index|
      @design.design_illustrations.where(illustration_id: id)
             .update_all(position: index + 1)
    end
  end

  def sort_blueprints
    return if blueprint_ids_identical?

    design_params[:blueprint_ids].each_with_index do |id, index|
      @design.design_blueprints.where(blueprint_id: id)
             .update_all(position: index + 1)
    end
  end

  def set_model_file_format
    return if blueprint_ids_identical?

    file_formats = Set.new
    design_params[:blueprint_ids].each do |id|
      file_formats << MiniMime.lookup_by_content_type(Blueprint.find(id)
                              .content_type).extension.downcase
    end

    @design.model_file_format = file_formats.to_a.join(', ')
  end

  def blueprint_ids_identical?
    return true if design_params[:blueprint_ids].nil?

    return true if action_name == 'update' && @design.blueprint_ids.map(&:to_s) ==
                                              design_params[:blueprint_ids]
  end

  def illustration_ids_identical?
    return true if design_params[:illustration_ids].nil?

    return true if action_name == 'update' && @design.illustration_ids.map(&:to_s) ==
                                              design_params[:illustration_ids]
  end

  private

  def design_params
    params.require(:design)
          .permit(:name, :description, :printing_settings,
                  :license_type, :tags_as_string, :allow_comments,
                  :category_id, illustration_ids: [], blueprint_ids: [])
  end

  def set_design
    @design = Design.find(params[:id])
  end
end
