require 'spec_helper'

describe Author do

  let(:empty_config)   { fixture :configuration, whitelisted_authors_regex: nil, whitelisted_authors: nil }
  let(:regex_config_1) { fixture :configuration, whitelisted_authors_regex: 'foo@.+', whitelisted_authors: nil }
  let(:regex_config_2) { fixture :configuration, whitelisted_authors_regex: 'zoo@.+', whitelisted_authors: nil }

  subject { fixture :author }

  describe '#==' do
    context 'when the argument does not respond to #email' do
      it 'returns false' do
        expect(subject == Hash.new).to be_falsy
      end
    end

    context 'when the argument respond to #email' do
      context 'when the emails of authors are same' do
        let(:author) { Author.new(nil, 'Alice', 'foo@bar') }

        it 'returns true' do
          expect(subject == author).to be_truthy
        end
      end

      context 'when the emails of authors are not same' do
        let(:author) { Author.new(nil, 'John Doe', 'foo@bar.zoo') }

        it 'returns false' do
          expect(subject == author).to be_falsy
        end
      end
    end
  end

  describe '#is_notifiable?' do
    context 'when neither regex nor list configuration provided' do
      before { allow(subject).to receive(:application_config).and_return(empty_config) }

      it 'returns true' do
        expect(subject.is_notifiable?).to be_truthy
      end
    end

    context 'when whitelisted_authors_regex configuration is provided' do
      context 'when the email of author does not match with configuration' do
        before { allow(subject).to receive(:application_config).and_return(regex_config_2) }

        context 'when whitelisted_list configuration is not provided' do
          it 'returns false' do
            expect(subject.is_notifiable?).to be_falsy
          end
        end

        context 'when whitelisted_list configuration is provided' do
          context 'when the author email is whitelisted' do
            before { allow(subject).to receive(:whitelisted_list).and_return([subject.email]) }

            it 'returns false' do
              expect(subject.is_notifiable?).to be_truthy
            end

            context 'when the author email is not whitelisted' do
              before { allow(subject).to receive(:whitelisted_list).and_return([nil]) }

              it 'returns false' do
                expect(subject.is_notifiable?).to be_falsy
              end
            end
          end
        end
      end

      context 'when the email of author matches with configuration' do
        before { allow(subject).to receive(:application_config).and_return(regex_config_1) }

        it 'returns true' do
          expect(subject.is_notifiable?).to be_truthy
        end
      end
    end

    context 'when whitelisted_authors configuration is provided' do
      context 'when the author email is whitelisted' do
        before { allow(subject).to receive(:whitelisted_list).and_return([subject.email]) }

        it 'returns false' do
          expect(subject.is_notifiable?).to be_truthy
        end

        context 'when the author email is not whitelisted' do
          before { allow(subject).to receive(:whitelisted_list).and_return([nil]) }

          it 'returns false' do
            expect(subject.is_notifiable?).to be_falsy
          end
        end
      end
    end
  end

end
