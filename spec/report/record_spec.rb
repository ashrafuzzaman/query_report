require 'spec_helper'
require 'query_report/column'
require 'query_report/record'

describe QueryReport::Record do
  class DummyClass
    include QueryReport::Record
  end
  let(:object) { DummyClass.new }

  describe '#map_rowspan' do
    before do
      @columns = [QueryReport::ColumnModule::Column.new(object, :name, as: 'Name', rowspan: true),
                  QueryReport::ColumnModule::Column.new(object, :email, as: 'Email', rowspan: true)]
      object.instance_variable_set(:@columns, @columns)
      object.stub(:records).and_return([
                                           {'Name' => 'ashraf', 'Email' => 'ashraf@moteel.com', 'Content' => 1},
                                           {'Name' => 'ashraf', 'Email' => 'ashraf@tasawr.com', 'Content' => 2},
                                           {'Name' => 'zahid', 'Email' => 'zahid@gmail.com', 'Content' => 3},
                                           {'Name' => 'zahid', 'Email' => 'zahid@gmail.com', 'Content' => 4},
                                           {'Name' => 'zahid', 'Email' => 'zahid@sympaticosoftware.com', 'Content' => 5},
                                           {'Name' => 'zahid', 'Email' => 'zahid@sympaticosoftware.com', 'Content' => 6}
                                       ])
    end

    subject { object.records_with_rowspan }
    its([0]) { should == {"Name" => {:content => "ashraf", :rowspan => 2},
                          "Email" => {:content => "ashraf@moteel.com", :rowspan => 1},
                          "Content" => 1} }
    its([1]) { should == {"Email" => {:content => "ashraf@tasawr.com", :rowspan => 1},
                          "Content" => 2} }
    its([2]) { should == {"Name" => {:content => "zahid", :rowspan => 4},
                          "Email" => {:content => "zahid@gmail.com", :rowspan => 2},
                          "Content" => 3} }
    its([3]) { should == {"Content" => 4} }
  end
end