module DocumentsHelper
  def show(x, prefix="")
    return "" unless x
    prefix + h(x) + "<br />"
  end
end
