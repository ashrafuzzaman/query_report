[Query report](http://ashrafuzzaman.github.io/query_report/) By [Ashrafuzzaman](http://ashrafuzzaman.github.io).

[![Build Status](https://api.travis-ci.org/ashrafuzzaman/query_report.png?branch=master)](http://travis-ci.org/ashrafuzzaman/query_report)
[![Gem Version](https://badge.fury.io/rb/query_report.png)](http://badge.fury.io/rb/query_report)

Query report is a reporting tool, which does the following:

* Generate paginated HTML view with filters, defined columns with sorting
* Generate PDF, CSV, JSON
* Provide feature to define re usable custom filter

As built in filter I have used [ransack](https://github.com/ernie/ransack) and pagination with [kaminari](https://github.com/amatsuda/kaminari)

For a demo see [here](http://query-report-demo.herokuapp.com)

## The purpose
The purpose of this gem is to produce consistent reports quickly and manage them easily. Because all we need to
concentrate in a report is the query and filter.

## Getting started
Query report is tested with Rails 3. You can add it to your Gemfile with:

```ruby
gem "query_report"
```

Run the bundle command to install it.

Here is a sample controller which uses query report. And that is all you need, query report will generate all the view for you.

```ruby
require 'query_report/helper'  #need to require the helper

class InvoicesController < ApplicationController
  include QueryReport::Helper  #need to include it

  def index
    @invoices = Invoice.scoped

    reporter(@invoices) do
      filter :title, type: :text
      filter :created_at, type: :date, default: [5.months.ago, 1.months.from_now]
      filter :paid, type: :boolean, default: false

      column :title do |invoice|
        link_to invoice.title, invoice
      end
      column :total_paid
      column :total_charged
      column :paid
    end
  end
end
```

## License
MIT License. Copyright © 2013 [Ashrafuzzaman](http://ashrafuzzaman.github.io). See MIT-LICENSE for further details.

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/ashrafuzzaman/query_report/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

