require 'spec_helper'

describe Commit do

  let(:regular_commit) { fixture :commit }
  let(:hotfix_commit)  { fixture :commit, :hotfix }

  describe '#pretty_date' do
    it 'returns the date in pretty format' do
      expect(regular_commit.pretty_date).to eql('1923-10-29 00:00')
    end
  end

  describe '#is_hotfix?' do
    context 'when message matches with the HOTFIX pattern' do
      it 'returns true' do
        expect(hotfix_commit.is_hotfix?).to be_truthy
      end
    end

    context 'when message does not match with the HOTFIX pattern' do
      it 'returns false' do
        expect(regular_commit.is_hotfix?).to be_falsy
      end
    end
  end

end
