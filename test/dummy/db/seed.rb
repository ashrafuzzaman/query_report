r = Random.new
1.upto(100) do |i|
  Invoice.create(title: "Invoice ##{i}", total_paid: r.rand(100) + 200, total_charged: r.rand(500) + 200)
end