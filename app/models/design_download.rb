# frozen_string_literal: true
# == Schema Information
#
# Table name: design_downloads
#
#  id         :bigint(8)        not null, primary key
#  step       :string(50)       not null
#  url        :string
#  design_id  :bigint(8)        not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class DesignDownload < ApplicationRecord
  extend Concerns::StateMachineSwitcher
  self.default_state_machine = DownloadStateMachine

  belongs_to :design

  before_validation :preserve_current_step
  validate :step_defined_in_state_machines

  def state_machine
    @state_machine ||= StepMachine.new(
      target: self,
      state_machine_class: self.class.state_machine_class,
      step: (step? && step)
    )
  end
  delegate(
    :go_forward, :current_step, :set_step_as, :rollback_to, :previous_step?,
    :previous_step, :next_step, :next_step?, :state_machine_class,
    :defined_steps, :initial_step, :go_back, :go_back!, :can?,
    to: :state_machine
  )

  private

  def preserve_current_step
    self.step = current_step
  end

  def step_defined_in_state_machines
    return true if defined_steps.include? step.to_s

    errors.add(:step, "#{step} is not defined in #{state_machine_class}")
  end
end
