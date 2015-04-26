module ResponsibilitiesHelper

  def can_be_deleted(responsibility)
    responsibility.author != responsibility.document.author
  end
end
