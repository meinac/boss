require 'spec_helper'

describe Repository do

  let(:repo_path)  { File.expand_path('tmp/dummy_git_repo') }
  let(:repository) { fixture :repository, remote_url: repo_path }

  # Steps are crucial to properly do integration test.
  # I just don't want to mock Git module.
  before do
    repository.application.init_file_system!
    repository.init_file_system!
    FS.mkdir(repo_path)
    FS.run_in_dir(repo_path) do
      Git.init('.')
      Git.commit('First commit')
    end
  end

  after do
    FS.run_in_dir(repository.path) { `rm -rf #{repo_path}` }
  end

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
      FS.run_in_dir(repo_path) { Git.commit('Test commit') }
    end

    after do
      FS.run_in_dir(repo_path) { Git.reset(1) }
      FS.run_in_dir(repository.path) { `touch .keep` }
    end

    it 'returns the changes between given branch compared to base branch' do
      changes = repository.changes_on('foo')

      expect(changes).to match(/Test\scommit/)
    end
  end

end
