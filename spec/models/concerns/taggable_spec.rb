# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Taggable do
  shared_examples 'taggable' do
    let(:tag_names) { %w[tag1 tag2 tag3] }
    let(:tags_as_string) { 'tag1, tag2, tag3' }

    describe '#tags_as_string' do
      it 'returns the tag names separated by commas and spaces' do
        allow(model).to receive(:tag_names).and_return(tag_names)

        expect(model.tags_as_string). to eq(tags_as_string)
      end
    end

    describe '#tags_as_string=' do
      it 'splits up the provided value by commas and spaces' do
        model.tags_as_string = tags_as_string

        expect(model.tag_names). to eq(tag_names)
      end

      it 'strips leading and trailing whitespaces' do
        model.tags_as_string = '      tag1, tag2    ,tag3  '

        expect(model.tag_names). to eq(tag_names)
      end

      it 'separates tag names, strips whitespaces, and sets to cached_tag_names' do
        model.tags_as_string = '      tag1, tag2    ,tag3  '

        expect(model.cached_tag_names). to eq(tags_as_string)
      end
    end

    describe '#cached_tag_name_list' do
      context 'when cached tag names are blank' do
        it 'returns empty list' do
          allow(model).to receive(:cached_tag_names).and_return('')

          expect(model.cached_tag_name_list).to eq([])
        end
      end

      context 'when cached tag names exist' do
        it 'splits up the cached tag names and creates a list of them' do
          allow(model).to receive(:cached_tag_names).and_return(tags_as_string)

          expect(model.cached_tag_name_list).to eq(tag_names)
        end
      end
    end
  end

  context 'when model is a Design' do
    it_behaves_like 'taggable' do
      let(:model) { build_stubbed(:design) }
    end
  end
end
