require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of :content }
  end

  describe 'database columns' do
    it { should have_db_column :content }
    it { should have_db_column :article_id }
    it { should have_db_column :user_id }
  end

  describe 'associations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :article }
  end
end
