# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  MCE_OPTIONS = {:options => {
    :theme => 'advanced',
    :cleanup_on_startup => true,
    :width => '100%',
    :height => '480',
    :valid_elements => '+a[href],-strong/-b,-em/-i/-u,-strike,#p[align],-ol,-ul,-li,br,img[src|alt=|title|hspace|vspace|width|height|align],-sub,-sup,-blockquote,-table[border=0|cellspacing|cellpadding|width|height|align|summary],-tr[rowspan|width|height|align|valign],tbody,thead,tfoot,-td[colspan|rowspan|width|height|align|valign|scope],-th[colspan|rowspan|width|height|align|valign|scope],caption,-div[align],-span[align],-pre,address,-h1,-h2,-h3,-h4,-h5,-h6,hr,dd,dl,dt'
    }}

  def authorized?
    session[:authenticated]
  end
  helper_method :authorized?

  def check_user_is_admin
    unless authorized?
      redirect_to :controller => 'login', :action => 'login'
    end
  end
end