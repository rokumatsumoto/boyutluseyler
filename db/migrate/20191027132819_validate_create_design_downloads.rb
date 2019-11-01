class ValidateCreateDesignDownloads < ActiveRecord::Migration[5.2]
  def change
    validate_foreign_key :design_downloads, :designs
  end
end
