RSpec.shared_examples 'generates new friendly_id when attribute changed on model' do
   |model_name, attribute|
  describe '#should_generate_new_friendly_id?' do
    subject(:model) { build_stubbed(:"#{model_name}", :with_slug) }

    context "when #{attribute} attribute is changed" do
      it 'generates matching slug' do
        model[attribute] += ' updated'

        expect(model.send(:should_generate_new_friendly_id?)).to be true
      end
    end

    context "when #{attribute} attribute is not changed" do
      it 'does not generate matching slug' do
        expect(model.send(:should_generate_new_friendly_id?)).to be false
      end
    end

    context 'if record is new' do
      subject(:model) { build(:"#{model_name}") }

      it 'generates matching slug' do
        expect(model.send(:should_generate_new_friendly_id?)).to be true
      end
    end
  end
end
