# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sortable do
  describe '.order_by' do
    let(:relation) { Design.all }

    describe 'ordering by id' do
      it 'ascending' do
        allow(relation).to receive(:reorder).with(id: :asc)

        relation.order_by('id_asc')

        expect(relation).to have_received(:reorder).with(id: :asc)
      end

      it 'descending' do
        allow(relation).to receive(:reorder).with(id: :desc)

        relation.order_by('id_desc')

        expect(relation).to have_received(:reorder).with(id: :desc)
      end
    end

    describe 'ordering by created day' do
      it 'ascending' do
        allow(relation).to receive(:reorder).with(created_at: :asc)

        relation.order_by('created_asc')

        expect(relation).to have_received(:reorder).with(created_at: :asc)
      end

      it 'descending' do
        allow(relation).to receive(:reorder).with(created_at: :desc)

        relation.order_by('created_desc')

        expect(relation).to have_received(:reorder).with(created_at: :desc)
      end

      it 'order by "date"' do
        allow(relation).to receive(:reorder).with(created_at: :desc)

        relation.order_by('created_date')

        expect(relation).to have_received(:reorder).with(created_at: :desc)
      end
    end

    describe 'ordering by name' do
      it 'ascending' do
        table = Regexp.escape(ActiveRecord::Base.connection.quote_table_name(:designs))
        column = Regexp.escape(ActiveRecord::Base.connection.quote_column_name(:name))

        sql = relation.order_by('name_asc').to_sql

        expect(sql).to match(/.+ORDER BY LOWER\(#{table}.#{column}\) ASC\z/)
      end

      it 'descending' do
        table = Regexp.escape(ActiveRecord::Base.connection.quote_table_name(:designs))
        column = Regexp.escape(ActiveRecord::Base.connection.quote_column_name(:name))

        sql = relation.order_by('name_desc').to_sql

        expect(sql).to match(/.+ORDER BY LOWER\(#{table}.#{column}\) DESC\z/)
      end
    end

    describe 'ordering by Updated Time' do
      it 'ascending' do
        allow(relation).to receive(:reorder).with(updated_at: :asc)

        relation.order_by('updated_asc')

        expect(relation).to have_received(:reorder).with(updated_at: :asc)
      end

      it 'descending' do
        allow(relation).to receive(:reorder).with(updated_at: :desc)

        relation.order_by('updated_desc')

        expect(relation).to have_received(:reorder).with(updated_at: :desc)
      end
    end

    it 'does not call reorder in case of unrecognized ordering' do
      allow(relation).to receive(:reorder)

      relation.order_by('random_ordering')

      expect(relation).not_to have_received(:reorder)
    end
  end

  describe 'sorting designs' do
    def ordered_design_names(order)
      Design.all.order_by(order).map(&:name)
    end

    let!(:ref_time) { Time.zone.parse('2020-04-28 00:00:00') }

    before do
      create(:design, name: 'aa', id: 1, created_at: ref_time - 15.seconds,
                      updated_at: ref_time)
      create(:design, name: 'AAA', id: 2, created_at: ref_time - 10.seconds,
                      updated_at: ref_time - 5.seconds)
      create(:design, name: 'BB', id: 3, created_at: ref_time - 5.seconds,
                      updated_at: ref_time - 10.seconds)
      create(:design, name: 'bbb', id: 4, created_at: ref_time, updated_at: ref_time - 15.seconds)
    end

    it 'sorts designs by id' do
      expect(ordered_design_names('id_asc')).to eq(%w[aa AAA BB bbb])
      expect(ordered_design_names('id_desc')).to eq(%w[bbb BB AAA aa])
    end

    it 'sorts designs by name via case-insensitive comparison' do
      expect(ordered_design_names('name_asc')).to eq(%w[aa AAA BB bbb])
      expect(ordered_design_names('name_desc')).to eq(%w[bbb BB AAA aa])
    end

    it 'sorts designs by created_at' do
      expect(ordered_design_names('created_asc')).to eq(%w[aa AAA BB bbb])
      expect(ordered_design_names('created_desc')).to eq(%w[bbb BB AAA aa])
      expect(ordered_design_names('created_date')).to eq(%w[bbb BB AAA aa])
    end

    it 'sorts designs by updated_at' do
      expect(ordered_design_names('updated_asc')).to eq(%w[bbb BB AAA aa])
      expect(ordered_design_names('updated_desc')).to eq(%w[aa AAA BB bbb])
    end
  end
end
