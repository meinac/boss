require 'spec_helper'

describe Release do

  let(:author)          { fixture :author }
  let(:hotfix_commit)   { fixture :commit, :hotfix }
  let(:regular_commit)  { fixture :commit }
  let(:regular_release) { fixture :release, commits: [regular_commit] }
  let(:hotfix_release)  { fixture :release, commits: [hotfix_commit, regular_commit] }
  let(:empty_release)   { fixture :release, commits: [] }

  around do |example|
    with_time_zone('UTC') { example.run }
  end

  describe '#name' do
    it 'returns human friendly name of the release' do
      expect(regular_release.name).to eql('Foo (1 - 2017/10/04 10:34)')
    end
  end

  describe '#serialization_name' do
    it 'returns release name for internal usage' do
      expect(regular_release.serialization_name).to eql('2017_10_04_10_34_48')
    end
  end

  describe '#commits' do
    it 'returns all the commits' do
      expect(hotfix_release.commits).to eql([hotfix_commit, regular_commit])
    end
  end

  describe '#authors' do
    it 'returns the list of uniq commit authors' do
      expect(hotfix_release.authors).to eql([author])
    end
  end

  describe '#note' do
    it 'returns relase note for it' do
      expect(regular_release.note).to be_instance_of(Note)
    end
  end

  describe '#path' do
    it 'returns the release path' do
      expect(regular_release.path).to eql('tmp/Foo/releases')
    end
  end

  describe '#init_file_system!' do
    it 'calls file system with release path' do
      expect(FS).to receive(:mkdir).with(regular_release.path)

      regular_release.init_file_system!
    end
  end

  describe '#is_empty?' do
    context 'when release has not commit' do
      it 'returns true' do
        expect(empty_release.is_empty?).to be_truthy
      end
    end

    context 'when release has commits' do
      it 'returns false' do
        expect(regular_release.is_empty?).to be_falsy
      end
    end
  end

  describe '#git_changes' do
    it 'returns changes on repository by delegating it to repository' do
      allow(regular_release.application.repository).to receive(:changes_on).with(regular_release.serialization_name).and_return(:foo)

      expect(regular_release.git_changes).to eql(:foo)
    end
  end

  describe '#has_hotfix?' do
    context 'when release has a hotfix commit' do
      it 'return true' do
        expect(hotfix_release.has_hotfix?).to be_truthy
      end
    end

    context 'when relase has not hotfix commit' do
      it 'returns false' do
        expect(regular_release.has_hotfix?).to be_falsy
      end
    end
  end

end
