class HomeController < ApplicationController

	before_action :authenticate_user!, :only => :determine
	require "ipaddr"
	
	def remote_ip	
    	locIp = IPAddr.new("127.0.0.1")
		remIP = IPAddr.new(request.remote_ip)
    	if remIP === locIp
      		# Hard coded remote address for test
      		#IPAddr.new("123.45.67.89")
      		IPAddr.new("140.112.12.34")
    	else
      		remIP
    	end
  	end

	def determine
		
		if user_signed_in?
			session[:username] = "anonymous"
			redirect_to :action => "index"
			return
		end
		# 未授權過的session，則檢查來query本頁面的 IP 為何
  		# 看此 IP 是否為允許範圍內
  		ntuIP = IPAddr.new("140.112.0.0/16")
  		if (ntuIP === remote_ip)
  			#在此 session 標上已授權記號
    		session[:username] = "anonymous"
    		redirect_to :action => "index"
    	else
    		redirect_to "users/sign_in"
  		end

	end


	def index
		# 若此session無 已授權 標示，導回首頁
  		#if session[:username] == nil
    	#	redirect_to :action => "determine"
		#	return
  		#end
  
  		# 執行秀出已授權可看的畫面內容
  		@informations = Information.order('date DESC').page(params[:page]).per(6)
	end

end
