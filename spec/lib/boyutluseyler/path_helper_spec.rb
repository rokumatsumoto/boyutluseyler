require 'spec_helper'

RSpec.describe Boyutluseyler::PathHelper do
  let(:path) { '/path/to/filename.jpg' }

  describe '.info' do
    context 'when a path component is not specified' do
      # remove this test when all methods in here called by other methods
      it 'returns all components of a path' do
        allow(described_class).to receive(:dirname_with_filename)
        allow(described_class).to receive(:dirname)
        allow(described_class).to receive(:basename)
        allow(described_class).to receive(:filename)
        allow(described_class).to receive(:extension)

        described_class.info(path)

        expect(described_class).to have_received(:dirname_with_filename)
        expect(described_class).to have_received(:dirname)
        expect(described_class).to have_received(:basename)
        expect(described_class).to have_received(:filename)
        expect(described_class).to have_received(:extension)
      end
    end

    context 'when a path component is specified' do
      context 'for dirname_with_filename' do
        it 'returns all components of the path except the extension' do
          result = described_class.info(path, :dirname_with_filename)

          expect(result).to eq('/path/to/filename')
        end
      end

      context 'for dirname' do
        it 'returns all but the last component of the path' do
          result = described_class.info(path, :dirname)

          expect(result).to eq('/path/to')
        end
      end

      context 'for basename' do
        it 'returns the last component of the path' do
          result = described_class.info(path, :basename)

          expect(result).to eq('filename.jpg')
        end
      end

      context 'for filename' do
        it 'returns the filename without extension' do
          result = described_class.info(path, :filename)

          expect(result).to eq('filename')
        end

        it 'returns "" if the path starts with a dot' do
          path = '.jpg'

          result = described_class.info(path, :filename)

          expect(result).to eq('')
        end
      end

      context 'for extension' do
        it 'returns the file’s extension' do
          result = described_class.info(path, :extension)

          expect(result).to eq('.jpg')
        end
      end

      context 'for an unknown path component' do
        it 'raises NoMethodError' do
          expect { described_class.info(path, :unknown) }.to raise_error(NoMethodError)
        end
      end
    end

    context 'when the path is empty' do
      it 'returns nil' do
        path = ''

        result = described_class.info(path)

        expect(result).to be_nil
      end
    end
  end

  describe '.append_suffix_before_extension' do
    it 'appends suffix to the path before the extension' do
      suffix = '_thumb'

      result = described_class.append_suffix_before_extension(path, suffix)

      expect(result).to eq('/path/to/filename_thumb.jpg')
    end

    context 'when suffix is empty' do
      it 'does not append a suffix to the path' do
        suffix = ''

        result = described_class.append_suffix_before_extension(path, suffix)

        expect(result).to eq(path)
      end
    end
  end
end
