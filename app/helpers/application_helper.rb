# The methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def site_title()
    @app_config["app_name"]
  end

  def primary_user?
    !current_user.nil? && !@account.nil? && @account.primary_person_id == current_user.id
  end

  def main_site?
    @account.nil? || ['', 'www'].include?(@account.subdomain)
  end

  def base_url(account = nil)
    account ||= Account.find_by_subdomain("www") 
    "#{account.subdomain.downcase}.#{@app_config["domain"]}"
  end

  def display_notice
    if flash[:notice]
      return %*
                  <div id="notice" style="display: none;"><p>#{h flash[:notice]}</p></div>
                  <script type="text/javascript">
                  //<![CDATA[
                    addLoadEvent(new Effect.Appear('notice'));
                  //]]>
                  </script>
              *
    end
  end

  def display_error
    if flash[:error]
      return %*
                  <div id="error"><p>#{h flash[:error]}</p></div>
                  <script type="text/javascript">
                  //<![CDATA[
                    addLoadEvent(new Effect.Appear('error'));
                  //]]>
                  </script>
              *
    end
  end

  def submit_link (txt, frm, *options)
    link_to_function txt, "$('#{frm}').submit()", *options
  end
  
  def render_cancel_button
    render :partial => 'widgets/cancel'
  end

  def fmt_currency(amt)
    number_to_currency(amt, { :unit => '' })
  end

  def fmt_percentage(amt)
    number_to_percentage(amt, { :precision => 2 })
  end

  def fmt_date(dt)
    dt.strftime("%d %b %Y")
  end

  def link_to_section(name, html_opts={}, &block)
    section_id = name.underscore.gsub(/\s+/,'_')
    link_id = section_id + '_link'
    # Link
    concat(link_to_function(name, update_page{ |page| 
      page[section_id].show
      page[link_id].hide
    }, html_opts.update(:id => link_id)))
    # Hidden section
    concat(tag('div', { :id => section_id, :style => 'display: none;' }, true))
    yield update_page{|page| 
      page[section_id].hide
      page[link_id].show        
    }
    concat('</div>')
  end

end
