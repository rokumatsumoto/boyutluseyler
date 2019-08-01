# frozen_string_literal: true

class DesignsController < ApplicationController
  before_action :authenticate_user!, except: %i[show index]
  before_action :design, except: %i[index]
  before_action :design_model_file_format, only: %i[create update]

  def new
    @illustrations = {}
    @blueprints = {}
  end

  def show
    @illustrations = IllustrationSerializer.new(@design.illustrations, fields: {
                                                  illustration: %i[id url imageUrl]
                                                }).serialized_json

    @model_blueprints = BlueprintSerializer.new(@design.model_blueprints, fields: {
                                                  blueprint: %i[id url imageUrl]
                                                }).serialized_json
  end

  def create
    @design.user = current_user

    if @design.save
      sort_lists
      redirect_to @design
    else
      illustrations_blueprints(:with_no_relation_with_design)
      render :new
    end
  end

  def edit
    illustrations_blueprints
  end

  def update
    if @design.update(design_params)
      sort_lists
      redirect_to action: :edit
    else
      sort_lists
      illustrations_blueprints(:with_no_relation_with_design)
      render :edit
    end
  end

  def serialize_illustrations_blueprints(illustrations, blueprints)
    @illustrations = IllustrationSerializer.new(illustrations, fields: { illustration:
        %i[id url size imageUrl filename] }).serialized_json

    @blueprints = BlueprintSerializer.new(blueprints, fields: { blueprint:
        %i[id url size imageUrl filename] }).serialized_json
  end

  def illustrations_blueprints(status = nil)
    # TODO: REFACTOR SERVICE CLASS
    case status
    when :with_no_relation_with_design
      illustrations = if design_params[:illustration_ids].all?(&:blank?)
                        @design.illustrations.reload
                      else
                        # TODO: select
                        Illustration.left_outer_joins(:design_illustration)
                                    .where(id: design_params[:illustration_ids].map(&:to_i))

                      end
      blueprints = if design_params[:blueprint_ids].all?(&:blank?)
                     @design.blueprints.reload
                   else
                    # TODO: select
                     Blueprint.left_outer_joins(:design_blueprint)
                              .where(id: design_params[:blueprint_ids].map(&:to_i))
                   end
    else
      illustrations = @design.illustrations
      blueprints = @design.blueprints
    end

    serialize_illustrations_blueprints(illustrations, blueprints)
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

  def design_model_file_format
    return if blueprint_ids_identical?

    file_formats = Set.new
    design_params[:blueprint_ids].each do |id|
      file_formats << MiniMime.lookup_by_content_type(Blueprint.find(id)
                              .content_type).extension.downcase
    end

    @design.model_file_format = file_formats.to_a.join(', ')
  end

  def blueprint_ids_identical?
    return true if design_params[:blueprint_ids].all?(&:blank?)

    return true if action_name == 'update' && @design.blueprint_ids.map(&:to_s) ==
                                              design_params[:blueprint_ids]
  end

  def illustration_ids_identical?
    return true if design_params[:illustration_ids].all?(&:blank?)

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

  def design
    return @design = Design.new(design_params) if action_name == 'create'
    return @design = Design.new if action_name == 'new'

    @design = Design.find(params[:id])
  end
end
