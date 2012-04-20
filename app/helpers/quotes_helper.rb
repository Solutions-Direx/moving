module QuotesHelper
  def calendar_item_level(quote)
    if quote.long_distance
      'info'
    elsif quote.confirmed?
      'success'
    else
      ''
    end
  end
end