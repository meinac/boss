require 'spec_helper'

describe Application do

  let(:application)               { fixture :application }
  let(:release)                   { fixture :release }
  let(:application_with_releases) { fixture :application, releases: [release] }

  describe '#path' do
    it 'returns the data path of application' do
      expect(application.path).to eql('tmp/Foo')
    end
  end

  describe '#init_file_system!' do
    it 'calls file system with application data path' do
      expect(FS).to receive(:mkdir).with('tmp/Foo')

      application.init_file_system!
    end
  end

  describe '#create_release_candidate' do
    context 'when ReleaseFactory returns release' do
      before { allow(ReleaseFactory).to receive(:create).and_return(release) }

      it 'changes releases of the application' do
        expect {
          application.create_release_candidate
        }.to change { application.releases.length }.from(0).to(1)
      end
    end

    context 'when ReleaseFactory returns nil object which means release has no changes' do
      before { allow(ReleaseFactory).to receive(:create).and_return(nil) }

      it 'does not change releases' do
        expect {
          application.create_release_candidate
        }.not_to change { application.releases.length }
      end
    end
  end

  describe '#next_release_version' do
    context 'when the application has no release' do
      it 'returns 1' do
        expect(application.next_release_version).to eql(1)
      end
    end

    context 'when the application has releases' do
      it 'returns the one above number of last release number' do
        expect(application_with_releases.next_release_version).to eql(2)
      end
    end
  end

end
