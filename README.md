# QueryReport
The purpose of this gem is to create reports with just the basic query with the built in following features,
*   Pagination (with Kaminari)
*   Basic filters (with Ransack)
*   Custom filter
*   Export with html, PDF (with Prawn PDF), CSV, JSON

The gem is still in infant stage. So I would just ask you to keep an eye on this for now.

## Installation

Add this line to your application's Gemfile:

    gem 'query_report'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install query_report

## Usage

In your controller add,
```ruby
require 'query_report/helper'
```

And include,
```ruby
include QueryReport::Helper
```

Then add

```ruby
def invoice
  query = Invoice.includes(:invoiced_to => {:user => :profile})
  reporter(query) do
    scope :unpaid

    filter :invoiced_on, type: :date
    filter :title, type: :text
    filter :invoiced_to, type: :user

    column :id, as: 'Invoice#'
    column :title
    column 'Invoiced to' do |invoice|
      invoice.invoiced_to.user.name
    end
    column :total_charged, as: 'Charged'
    column :total_paid, as: 'Paid'

    pie_chart('Charged VS Paid') do
      add 'Total un paid charge' do |query|
        query.sum(:total_charged) - query.sum(:total_paid)
      end
      add 'Total paid' do |query|
        query.sum(:total_paid)
      end
    end
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
