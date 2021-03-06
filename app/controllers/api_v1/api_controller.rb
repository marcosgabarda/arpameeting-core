class ApiV1::APIController < ApplicationController
  #skip_before_filter :rss_token, :recent_projects, :touch_user, :verify_authenticity_token, :add_chrome_frame_header

  API_LIMIT = 50

  protected

    def check_api_signed_in
        authenticate_or_request_with_http_basic('Authentication') do |username, password|
            user = User.authenticate(username, password)
            if !user.nil?
                sign_in user
            end
            !user.nil?
        end
    end

  # Common api helpers
  
  #format.xml { render :xml => @room.to_xml(:include => [:phonebrowser_service, :participants]) } #.to_xml(:include => :phonebrowser_service)
  #format.json {render :json => @room.to_json(:include => [:phonebrowser_service, :participants]) }
  
    def api_respond(object, options={})
        respond_to do |format|
            format.html { render :xml  => object.to_xml(options)  }
            format.xml  { render :xml  => object.to_xml(options)  }
            format.json { render :json => object.to_json(options) }
            #format.json { render :json => api_wrap(object, options).to_json }
            #format.js   { render :json => api_wrap(object, options).to_json, :callback => params[:callback] }
        end
    end
  
    def api_error(status_code, opts={})
        errors = {}
        errors[:type] = opts[:type] if opts[:type]
        errors[:message] = opts[:message] if opts[:message]
        respond_to do |format|
            format.xml  { render :xml  => {:errors => errors}.to_xml, :status => status_code }
            format.json { render :json => {:errors => errors}.to_json, :status => status_code }
            #format.js { render :json => {:errors => errors}.to_json, :status => status_code, :callback => params[:callback] }
        end
    end
  
  
  # BEGIN Code from Teambox
  
  def api_status(status)
    respond_to do |f|
      f.json { render :json => {:status => status}.to_json, :status => status }
      f.js   { render :json => {:status => status}.to_json, :status => status, :callback => params[:callback] }
    end
  end
  
  def api_wrap(object, options={})
    objects = if object.respond_to? :each
      object.map{|o| o.to_api_hash(options) }
    else
      object.to_api_hash(options)
    end
    
    if options[:references] || options[:reference_collections]
      { :objects => objects }.tap do |wrap|
        # List of messages to send to the object to get referenced objects
        if options[:references]
          wrap[:references] = Array(object).map do |obj|
            options[:references].map{|ref| obj.send(ref) }.flatten.compact
          end.flatten.uniq.map{|o| o.to_api_hash(options.merge(:emit_type => true))}
        end
        
        # List of messages to send to the object to get referenced objects as [:class, id]
        if options[:reference_collections]
          query = {}
          Array(object).each do |obj|
            options[:reference_collections].each do |ref|
              obj_query = obj.send(ref)
              if obj_query
                query[obj_query[0]] ||= []
                query[obj_query[0]] << obj_query[1]
              end
            end
          end
          
          wrap[:references] = (wrap[:references]||[]) + (query.map do |query_class, values|
            objects = Kernel.const_get(query_class).find(:all, :conditions => {:id => values.uniq})
            objects.uniq.map{|o| o.to_api_hash(options.merge(:emit_type => true))}
          end.flatten)
        end
      end
    else
      objects
    end
  end
  
  def handle_api_error(object,options={})
    errors = object.try(:errors)||{}
    errors[:type] = 'InvalidRecord'
    errors[:message] = 'One or more fields were invalid'
    respond_to do |f|
      f.json { render :json => {:errors => errors}.to_json, :status => options.delete(:status) || :unprocessable_entity }
      f.js   { render :json => {:errors => errors}.to_json, :status => options.delete(:status) || :unprocessable_entity, :callback => params[:callback] }
    end
  end
  
  def handle_api_success(object,options={})
    respond_to do |f|
      if options.delete(:is_new) || false
        f.json { render :json => api_wrap(object, options).to_json, :status => options.delete(:status) || :created }
        f.js   { render :json => api_wrap(object, options).to_json, :status => options.delete(:status) || :created }
      else
        f.json { head(options.delete(:status) || :ok) }
        f.js   { render :json => {:status => options.delete(:status) || :ok}.to_json, :callback => params[:callback] }
      end
    end
  end
  
  def api_truth(value)
    ['true', '1'].include?(value) ? true : false
  end
  
  def api_limit
    if params[:count]
      [params[:count].to_i, API_LIMIT].min
    else
      API_LIMIT
    end
  end
  
  def api_range
    since_id = params[:since_id]
    max_id = params[:max_id]
    
    if since_id and max_id
      ['id > ? AND id < ?', since_id, max_id]
    elsif since_id
      ['id > ?', since_id]
    elsif max_id
      ['id < ?', max_id]
    else
      []
    end
  end
  
  def set_client
    request.format = :json unless request.format == :js
  end
  
  # END Code from Teambox
  
end
