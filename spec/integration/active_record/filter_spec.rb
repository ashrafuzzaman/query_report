require 'spec_helper'
require 'ransack'
require 'integration_helper'

describe 'filter' do
  let(:user_aged_10) { User.create(name: 'User#1', age: 10, dob: 10.years.ago, email: 'user1@gmail.com') }
  let(:user_aged_20) { User.create(name: 'User#2', age: 20, dob: 20.years.ago, email: 'user2@gmail.com') }
  let(:user_aged_30) { User.create(name: 'User#3', age: 30) }

  before do
    user_aged_10 && user_aged_20 && user_aged_30
  end

  context 'without any filter applied' do
    subject(:report) do
      reporter(User.send(ACTIVE_RECORD_SCOPE)) do
        filter :dob, type: :datetime, default: [21.years.ago, 1.months.from_now]
        column :name
      end
    end
    it("returns records") { expect(report.records).to eq [{'Name' => user_aged_10.name}, {'Name' => user_aged_20.name}] }
  end

  context 'with sorting applied' do
    context 'with ASC sorting' do
      subject(:report) do
        reporter(User.send(ACTIVE_RECORD_SCOPE), {q: {s: 'age ASC'}}) do
          filter :age
          column :name
        end
      end
      it("returns records") { expect(report.records).to eq [{'Name' => user_aged_10.name}, {'Name' => user_aged_20.name}, {'Name' => user_aged_30.name}] }
    end

    context 'with DESC sorting' do
      subject(:report) do
        reporter(User.send(ACTIVE_RECORD_SCOPE), {q: {s: 'age DESC'}}) do
          column :age
        end
      end
      it("returns records") { expect(report.records).to eq [{'Age' => 30}, {'Age' => 20}, {'Age' => 10}] }
    end
  end

  context 'with filter applied' do
    subject(:report) do
      reporter(User.send(ACTIVE_RECORD_SCOPE), {q: {age_eq: '30'}}) do
        column :age
      end
    end
    it("returns records") { expect(report.records).to eq [{'Age' => 30}] }
  end
end