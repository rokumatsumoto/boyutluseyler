# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Designs::BuildService do
  def build_design(params)
    described_class.new(nil, user, params).execute
  end

  describe '#execute' do
    include_context 'valid design create params'

    it 'builds a new design with given params' do
      design = build_design(params)

      expect(design).to be_valid
      expect(design.model_file_format). to eq('stl')
      expect(design.illustrations).to match_array [illustration]
      expect(design.blueprints).to match_array [blueprint]
    end

    xit 'cleans up any blueprint id params that are not user own' do
      # ownership check
      # should not be associated with a design before
    end

    xit 'cleans up any illustration id params that are not user own' do
      # ownership check
      # should not be associated with a design before
    end
  end
end
