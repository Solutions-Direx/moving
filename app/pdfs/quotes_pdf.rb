# encoding: utf-8
require 'open-uri'
require 'nokogiri'
require 'cgi'

class QuotesPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper

  PAGE_WIDTH = 572

  def initialize(quotes)
    super(top_margin: 20, left_margin: 20, right_margin: 20, bottom_margin: 20, page_layout: :portrait)
    @quotes = quotes

    page_layout

    number_pages "Page <page> / <total>", { :start_count_at => 1, :at => [bounds.right - 200, 5], :align => :right, :size => 8, color: 'AAAAAA' }
  end

  def page_layout
    text "<b>#{I18n.t('quotes_list', default: 'Quotes List')}</b>", inline_format: true
    move_down 20
    
    quotes_list
  end

  def quotes_list
    data = [["#{I18n.t('ID', default: 'ID')}",
  	       "Client",
  	       "#{I18n.t('removal_at', default: 'Removal at')}",
  	       "#{I18n.t('creator', default: 'Creator')}",
  	       "#{I18n.t('company')}"
  	       ]]
    @quotes.each do |quote|
  	  data += [["#{quote.code}", "#{quote.client.name}", "#{I18n.l(quote.removal_at, format: :short)}", "#{quote.creator.first_name}", "#{quote.company.company_name}"]]
    end
    
    table(data, header: true, :row_colors => ["F0F0F0", "FFFFFF"]) do
      cells.colors = ["F0F0F0", "FFFFFF"],
      cells.size = 11,
      cells.borders = [:bottom],
      row(0).font_style = :bold
    end
  end

end