require 'spec_helper'

describe Repository do

  let(:remote_url) { File.expand_path('spec/fixtures/dummy_git_repo') }
  let(:repository) { fixture :repository, remote_url: remote_url }

  describe '#path' do
    it 'returns the scm path on file system' do
      expect(repository.path).to eql('tmp/Foo/scm')
    end
  end

  describe '#init_file_system!' do
    it 'clones remote git repository' do
      begin
        FS.run_in_dir(repository.path) { `rm -rf .git .keep` }

        expect {
          repository.init_file_system!
        }.to change { repository.send(:repository_initalized?) }.from(false).to(true)
      ensure
        FS.run_in_dir(repository.path) { `touch .keep` }
      end
    end
  end

  describe '#changes_on' do
    before do
      FS.run_in_dir(repository.path) { `rm -rf .git .keep` }
      repository.init_file_system!
      FS.run_in_dir(remote_url) { Git.commit('Test commit') }
    end

    after do
      FS.run_in_dir(remote_url) { Git.reset(1) }
      FS.run_in_dir(repository.path) { `touch .keep` }
    end

    it 'returns the changes between given branch compared to base branch' do
      changes = repository.changes_on('foo')

      expect(changes).to match(/Test\scommit/)
    end
  end

end
