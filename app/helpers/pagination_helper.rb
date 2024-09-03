module PaginationHelper
  def show_paginator?
   @pagy.pages > 1
  end
end