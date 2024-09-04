module SavedListingsHelper

  def save_button(listing)
    if logged_in? && listing.saved? && listing.can_save?
      content_tag :span, class: "icon-text" do
        svg("heart", class: "icon is-small", fill: "#f00")
      end
    end
  end

end
